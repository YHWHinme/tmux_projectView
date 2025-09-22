#!/usr/bin/env bash

# --- CONFIGURATION ---
SESSION_NAME="$1"          # First argument: tmux session name
SESSION_DIR="~/projects/Learning/"           # Second argument: directory to cd into

# --- CHECKS ---
if [ -z "$SESSION_NAME" ] || [ -z "$SESSION_DIR" ]; then
  echo "Usage: $0 <session_name> <directory>"
  exit 1
fi

# --- LAUNCH LOGIC ---
# Open kitty, cd into directory, and start/attach tmux session
kitty bash -c "
  cd \"$SESSION_DIR\" || exit 1
  if tmux has-session -t \"$SESSION_NAME\" 2>/dev/null; then
    exec tmux attach-session -t \"$SESSION_NAME\"
  else
    exec tmux new-session -s \"$SESSION_NAME\"
  fi
"

