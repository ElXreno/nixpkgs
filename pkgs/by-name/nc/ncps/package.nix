{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  nixosTests,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "ncps";
  version = "0.10.0-rc9";

  src = fetchFromGitHub {
    owner = "kalbasit";
    repo = "ncps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M9QdgrafNHxU4XJcWeja6ZqruC4qeWg0PUZcfgM25Ns=";
  };

  patches = [
    ./opaque-nar-url.patch
  ];

  vendorHash = "sha256-5odxR7SnN8Ak0koRpA+zz1jkiz5eiwRnwuDvuJt/tRE=";

  ldflags = [
    "-X github.com/kalbasit/ncps/pkg/ncps.Version=v${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  buildInputs = [ xz ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ncps --set XZ_BINARY_PATH ${lib.getExe' xz "xz"}
  '';

  doCheck = false;

  passthru = {
    tests = {
      inherit (nixosTests)
        ncps
        ncps-custom-sqlite-directory
        ncps-custom-storage-local
        ncps-ha-pg-redis
        ncps-ha-pg-redis-cdc
        ;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nix binary cache proxy service";
    homepage = "https://github.com/kalbasit/ncps";
    license = lib.licenses.mit;
    mainProgram = "ncps";
    maintainers = with lib.maintainers; [
      kalbasit
      aciceri
    ];
  };
})
