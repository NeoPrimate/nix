{
  description = "vb nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = hostModule: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home/common.nix hostModule ];
        };
    in {
      homeConfigurations = {
        "vb@vladimirs-macbook-pro" = mkHome ./home/hosts/vladimirs-macbook-pro.nix "aarch64-darwin";
      };
    };
}
