#!/usr/bin/env bash
# ~/.local/bin/typst-preview
# Usage: typst-preview <file> <root>

open -u http://127.0.0.1:23625 2>/dev/null
nohup tinymist preview --no-open "$1" --root "$2" > /dev/null 2>&1 &