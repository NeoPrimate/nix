# nix

Personal Nix config, managed with [home-manager](https://github.com/nix-community/home-manager) and [just](https://github.com/casey/just).

Configs: Alacritty, Aerospace, Ghostty, Helix, Karabiner, Nushell, Starship, Yazi, Zed, Zellij, Zsh.

## Usage

```bash
just              # list recipes
just sync         # commit + push changes (if any), then activate
just sync "msg"   # same, with custom commit message
just pull         # pull latest, then activate
just update       # bump flake inputs, then activate
```

## Install on a new machine

```bash
# 1. Install Nix (https://nixos.org/download) and just
brew install just

# 2. Clone the repo
git clone git@github.com:NeoPrimate/nix.git ~/nix
cd ~/nix

# 3. Add a host file for this machine: home/hosts/<hostname>.nix
#    Add it to flake.nix under homeConfigurations.

# 4. First activation
nix run home-manager/release-26.05 -- switch --flake .#vb@<hostname> -b bak
```
