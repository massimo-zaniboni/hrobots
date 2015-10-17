{ mkDerivation, AC-Angle, base, bytestring, mtl, netwire
, protocol-buffers, protocol-buffers-descriptor, stdenv, text
, zeromq4-haskell
}:
mkDerivation {
  pname = "hrobots";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    AC-Angle base bytestring mtl netwire protocol-buffers
    protocol-buffers-descriptor text zeromq4-haskell
  ];
  description = "NetRobots implemented in Haskell";
  license = "GPL";
}
