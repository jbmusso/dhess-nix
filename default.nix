let

  lib = import ./lib;
  defaultPkgs = lib.nixpkgs { config = { allowUnfree = true; }; };

in

{ pkgs ? defaultPkgs }:

let

  overlays = self: super:
    lib.customisation.composeOverlays lib.overlays super;
  self = lib.customisation.composeOverlays (lib.singleton overlays) pkgs;

in
{
  inherit (self) crosstool-ng-xtensa;
  inherit (self) debian-ppp;
  inherit (self) darcs;
  inherit (self) dhall-nix dhall-to-cabal;
  inherit (self) dhess-ssh-keygen;
  inherit (self) fm-assistant;
  inherit (self) libprelude;
  inherit (self) mellon-gpio mellon-web;
  inherit (self) ntp;
  inherit (self) pinpon;
  inherit (self) ppp-devel;
  inherit (self) unbound;
  inherit (self) unbound-block-hosts;
  inherit (self) suricata;
  inherit (self) trimpcap;
  inherit (self) tsoff;
  inherit (self) wpa_supplicant;
  inherit (self) xtensa-esp32-toolchain;

  inherit (self) emacs-nox emacsNoXPackagesNg;
  inherit (self) emacs-nox-env emacs-macport-env;
  inherit (self) emacsMacportPackagesNg;

  inherit (self) haskellPackages;
  inherit (self) coreHaskellPackages;
  inherit (self) extensiveHaskellPackages;
  inherit (self) mkHaskellBuildEnv;
  inherit (self) haskell-env;
  inherit (self) extensive-haskell-env;

  # Various buildEnv's that I use, usually only on macOS (though many
  # of them should work on any pltform).
  inherit (self) mactools-env;
  inherit (self) nixtools-env;
  inherit (self) opsec-env;
  inherit (self) shell-env;

  inherit (self) lib;

  overlays.all = overlays;
  modules = self.lib.sources.pathDirectory ./modules;
}
