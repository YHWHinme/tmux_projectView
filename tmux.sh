#!/usr/bin/env bash

CONFIG="/home/oj2/dotfiles/.config/hypr/scripts/tmux_dev/sessions.jsonc"

# Extract session names for rofi
PROJECTS=$(jq -r '.projects[].name' "$CONFIG" | rofi -dmenu -p "Select tmux session:")

# Exit if nothing chosen
[ -z "$PROJECTS" ] && exit 0

# Launch kitty with tmux in the specified directory
exec kitty bash -c "
  # Parse session info inside bash -c to avoid variable expansion issues
  PROJECT_INFO=\$(jq -r \".projects[] | select(.name==\\\"$PROJECTS\\\")\" \"$CONFIG\")
  DIR=\$(echo \"\$PROJECT_INFO\" | jq -r '.directory')
  TABS=\$(echo \"\$PROJECT_INFO\" | jq -r '.tabs // []')

  echo \"PROJECTS=\$PROJECTS\"
  echo \"PROJECT_INFO=\$PROJECT_INFO\"
  echo \"DIR=\$DIR\"

  cd \"\$DIR\" || exit 1
  if tmux has-session -t \"$PROJECTS\" 2>/dev/null; then
    exec tmux attach-session -t \"$PROJECTS\"
  else
    # Create session with first tab
    FIRST_TAB=\$(echo \"\$TABS\" | jq -r '.[0].name // \"main\"')
    tmux new-session -d -s \"$PROJECTS\" -n \"\$FIRST_TAB\"

    # Create additional tabs
    TAB_COUNT=\$(echo \"\$TABS\" | jq -r 'length')
    for ((i=1; i<TAB_COUNT; i++)); do
      TAB_NAME=\$(echo \"\$TABS\" | jq -r \".[\$i].name\")
      tmux new-window -t \"$PROJECTS\" -n \"\$TAB_NAME\"
    done

    # Select first window and attach
    tmux select-window -t \"$PROJECTS:0\"
    exec tmux attach-session -t \"$PROJECTS\"
  fi
"