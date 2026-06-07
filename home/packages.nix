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
    jq

    # Languages
    python3
    uv          # python venv + package manager
    rustup      # rust toolchain manager (cargo, rustc via rustup install stable)

    # GUI
    alacritty
    zed-editor
    aerospace
    raycast
    # ghostty: macOS build not in nixpkgs (linux-only); declared as brew cask
    # typewhisper, cleanmymac: declared as brew casks in darwin/common.nix
  ];
}
