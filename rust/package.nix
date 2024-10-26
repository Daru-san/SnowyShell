{ rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "snowy-libs";
  src = ./.;
}
