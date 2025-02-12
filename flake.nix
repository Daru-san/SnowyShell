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
    in
    {
      overlays.default =
        self: prev:
        let
          lua = prev.lua.override {
            packageOverrides = luaself: luaprev: {
              sysinfo = prev.callPackage ./crates/sysinfo/package.nix { };
            };
          };
        in
        {
          luaPackages = lua.pkgs;
        };

      homeManagerModules = {
        default = self.homeManagerModules.snowy-shell;
        snowy-shell = import ./nix/hm-module.nix self;
      };

      devShells = genSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              rustc
              pkg-config
              clippy
              dart-sass
              rustfmt
              (lua.withPackages (
                ps: with ps; [
                  stdlib
                ]
              ))
              luarocks
              luarocks-nix
              luaPackages.luarocks-build-rust-mlua
              luaPackages.sysinfo
              luaPackages.stdlib
            ];
          };
        }
      );
      packages = genSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = self.packages.${system}.snowy-shell;
          snowy-shell = pkgs.callPackage ./nix/package.nix {
            inherit astal pkgs;
          };
        }
      );
    };
}
