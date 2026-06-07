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

  # ---- Homebrew ----
  # Brew itself must already be installed (it is). This declares the
  # minimal set of brew packages nix-darwin will keep installed.
  # Anything else already on brew is left untouched because
  # `onActivation.cleanup` is NOT set. Add `onActivation.cleanup = "uninstall";`
  # later if you want nix-darwin to enforce the list strictly.
  homebrew = {
    enable = true;
    taps  = [ "typewhisper/tap" ];
    brews = [];
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
