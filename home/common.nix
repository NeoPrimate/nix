{ pkgs, ... }: {
  imports = [
    ./theme.nix
    ./packages.nix
    ./dotfiles.nix
    ./sketchybar.nix
  ];

  home.username = "vb";
  home.homeDirectory = "/Users/vb";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Ollama runs via the brew cask (darwin/common.nix) — Ollama.app ships Metal;
  # nixpkgs' ollama on darwin is CPU-only.
}
