# nix

Personal macOS config managed with [nix-darwin](https://github.com/LnL7/nix-darwin), [home-manager](https://github.com/nix-community/home-manager), and [just](https://github.com/casey/just).

## Layout

```
flake.nix                  # top-level: inputs + darwinConfigurations
justfile                   # sync / pull / update recipes

darwin/
└── common.nix             # system-level: brew, macOS defaults

home/
├── common.nix             # imports everything below
├── packages.nix           # CLI + GUI apps from nixpkgs
├── theme.nix              # shared theme name across tools
├── dotfiles.nix           # symlink/render table for config files
└── hosts/
    └── vladimirs-macbook-pro.nix   # per-host overrides

config/                    # raw dotfile sources (helix, alacritty, etc.)
bin/                       # user scripts
zshrc                      # → ~/.zshrc
```

## Workflows

```bash
just              # list recipes
just sync         # commit + push, then darwin-rebuild switch
just sync "msg"   # same, with commit message
just pull         # git pull, then activate
just update       # nix flake update, then activate
```

## Where to put what

| Want to... | Edit | Then |
|---|---|---|
| Tweak a tool's config (helix, zellij, etc.) | `config/<tool>/...` directly | `just sync` (or instant for live-edit files) |
| Change theme across apps | `home/theme.nix` | `just sync` |
| Add a CLI tool or GUI app from nixpkgs | `home/packages.nix` | `just sync` |
| Add a brew cask (proprietary, macOS-only quirks) | `darwin/common.nix` → `homebrew.casks` | `just sync` |
| Add a brew formula | `darwin/common.nix` → `homebrew.brews` | `just sync` |
| Change a macOS system default (Dock, keyboard, etc.) | `darwin/common.nix` → `system.defaults.*` | `just sync` |
| Add a new dotfile to symlink | `home/dotfiles.nix` + drop file in `config/` | `just sync` |

**Rule of thumb:**
- In nixpkgs and works → `home/packages.nix`.
- Proprietary / macOS app with system quirks → brew cask in `darwin/common.nix`.

## New machine

```bash
# 1. Install Determinate Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. Install brew (required for the brew casks declared in darwin/common.nix)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone the repo
git clone git@github.com:NeoPrimate/nix.git ~/nix
cd ~/nix

# 4. Add a host file matching this machine's hostname:
#    home/hosts/<hostname>.nix
#    Add it to flake.nix under darwinConfigurations.

# 5. First activation (bootstrap)
sudo nix run github:LnL7/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake .#<hostname>

# 6. From here on, use:
just sync
```

`<hostname>` comes from `hostname -s`.
