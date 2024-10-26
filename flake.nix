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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = astal.lib.mkLuaPackage {
        inherit pkgs;
        src = ./src;

        extraPackages =
          [
            pkgs.dart-sass
          ]
          ++ (with astal.packages.${system}; [
            hyprland
            network
            tray
            wp
            mpris
            bluetooth
          ]);
      };
    };
}
