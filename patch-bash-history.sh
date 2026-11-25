#!/usr/bin/env bash
#
# Better Bash History - Production Configuration Patcher
#
# Source:
# https://blog.sanctum.geek.nz/better-bash-history/
#
# Target: Linux / GNU utilities
# Scope: Current user (~/.bashrc)
#
# Features:
#   - Timestamped command history
#   - Shared history across terminal sessions
#   - Immediate history saving
#   - Import history from other sessions
#   - Multiline command support
#   - Duplicate command filtering
#   - Ignore commands starting with spaces
#   - Ctrl+R reverse history search
#   - Automatic backup
#   - Idempotent configuration updates
#   - Configuration validation
#
# Usage:
#   chmod +x patch-bash-history.sh
#   ./patch-bash-history.sh
#
# Optional:
#   ./patch-bash-history.sh /path/to/.bashrc

set -Eeuo pipefail

# --------------------------------------------------
# 1. Configuration
# --------------------------------------------------

BASHRC="${1:-${HOME}/.bashrc}"

START_MARKER="# >>> BETTER BASH HISTORY CONFIG >>>"
END_MARKER="# <<< BETTER BASH HISTORY CONFIG <<<"

SCRIPT_NAME="Better Bash History"

# --------------------------------------------------
# 2. Error handling and cleanup
# --------------------------------------------------

TEMP_FILE=""

cleanup() {
    if [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]]; then
        rm -f -- "$TEMP_FILE"
    fi
}

error_handler() {
    local exit_code=$?
    echo "[ERROR] ${SCRIPT_NAME} failed (exit code: ${exit_code})." >&2
    exit "$exit_code"
}

trap cleanup EXIT
trap error_handler ERR

# --------------------------------------------------
# 3. Validate target
# --------------------------------------------------

if [[ -z "$BASHRC" ]]; then
    echo "[ERROR] Empty configuration path." >&2
    exit 1
fi

BASHRC_DIR=$(dirname -- "$BASHRC")

if [[ ! -d "$BASHRC_DIR" ]]; then
    echo "[ERROR] Directory does not exist: $BASHRC_DIR" >&2
    exit 1
fi

# Refuse symlinks to avoid replacing the symlink itself.
if [[ -L "$BASHRC" ]]; then
    echo "[ERROR] Symbolic links are not supported: $BASHRC" >&2
    exit 1
fi

# Create the file if it does not exist.
if [[ ! -e "$BASHRC" ]]; then
    touch -- "$BASHRC"
fi

if [[ ! -f "$BASHRC" || ! -r "$BASHRC" || ! -w "$BASHRC" ]]; then
    echo "[ERROR] Target must be a readable and writable regular file." >&2
    exit 1
fi

echo "[INFO] Target: $BASHRC"

# --------------------------------------------------
# 4. Create timestamped backup
# --------------------------------------------------

BACKUP="${BASHRC}.backup.$(date +%Y%m%d_%H%M%S).$$"

cp -p -- "$BASHRC" "$BACKUP"

echo "[INFO] Backup created: $BACKUP"

# --------------------------------------------------
# 5. Create temporary file
# --------------------------------------------------

TEMP_FILE=$(mktemp "${BASHRC}.XXXXXX")

# --------------------------------------------------
# 6. Remove previous managed configuration
# --------------------------------------------------

echo "[INFO] Checking existing configuration..."

if ! awk \
    -v start="$START_MARKER" \
    -v end="$END_MARKER" '
    $0 == start {
        if (inside) {
            error = 1
            exit
        }
        inside = 1
        next
    }

    $0 == end {
        if (!inside) {
            error = 1
            exit
        }
        inside = 0
        next
    }

    !inside {
        print
    }

    END {
        if (inside) {
            error = 1
        }

        if (error) {
            exit 2
        }
    }
' "$BASHRC" > "$TEMP_FILE"; then

    echo "[ERROR] Invalid or incomplete configuration markers." >&2
    echo "[INFO] Original configuration was not replaced." >&2
    exit 1
fi

# --------------------------------------------------
# 7. Append improved configuration
# --------------------------------------------------

echo "[INFO] Applying Bash history configuration..."

