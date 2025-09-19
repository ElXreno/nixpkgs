{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bluez,
  dbus,
  glew,
  glfw,
  imgui,
  xorg,
  libxcursor,
  libxrandr,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SonyHeadphonesClient";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mos9527";
    repo = "SonyHeadphonesClient";
    rev = finalAttrs.version;
    hash = "sha256-3DHMqcM5sCNK7vCa3zMmIUF3WcHB+csc+xKSVsorTno=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-Fix-building-with-Werror-format-security.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [
    bluez
    dbus
    glew
    glfw
    imgui
    xorg.libX11
    xorg.libXinerama
    xorg.libXi
    libxcursor
    libxrandr
  ];

  cmakeFlags = [ "-Wno-dev" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin SonyHeadphonesClient
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "SonyHeadphonesClient";
      exec = "SonyHeadphonesClient";
      icon = "SonyHeadphonesClient";
      desktopName = "Sony Headphones Client";
      comment = "A client recreating the functionality of the Sony Headphones app";
      categories = [
        "Audio"
        "Mixer"
      ];
    })
  ];

  meta = {
    description = "Client recreating the functionality of the Sony Headphones app";
    homepage = "https://github.com/Plutoberth/SonyHeadphonesClient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    platforms = lib.platforms.linux;
    mainProgram = "SonyHeadphonesClient";
  };
})
