{
  lib,
  luaPackages,
  rustPlatform,
  cargo,
  pkg-config,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
luaPackages.buildLuarocksPackage {
  pname = cargoToml.package.name;
  version = "dev-1";
  src = ./.;

  disabled = luaPackages.luaOlder "5.1";

  knownRockSpec = ./sysinfo-dev-1.rockspec;

  propagatedBuildInputs = [
    luaPackages.luarocks-build-rust-mlua
    cargo
    rustPlatform.cargoSetupHook
    pkg-config
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
