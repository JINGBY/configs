{
  description = "hg configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./hg.nix ];
      };
    in {
      homeConfigurations = {
        "hannes@x86_64-linux" = mkHome "x86_64-linux";
        "hannes@aarch64-darwin" = mkHome "aarch64-darwin";
      };
    };
}
