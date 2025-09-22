#!/usr/bin/env bash

# Launch kitty directly in Tools directory with tmux
exec kitty bash -c "
  cd ~/projects/Tools/ || exit 1
  exec tmux new-session -s Tools
"

