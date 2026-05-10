# Dotfiles

Managed with [dotter](https://github.com/SuperCuber/dotter) and [just](https://github.com/casey/just).

Configs: Alacritty, Aerospace, Helix, Nushell, Starship, Yazi, Zed, Zellij, Zsh.

## Usage

```bash
just              # list recipes
just sync         # commit + push changes (if any), then deploy
just sync "msg"   # same, with custom commit message
just pull         # pull latest, then deploy
```

`just sync` is the daily driver — it's safe to run whether or not you have local changes.

## Install on a new machine

```bash
brew install dotter just
git clone git@github.com:NeoPrimate/Dotfiles.git ~/dotfiles
cd ~/dotfiles
dotter deploy --force
```