# sed version of the same as awk
# sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$TEMP_FILE"
# :a sets a loop label.
# /^\n*$/ matches lines (or accumulated buffers) containing only newlines.
# If it's at the end of the file ($), d deletes the trailing blank lines and stops.
# Otherwise, N pulls in the next line and ba loops back to re-check. Once a non-empty line is pulled in, /^\n*$/ no longer matches, so the buffered blank lines and that line are output normally.
awk '
  /[^[:space:]]/ {
    for (i = 1; i <= blanks; i++) print ""
    blanks = 0
    print
    next
  }
  { blanks++ }
' "$TEMP_FILE" > "${TEMP_FILE}.tmp" && mv "${TEMP_FILE}.tmp" "$TEMP_FILE"
cat >> "$TEMP_FILE" <<'EOF'

# >>> BETTER BASH HISTORY CONFIG >>>
#
# Managed by patch-bash-history.sh
# Do not edit this block manually.
#

# Apply interactive history configuration only.
if [[ $- == *i* ]]; then

    # Use the default Bash history file if not already configured.
    HISTFILE="${HISTFILE:-${HOME}/.bash_history}"

    # Keep a large history in memory and on disk.
    HISTSIZE=1000000
    HISTFILESIZE=1000000

    # Ignore consecutive duplicates and commands starting with spaces.
    # Also remove older matching entries when a command is repeated.
    HISTCONTROL=ignoreboth:erasedups

    # Record command timestamps.
    HISTTIMEFORMAT='%F %T '

    # Preserve multiline commands as single history entries.
    shopt -s cmdhist

    # Append history instead of overwriting the history file.
    shopt -s histappend

    # Enable reverse history search with Ctrl+R.
    bind '"\C-r": reverse-search-history' 2>/dev/null || true

    # Synchronize history between terminal sessions.
    __better_bash_history_sync() {
        # Save new commands from this session.
        history -a

        # Import commands added by other sessions.
        history -n
    }

    # Preserve existing PROMPT_COMMAND settings.
    # Support both string and array PROMPT_COMMAND formats.
    __bh_pc_decl=$(declare -p PROMPT_COMMAND 2>/dev/null || true)

    if [[ "$__bh_pc_decl" == "declare -a"* ]]; then

        __bh_found=0

        for __bh_entry in "${PROMPT_COMMAND[@]}"; do
            if [[ "$__bh_entry" == "__better_bash_history_sync" ]]; then
                __bh_found=1
                break
            fi
        done

        if (( ! __bh_found )); then
            PROMPT_COMMAND+=(__better_bash_history_sync)
        fi

    else

        if [[ ! ";${PROMPT_COMMAND-};" =~ (^|;)[[:space:]]*__better_bash_history_sync[[:space:]]*(;|$) ]]; then
            PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }__better_bash_history_sync"
        fi

    fi

    unset __bh_pc_decl __bh_found __bh_entry

fi

# <<< BETTER BASH HISTORY CONFIG <<<
EOF

# --------------------------------------------------
# 8. Validate generated Bash configuration
# --------------------------------------------------

echo "[INFO] Validating generated configuration..."

if ! bash -n "$TEMP_FILE"; then
    echo "[ERROR] Bash syntax validation failed." >&2
    echo "[INFO] Original configuration was not replaced." >&2
    exit 1
fi

# --------------------------------------------------
# 9. Preserve original permissions
# --------------------------------------------------

chmod --reference="$BASHRC" "$TEMP_FILE"

# --------------------------------------------------
# 10. Atomically replace configuration
# --------------------------------------------------

echo "[INFO] Installing updated configuration..."

mv -f -- "$TEMP_FILE" "$BASHRC"

TEMP_FILE=""

# --------------------------------------------------
# 11. Finish
# --------------------------------------------------

echo
echo "[SUCCESS] ${SCRIPT_NAME} installed successfully."
echo
echo "[INFO] Configuration: $BASHRC"
echo "[INFO] Backup:        $BACKUP"
echo
echo "To activate the configuration, run:"
echo
echo "    source \"$BASHRC\""
echo
echo "To verify the configuration, run:"
echo
echo "    shopt histappend"
echo "    shopt cmdhist"
echo "    echo \"\$HISTCONTROL\""
echo "    echo \"\$HISTTIMEFORMAT\""
echo "    declare -p PROMPT_COMMAND"
echo
