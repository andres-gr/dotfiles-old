setopt nobeep

COLOR_CYAN="#8BE9FD"
COLOR_DARK="#6272A4"
COLOR_GREEN="#50FA7B"
COLOR_ORANGE="#FFB86C"
COLOR_PINK="#FF79C6"
COLOR_PURPLE="#BD93F9"
COLOR_RED="#FF5555"
COLOR_WHITE="#F8F8F2"
COLOR_YELLOW="#F1FA8C"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

typeset -U path
typeset -U fpath

export TERM="xterm-256color"
export ZSH=$HOME/.oh-my-zsh
export ANTIGEN=$HOME/.antigenrc
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANTIBODY_HOME=$HOME/.zsh

path=(/usr/local/bin $path)
path=(/usr/local/opt/ruby/bin $path)

path+=(
  $HOME/flutter/bin
  $ANDROID_HOME/tools
  $ANDROID_HOME/platform-tools
  $(ruby -e 'puts File.join(Gem.user_dir, "bin")')
  $(dirname $(gem which colorls))/tab_complete.sh
)

export PATH

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files'

# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set default editor to nvim
export EDITOR="code"

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Load antigen and plugins
source $ANTIGEN

# TMUX
# Automatically connect to a previous session if it exists
ZSH_TMUX_AUTOCONNECT=true

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
  cp $HOME/.antigenrc $HOME/devel/dotfiles/.antigenrc
  cp $HOME/.gitconfig $HOME/devel/dotfiles/.gitconfig
  cp $HOME/.tmux.conf $HOME/devel/dotfiles/.tmux.conf
  cp $HOME/.zsh/plugins.txt $HOME/devel/dotfiles/plugins.txt
  cp $HOME/.zshrc $HOME/devel/dotfiles/.zshrc
  cp $HOME/alias.zsh $HOME/devel/dotfiles/alias.zsh
  cp $HOME/Documents/com.googlecode.iterm2.plist $HOME/devel/dotfiles/com.googlecode.iterm2.plist
  cp -rf $HOME/.config/nvim/coc-settings.json $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/init.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/plugins.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/snippets $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.config/nvim/space.vim $HOME/devel/dotfiles/nvim
  cp -rf $HOME/.tmux/.git_status.sh $HOME/devel/dotfiles/tpm/
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

# Spaceship custom values
SPACESHIP_GIT_STATUS_STASHED=''

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
spaceship_git_time_since_last_commit() {
  spaceship::is_git || return

  # Only proceed if there is actually a commit.
  if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -ge 24 ]; then
      commit_age="${days}d"
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m"
    else
      commit_age="${minutes}m"
    fi

    spaceship::section "$COLOR_WHITE" "$commit_age"
  fi
}

SPACESHIP_RPROMPT_ORDER=(
  git_time_since_last_commit
)

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

source $HOME/alias.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

