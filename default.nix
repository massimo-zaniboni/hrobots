{ mkDerivation, AC-Angle, base, bytestring, netwire
, protocol-buffers, protocol-buffers-descriptor, stdenv
, zeromq4-haskell
}:
mkDerivation {
  pname = "hrobots";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    AC-Angle base bytestring netwire protocol-buffers
    protocol-buffers-descriptor zeromq4-haskell
  ];
  description = "NetRobots implemented in Haskell";
  license = "GPL";
}
