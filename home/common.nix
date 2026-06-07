{ pkgs, ... }: {
  imports = [
    ./theme.nix
    ./packages.nix
    ./dotfiles.nix
  ];

  home.username = "vb";
  home.homeDirectory = "/Users/vb";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
