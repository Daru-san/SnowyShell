{
  astal,
  pkgs,
  lib,
  system,
  self,
  luaPackages,
  stdenvNoCC,
  makeWrapper,
  nix-gitignore,
}:
let
  snowy-shell = astal.lib.mkLuaPackage {
    name = "snowy-shell";

    inherit pkgs;

    src = nix-gitignore.gitignoreSourcePure [
      "nix/"
      "README.md"
      "*.nix"
      "*.lock"
      "rust/"
      "LICENSE"
    ] ../.;

    extraLuaPackages = ps: [ luaPackages.snowy_utils ];

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
          luaPackages.snowy_utils
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
