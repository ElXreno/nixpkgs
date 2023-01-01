{ lib
, fetchFromGitLab
, python3Packages
, meson
, ninja
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, gettext
, gtk4
, pkg-config
, wrapGAppsHook4
, libadwaita
, realesrgan-ncnn-vulkan
}:

python3Packages.buildPythonApplication rec {
  pname = "Upscaler";
  version = "1.1.2";

  format = "other";

  src = fetchFromGitLab {
    owner = "TheEvilSkeleton";
    repo = pname;
    rev = version;
    sha256 = "sha256-MjzDdrSyTIk9hu0neqdAXuoL+g1pKpX8hvgQHIMqYdk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    gtk4
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    realesrgan-ncnn-vulkan
  ];

  mesonFlags = [
    "--buildtype=release"
  ];

  meta = with lib; {
    description = "Upscale and enhance images";
    longDescription = ''
      Upscaler is a GTK4+libadwaita application that allows you to upscale and
      enhance a given image. It is a front-end for Real-ESRGAN ncnn Vulkan.
    '';
    homepage = "https://gitlab.com/TheEvilSkeleton/Upscaler";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
