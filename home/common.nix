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

  # Ollama server as a launchd user agent (localhost:11434); also puts `ollama` on PATH.
  services.ollama.enable = true;
}
