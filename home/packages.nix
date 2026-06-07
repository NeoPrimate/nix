{ pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI
    ripgrep
    gh
    helix
    zellij
    starship
    yazi
    nushell
    just
    zoxide
    eza
    bat
    fzf
    opencode
    ollama

    # GUI
    alacritty
    zed-editor
    aerospace
    raycast
    # ghostty: macOS build not in nixpkgs (linux-only); declared as brew cask
    # typewhisper, cleanmymac: declared as brew casks in darwin/common.nix
  ];
}
