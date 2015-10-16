{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, AC-Angle, base, bytestring, protocol-buffers
      , protocol-buffers-descriptor, reactive-banana, stdenv
      , zeromq4-haskell
      }:
      mkDerivation {
        pname = "hrobots";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          AC-Angle base bytestring protocol-buffers
          protocol-buffers-descriptor reactive-banana zeromq4-haskell
        ];
        description = "NetRobots implemented in Haskell";
        license = "GPL";
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
