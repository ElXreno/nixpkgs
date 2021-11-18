{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, pkg-config
, qmake
, qtwayland
, makeDesktopItem
, copyDesktopItems
, qtsvg
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pgmodeler";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "sha256-Km4PWvbIzgc1Kxsp26HYLCA4OkCfOsGWsdWYLmWf/NA=";
  };

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook copyDesktopItems ];
  desktopItems = [
    (makeDesktopItem {
      name = "pgModeler";
      exec = "${pname}";
      icon = "${pname}";
      desktopName = "pgModeler";
      genericName = "PostgreSQL Database Modeler";
      comment = "Create and deploy PostgreSQL database models";
      categories = [ "Development" ];
    })
  ];

  qmakeFlags = [ "pgmodeler.pro" "CONFIG+=release" ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs = [ postgresql qtsvg qtwayland ];

  postInstall = ''
    install -Dm644 $out/share/pgmodeler/conf/pgmodeler_logo.png $out/share/pixmaps/${pname}.png
  '';

  meta = with lib; {
    description = "A database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
