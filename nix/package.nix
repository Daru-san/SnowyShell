{
  astal,
  pkgs,
  lib,
  luaPackages,
  stdenvNoCC,
  makeWrapper,
}:
let
  inherit (pkgs) system;
  snowy-shell = astal.lib.mkLuaPackage {
    name = "snowy-shell";

    inherit pkgs;

    src = ../src;

    extraLuaPackages =
      ps: with ps; [
        luaPackages.sysinfo
        stdlib
      ];

    extraPackages =
      [
        pkgs.dart-sass
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
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "snowy-shell";

  version = "1.0.0";

  src = snowy-shell;

  sourceRoot = "${finalAttrs.src.name}";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/

    wrapProgram $out/bin/snowy-shell \
      --prefix PATH : ${
        lib.makeBinPath [
          luaPackages.sysinfo
          luaPackages.stdlib
        ]
      }
  '';

  meta = {
    description = "Beautiful wayland shell written in lua and rust.";
    mainProgram = "snowy-shell";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.daru-san ];
  };
})
