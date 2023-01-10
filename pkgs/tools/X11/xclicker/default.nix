{ fetchFromGitHub
, lib
, stdenv
, meson
, ninja
, pkg-config
, gtk3
, libXtst
}:

stdenv.mkDerivation rec {
  pname = "xclicker";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f47V81fQcfR04PTkaj/yByH7CLXuu8CnMnjwpKZO2qE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    libXtst
  ];

  mesonFlags = [
    "--buildtype=release"
  ];

  postInstall = ''
    install -Dm755 src/xclicker $out/bin/xclicker
    install -Dm644 ../assets/xclicker.desktop $out/share/applications/xclicker.desktop
    install -Dm644 ../assets/icon.png $out/share/pixmaps/xclicker.png
  '';

  meta = with lib; {
    description = "XClicker - Fast gui autoclicker for x11 linux desktops";
    longDescription = ''
      XClicker is an open-source, easy to use, feature-rich, blazing fast
      Autoclicker for linux desktops using x11.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elxreno ];
    platforms = platforms.all;
  };
}
