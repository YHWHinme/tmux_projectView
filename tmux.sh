#!/usr/bin/env bash

CONFIG="/home/oj2/dotfiles/.config/hypr/scripts/deps/sessions.jsonc"

# Extract session names for dmenu
SESSION=$(jq -r '.sessions[].name' "$CONFIG" | rofi -dmenu -p "Select tmux session:")

# Exit if nothing chosen
[ -z "$SESSION" ] && exit 0

# Parse session info
SESSION_INFO=$(jq -r ".sessions[] | select(.name==\"$SESSION\")" "$CONFIG")
DIR=$(echo "$SESSION_INFO" | jq -r '.directory')

# Launch kitty with tmux in the specified directory
exec kitty bash -c "
  cd $DIR || exit 1
  if tmux has-session -t \"$SESSION\" 2>/dev/null; then
    exec tmux attach-session -t \"$SESSION\"
  else
    exec tmux new-session -s \"$SESSION\"
  fi
"

