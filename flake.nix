{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      astal,
    }:
    let
      inherit (nixpkgs) lib;
      genSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      homeManagerModules = {
        default = self.homeManagerModules.snowy-shell;
        snowy-shell = import ./nix/hm-module.nix self;
      };

      devShells = genSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              rustc
              pkg-config
              clippy
              rustfmt
              self.packages.${system}.snowy-utils
            ];
          };
        }
      );
      packages = genSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = self.packages.${system}.snowy-shell;
          snowy-utils = pkgs.callPackage ./rust/package.nix { };
          snowy-shell = pkgs.callPackage ./nix/package.nix {
            inherit
              self
              astal
              system
              pkgs
              ;
          };
        }
      );
    };
}
