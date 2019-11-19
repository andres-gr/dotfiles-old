export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

path=(/usr/local/bin $path)
path=(/usr/local/opt/ruby/bin $path)

path+=(
  $HOME/flutter/bin
  $ANDROID_HOME/tools
  $ANDROID_HOME/platform-tools
  $(ruby -e 'puts File.join(Gem.user_dir, "bin")')
)

export PATH
export TERM="xterm-256color"
export ZSH=$HOME/.oh-my-zsh
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANTIBODY_HOME=$HOME/.zsh

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files'

# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set default editor to nvim
# export EDITOR='nvim'

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  node
  npm
  tmux
)

source $ZSH/oh-my-zsh.sh

source $HOME/alias.zsh

source $HOME/.zsh/plugins.sh

autoload -Uz compinit && compinit

# TMUX
# Automatically start tmux
ZSH_TMUX_AUTOSTART=true

# Automatically connect to a previous session if it exists
ZSH_TMUX_AUTOCONNECT=true

ZSH_TMUX_ITERM2=true

# Enable command auto-correction.
# ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

prompt_context(){}

# Set location of z installation
. /usr/local/etc/profile.d/z.sh

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fh [FUZZY PATTERN] - Search in command history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fbr [FUZZY PATTERN] - Checkout specified branch
# Include remote branches, sorted by most recent commit and limited to 30
fgb() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) && git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# tm [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
ftm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# tm [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tm` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftm` will delete that session if it exists
ftmk() {
  if [ $1 ]; then
    tmux kill-session -t "$1"; return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux kill-session -t "$session" || echo "No session found to delete."
}

# fuzzy grep via rg and open in vim with line number
fgr() {
  local file
  local line

  read -r file line <<<"$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]; then
    vim $file +$line
  fi
}

cpdtfls() {
  cp $HOME/.zshrc $HOME/devel/dotfiles/.zshrc
  cp $HOME/.tmux.conf $HOME/devel/dotfiles/.tmux.conf
  cp $HOME/alias.zsh $HOME/devel/dotfiles/alias.zsh
  cp $HOME/.zsh/plugins.txt $HOME/devel/dotfiles/plugins.txt
  cp -rf $HOME/.config/nvim/init.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/plugins.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/space.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/coc-settings.json $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/snippets $HOME/devel/dotfiles/nvim
}

cdpm() {
  if [ -z $1 ]; then
    echo $1
    cd $(pm gp)
  else
    cd $(pm gp $1)
  fi
}

FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
FAST_HIGHLIGHT_STYLES[precommand]='fg=green'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=cyan'

# Set Spaceship as prompt
autoload -U promptinit; promptinit
prompt spaceship

# SPACESHIP_PACKAGE_SHOW=false
# SPACESHIP_NODE_SHOW=false
SPACESHIP_GIT_STATUS_STASHED=''

source $(dirname $(gem which colorls))/tab_complete.sh

declare -a NODE_GLOBALS_NPM=(`find $HOME/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*'`)
declare -a NODE_GLOBALS=(`echo $NODE_GLOBALS_NPM | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

load_nvm () {
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  export NODE_PATH="$NVM_BIN"
}

for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done
