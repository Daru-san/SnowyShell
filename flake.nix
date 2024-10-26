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
      genSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
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
          snowy-shell = astal.lib.mkLuaPackage {
            inherit pkgs;
            src = ./.;

            name = "snowy-shell";

            extraPackages =
              [
                pkgs.dart-sass
                self.packages.${system}.snowy-utils
              ]
              ++ (with astal.packages.${system}; [
                hyprland
                astal3
                network
                tray
                wireplumber
                mpris
                bluetooth
              ]);
          };
        }
      );
    };
}
