# If you come from bash you might have to change your $PATH.
export PATH="/usr/local/opt/node@10/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$HOME/flutter/bin:$PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export TERM="xterm-256color"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git node tmux zsh-syntax-highlighting zsh-autosuggestions zsh-completions)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

source $HOME/.bash_aliases

# TMUX
# Automatically start tmux
ZSH_TMUX_AUTOSTART=true

# Automatically connect to a previous session if it exists
ZSH_TMUX_AUTOCONNECT=true

# ZSH_TMUX_ITERM2=true

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

prompt_context(){}

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files'

# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
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

  if [[ -n $file ]]
  then
     vim $file +$line
  fi
}

cpdtfls() {
  cp $HOME/.zshrc $HOME/devel/dotfiles/.zshrc
  cp $HOME/.tmux.conf $HOME/devel/dotfiles/.tmux.conf
  cp $HOME/.bash_aliases $HOME/devel/dotfiles/.bash_aliases
  cp $HOME/.config/nvim/init.vim $HOME/devel/dotfiles/nvim
  cp $HOME/.config/nvim/plugins.vim $HOME/devel/dotfiles/nvim
  cp $HOME/.config/nvim/space.vim $HOME/devel/dotfiles/nvim
  cp $HOME/.config/nvim/coc-settings.json $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/snippets $HOME/devel/dotfiles/nvim
}

# Enabled zsh-autosuggestions
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# Set default editor to nvim
# export EDITOR='nvim'

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Set Spaceship as prompt
autoload -U promptinit; promptinit
prompt spaceship
# SPACESHIP_PACKAGE_SHOW=false
# SPACESHIP_NODE_SHOW=false
SPACESHIP_GIT_STATUS_STASHED=''