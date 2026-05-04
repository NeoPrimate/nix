#!/bin/bash
cd ~/Dotfiles
git add -A
git commit -m "${1:-update configs}"
git push
dotter deploy --force