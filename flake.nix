# SPDX-FileCopyrightText: 2021 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: CC0-1.0

{
  description = "hoauth2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=a95ed9fe764c3ba2bf2d2fa223012c379cd6b32e";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        src = ./hoauth2;
        compiler = "ghc944";
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskell.packages.${compiler};

        packageName = "hoauth2";
      in
      {
        packages.${packageName} = haskellPackages.callCabal2nix packageName src { };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
          buildInputs = [
            haskellPackages.ghc
            haskellPackages.haskell-language-server
            haskellPackages.cabal-install
            haskellPackages.fourmolu
            haskellPackages.hlint
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };
        checks = self.packages.${system}.${packageName};
      });
}
