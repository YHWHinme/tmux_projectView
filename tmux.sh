#!/usr/bin/env bash

CONFIG="/home/oj2/dotfiles/.config/hypr/scripts/deps/sessions.jsonc"

# Extract session names for rofi
PROJECTS=$(jq -r '.projects[].name' "$CONFIG" | rofi -dmenu -p "Select tmux session:")

# Exit if nothing chosen
[ -z "$PROJECTS" ] && exit 0

# Parse session info
PROJECT_INFO=$(jq -r ".projects[] | select(.name==\"$PROJECTS\")" "$CONFIG")
DIR=$(echo "$PROJECT_INFO" | jq -r '.directory')

# Launch kitty with tmux in the specified directory
exec kitty bash -c "
  cd $DIR || exit 1
  if tmux has-session -t \"$PROJECTS\" 2>/dev/null; then
    exec tmux attach-session -t \"$PROJECTS\"
  else
    exec tmux new-session -s \"$PROJECTS\"
  fi
"

