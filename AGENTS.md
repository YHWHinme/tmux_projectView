# AGENTS.md

## Recent Changes
- ✅ **tmux.sh fixed**: Resolved tilde expansion bug in directory navigation by removing quotes around `$DIR` in cd command (allows `~` expansion like something.sh)

## Build/Lint/Test Commands
- **Lint**: `shellcheck *.sh` - Check shell script syntax and style
- **Syntax check**: `bash -n *.sh` - Validate bash syntax without execution
- **Test single script**: `bash -x script.sh` - Execute with debug tracing
- No build system - these are standalone shell scripts

## Code Style Guidelines

### Shell Scripts
- Use `#!/usr/bin/env bash` shebang
- UPPER_CASE for constants and config variables (CONFIG, SESSION, DIR)
- Quote all variables: `"$VAR"` not `$VAR`
- Use `exec` for final commands to replace shell process
- Exit with code 1 on errors, 0 on success
- Use `2>/dev/null` to suppress stderr when appropriate
- Use `jq` for JSON parsing with `-r` flag for raw output
- Use `rofi -dmenu` for interactive selection
- Launch tmux sessions with proper attach/new logic
- Use `cd $DIR || exit 1` for directory changes with error handling (allows tilde expansion)

### Error Handling
- Check command success with `|| exit 1`
- Validate variables with `[ -z "$VAR" ] && exit 0`
- Use `2>/dev/null` for optional operations

### Dependencies
- kitty (terminal emulator)
- tmux (session manager)
- jq (JSON processor)
- rofi (menu selector)