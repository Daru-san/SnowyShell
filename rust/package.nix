{
  lib,
  luaPackages,
  rustPlatform,
  cargo,
  rustc,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in
luaPackages.buildLuarocksPackage {
  pname = cargoToml.package.name;
  version = "dev-1";
  src = ./.;

  knownRockSpec = ./snowy_utils-dev-1.rockspec;

  propagatedBuildInputs = [
    luaPackages.luarocks-build-rust-mlua
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  preCheck = ''
    mkdir luarocks
    luarocks $LUAROCKS_EXTRA_ARGS make --tree=luarocks --deps-mode=all
  '';

  meta = {
    inherit (cargoToml.package) description homepage;
    maintainers = [ lib.maintainers.daru-san ];
    license = lib.licenses.mit;
  };

}
