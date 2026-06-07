export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR="hx"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# eval "$(zellij setup --generate-auto-start zsh)"

if [[ -z "$ZED_TERM" && "$TERM_PROGRAM" != "zed" ]]; then
    eval "$(zellij setup --generate-auto-start zsh)"
fi

# alias ls="eza -lh --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions" # --sort=modified -lh
alias ..="cd .."

alias cqlsh=/Users/vb/Library/Python/3.9/bin/cqlsh

# history substring search options
export AICHAT_CONFIG_DIR="$HOME/.config/aichat"

. "$HOME/.local/bin/env"
source $HOME/.local/bin/env

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

