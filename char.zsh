#
# Prompt character
#

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_CHAR_PREFIX="${SPACESHIP_CHAR_PREFIX=""}"
SPACESHIP_CHAR_SUFFIX="${SPACESHIP_CHAR_SUFFIX=""}"
SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="➜ "}"
SPACESHIP_CHAR_SYMBOL_ROOT="${SPACESHIP_CHAR_SYMBOL_ROOT="$SPACESHIP_CHAR_SYMBOL"}"
SPACESHIP_CHAR_SYMBOL_SECONDARY="${SPACESHIP_CHAR_SYMBOL_SECONDARY="$SPACESHIP_CHAR_SYMBOL"}"
SPACESHIP_CHAR_COLOR_SUCCESS="${SPACESHIP_CHAR_COLOR_SUCCESS="green"}"
SPACESHIP_CHAR_COLOR_FAILURE="${SPACESHIP_CHAR_COLOR_FAILURE="red"}"
SPACESHIP_CHAR_COLOR_SECONDARY="${SPACESHIP_CHAR_COLOR_SECONDARY="yellow"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Paint $PROMPT_SYMBOL in red if previous command was fail and
# paint in green if everything was OK.
spaceship_char() {
  local 'color' 'char' 'prefix'

  char="$SPACESHIP_CHAR_SYMBOL"

  if [[ $RETVAL -eq 0 ]]; then
    color="$SPACESHIP_CHAR_COLOR_SUCCESS"
    if [[ $UID -eq 0 ]]; then
      char="$SPACESHIP_CHAR_SYMBOL_ROOT"
      prefix="🛸 "
    else
      prefix="🚀 "
    fi
  else
    color="$SPACESHIP_CHAR_COLOR_FAILURE"
    prefix="💥 "
  fi

  spaceship::section \
    "$color" \
    "$prefix" \
    "$char" \
    "$SPACESHIP_CHAR_SUFFIX"
}
