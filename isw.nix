{ lib
, stdenv
, fetchzip
, pkgs
}: stdenv.mkDerivation rec {
  pname = "isw";
  version = "1.10";

  src = fetchzip {
    url = "https://github.com/YoyPa/isw/archive/${version}.tar.gz";
    hash = "sha256-ZRHLhf0C3b5GhqlkZPBGooHL/UFfyfbp7XtPy9flz0k=";
  };


  buildInputs = [ 
    pkgs.python3
    pkgs.coreutils
  ];


  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installPhase = ''
    install -Dm 755 isw $out/bin/isw
    mkdir -p $out/etc
    install -Dm 644 etc/isw.conf $out/etc/isw.conf
  '';

  meta = {
    description = "Fan control tool for MSI gaming series laptops";
    homepage = "https://github.com/YoyPa/isw";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    mainProgram = "isw";
  };
}
