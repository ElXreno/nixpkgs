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
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SonyHeadphonesClient";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "mos9527";
    repo = "SonyHeadphonesClient";
    rev = finalAttrs.version;
    hash = "sha256-RrBQ628ycJSR1PWmWxRz6yTc9ZTsmhkFgsRH06tiKKo=";
    fetchSubmodules = true;
  };

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
  ];

  sourceRoot = "${finalAttrs.src.name}/Client";

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
