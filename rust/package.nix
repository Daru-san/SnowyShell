{
  lib,
  luaPackages,
  rustPlatform,
  cargo,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
luaPackages.buildLuarocksPackage {
  pname = cargoToml.package.name;
  version = "dev-1";
  src = ./.;

  disabled = luaPackages.luaOlder "5.1";

  knownRockSpec = ./snowy_utils-dev-1.rockspec;

  propagatedBuildInputs = [
    luaPackages.luarocks-build-rust-mlua
    cargo
    rustPlatform.cargoSetupHook
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  meta = {
    inherit (cargoToml.package) description homepage;
    maintainers = [ lib.maintainers.daru-san ];
    license = lib.licenses.mit;
  };

}
