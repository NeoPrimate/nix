# List recipes
default:
    @just --list

# Commit + push any changes (if dirty), then deploy
sync message="update configs":
    #!/usr/bin/env bash
    set -euo pipefail
    git add -A
    if ! git diff --cached --quiet; then
        git commit -m "{{ message }}"
        git push
    else
        echo "Nothing to commit."
    fi
    dotter deploy --force

# Pull latest and re-deploy
pull:
    git pull
    dotter deploy --force

# One-time macOS system setup (installs LaunchDaemons for autostart)
bootstrap-macos:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$(uname)" == "Darwin" ]] || { echo "macOS only"; exit 1; }
    [[ -f "$HOME/.config/kanata/kanata.kbd" ]] || { echo "Run 'just sync' first."; exit 1; }
    command -v kanata >/dev/null || { echo "Install kanata: brew install kanata"; exit 1; }

    SRC_DIR="$HOME/dotfiles/launchd"
    DEST_DIR="/Library/LaunchDaemons"
    KARABINER="org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon"
    KANATA="com.vb.kanata"

    echo "Installing LaunchDaemons (will prompt for sudo)..."
    sudo mkdir -p /Library/Logs/Kanata

    for label in "$KARABINER" "$KANATA"; do
        sudo cp "$SRC_DIR/$label.plist" "$DEST_DIR/$label.plist"
        sudo chown root:wheel "$DEST_DIR/$label.plist"
        sudo chmod 644 "$DEST_DIR/$label.plist"
        sudo launchctl bootout "system/$label" 2>/dev/null || true
        sudo launchctl bootstrap system "$DEST_DIR/$label.plist"
    done

    echo "Done. Grant Input Monitoring to kanata in System Settings if prompted, then 'just kanata-reload'."

# Restart kanata after editing kanata.kbd
kanata-reload:
    sudo launchctl kickstart -k system/com.vb.kanata

# Tail kanata logs
kanata-logs:
    tail -f /Library/Logs/Kanata/kanata.err.log
