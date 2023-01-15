{
  description = "busybox shell in an appimage";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    (flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ ["powerpc64le-linux"]) (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      with pkgs;
      {
        defaultPackage = let
        busybox-bin = pkgs.stdenv.mkDerivation {
          name = "busybox-bin";
          phases = "installPhase";
          installPhase = ''
            mkdir $out
            ${pkgs.busybox}/bin/busybox --install -s $out
          '';
        };
        in writeShellScriptBin "entry" ''
        export PATH=${busybox-bin}:$PATH
        echo "you're in busyboxbox now, friend."
        ${busybox-bin}/sh
        '';
      }
    ));
}

