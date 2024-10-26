{ rustPlatform, lib }:

rustPlatform.buildRustPackage {
  pname = "snowy-utils";

  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "Utilities I use with my desktop shell";
    maintainers = [ lib.maintainers.daru-san ];
    license = lib.licenses.mit;
    mainPackage = "snowy-libs";
  };

}
