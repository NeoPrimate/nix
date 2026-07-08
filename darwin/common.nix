{ pkgs, ... }: {
  # ---- System ----
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "vb";

  # Determinate Nix manages the daemon and config; tell nix-darwin to stay out.
  nix.enable = false;

  # Allow unfree packages (raycast, etc.)
  nixpkgs.config.allowUnfree = true;

  users.users.vb = {
    name = "vb";
    home = "/Users/vb";
  };

  programs.zsh.enable = true;

  # ---- Fonts ----
  # Registered system-wide with macOS. Hack Nerd Font supplies the bar's glyph
  # icons; sketchybar-app-font supplies the per-app workspace icons.
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    sketchybar-app-font
  ];

  # ---- SketchyBar ----
  # Status bar driven by aerospace. Config lives in ~/.config/sketchybar
  # (symlinked from this repo via home/dotfiles.nix). extraPackages are placed
  # on the launchd agent's PATH so the plugin scripts can find them:
  #   - aerospace: query workspaces / windows
  #   - sketchybar-app-font: ships icon_map.sh (app-name -> glyph)
  #   - jq: general plugin use
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [ aerospace sketchybar-app-font jq ];
  };

  # ---- Homebrew ----
  # Brew itself must already be installed (it is). This declares the
  # minimal set of brew packages nix-darwin will keep installed.
  # Anything else already on brew is left untouched because
  # `onActivation.cleanup` is NOT set. Add `onActivation.cleanup = "uninstall";`
  # later if you want nix-darwin to enforce the list strictly.
  homebrew = {
    enable = true;
    taps  = [ "typewhisper/tap" ];
    brews = [ "tuxedo" ];
    casks = [
      "typewhisper"
      "cleanmymac"
      "karabiner-elements"
      "ghostty"
    ];
  };

  # ---- macOS system defaults ----
  # Declarative `defaults write`. Uncomment what you want; switch applies.
  # Reference: https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults
  #
  # system.defaults.dock.autohide = true;
  # system.defaults.dock.show-recents = false;
  # system.defaults.dock.mru-spaces = false;
  # system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.FXPreferredViewStyle = "Nlsv";  # list view
  # system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  # system.defaults.NSGlobalDomain.KeyRepeat = 2;
  # system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  # system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  # system.defaults.screencapture.location = "~/Pictures/Screenshots";
}
