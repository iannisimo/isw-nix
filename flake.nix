{
  description = "A nix flake providing a nixos module for configuring isw";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    targetSystems = [ "aarch64-linux" "x86_64-linux" ];
  in {
    nixosModules = {
      isw = import ./module.nix;
      default = self.nixosModules.isw;
    };

    nixosModule = self.nixosModules.default;

  } // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages = {
      isw = pkgs.callPackage ./isw.nix {};
      default = self.packages.${system}.isw;
    };

    defaultPackage = pkgs.isw;
  });
  
}
