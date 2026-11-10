{
  callPackage,
  lib,
  nixosTests,
  stdenv,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_2_4";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.3";

  # this package should point to the latest release.
  version = "2.4.4";

  # if adding a patch here, check if it also needs to be applied to zfs_unstable
  extraPatches = [
    ./linux-7.3/0001-Linux-7.3-bvec_iter.bi_bvec_done-is-now-bi_offset.patch
    ./linux-7.3/0002-Linux-use-cpu_feature_enabled-instead-of-static_cpu_.patch
    ./linux-7.3/0003-Linux-7.3-inode_operations.create-dropped-flag-arg.patch
    ./linux-7.3/0004-Linux-7.3-make-host-filesystem-available-to-kernel-t.patch
    ./linux-7.3/0005-Linux-7.3-compat-META.patch
  ];

  tests = {
    inherit (nixosTests.zfs) series_2_4;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
    inherit (nixosTests.zfs) installer;
  };

  maintainers = with lib.maintainers; [
    adamcstephens
    amarshall
  ];

  hash = "sha256-ZgfHTPsNoeDq6GKP4Xiti7Keis3vIZLDaTGQjgCItIc=";
}
