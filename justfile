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
