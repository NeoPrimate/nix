host := `hostname -s | tr '[:upper:]' '[:lower:]'`

# List recipes
default:
    @just --list

# Commit + push if dirty, then activate this host
sync message="update":
    #!/usr/bin/env bash
    set -euo pipefail
    git add -A
    if ! git diff --cached --quiet; then
        git commit -m "{{ message }}"
        git push
    else
        echo "Nothing to commit."
    fi
    sudo darwin-rebuild switch --flake .#{{ host }}

# Pull latest and re-activate
pull:
    git pull
    sudo darwin-rebuild switch --flake .#{{ host }}

# Bump flake inputs and re-activate
update:
    nix flake update
    sudo darwin-rebuild switch --flake .#{{ host }}
