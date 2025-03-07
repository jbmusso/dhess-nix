self: super:

let

  lib = import ../lib;

  inherit (super) callPackage;

  # This is needed to get nixops to evaluate correctly. See:
  #
  # https://discourse.nixos.org/t/what-am-i-doing-wrong-here/2517/9
  # https://github.com/NixOS/nixops/pull/1123
  nixpkgsPath = (import lib.fixedNixpkgs {}).path;
  nixopsBuild = (import (lib.fixedNixOps + "/release.nix") {  nixpkgs = nixpkgsPath; }).build;
  nixops      = nixopsBuild.${builtins.currentSystem};

  lorri       = (import lib.fixedLorri) { pkgs = super; };

  ccextractor = callPackage ../pkgs/multimedia/ccextractor {};

  debian-ppp = callPackage ../pkgs/networking/debian-ppp {};

  gawk_4_2_1 = callPackage ../pkgs/gawk/4.2.1.nix {};

  libprelude = callPackage ../pkgs/development/libraries/libprelude {
    gawk = gawk_4_2_1;
  };


  # When called with an argument `extraCerts` whose value is a set
  # mapping strings containing human-friendly certificate authority
  # names to PEM-formatted public CA certificates, this function
  # creates derivation similar to that provided by `super.cacert`, but
  # whose CA cert bundle contains the user-provided extra
  # certificates.
  #
  # For example:
  #
  #   extraCerts = { "Example CA Root Cert" = "-----BEGIN CERTIFICATE-----\nMIIC+..." };
  #   myCacert = mkCacert { inherit extraCerts };
  #
  # will create a new derivation `myCacert` which can be substituted
  # for `super.cacert` wherever that derivation is used, so that, e.g.:
  #
  #   myFetchGit = callPackage <nixpkgs/pkgs/build-support/fetchgit> { cacert = self.myCacert; };
  #
  # creates a `fetchgit` derivation that will accept certificates
  # created by the "Example CA Root Cert" given above.
  #
  # The cacert package in Nixpkgs allows the user to provide extra
  # certificates; however, these extra certificates are not visible to
  # some packages which hard-wire their cacert package, such as many
  # of nixpkgs's fetch functions. It's for that reason that this
  # function exists.
  mkCacert = (callPackage ../pkgs/security/custom-cacert.nix);

  ppp-devel = callPackage ../pkgs/networking/ppp-devel {};

  badhosts = callPackage ../pkgs/dns/badhosts {
    lib = super.lib;
    source = lib.fixedBadhosts;
  };

  suricata = callPackage ../pkgs/networking/suricata {
    # not strictly necessary for the overlay, but needed for building
    # this for the NUR package set.
    inherit libprelude;

    redisSupport = true;
    rustSupport = true;
  };

  trimpcap = callPackage ../pkgs/misc/trimpcap {};

  tsoff = callPackage ../pkgs/networking/tsoff {};

  # ESP32 stuff. Note that these packages are outdated. I haven't had
  # a chance to update them yet, but I want to keep them around in the
  # meantime.
  
  crosstool-ng-xtensa = callPackage ../pkgs/esp32/crosstool-ng-xtensa {};
  xtensa-esp32-toolchain = callPackage ../pkgs/esp32/xtensa-esp32-toolchain {};

  terraform-provider-okta = callPackage ../pkgs/terraform/providers/okta {
    source = lib.sources.terraform-provider-okta;
  };
  terraform-provider-vultr = callPackage ../pkgs/terraform/providers/vultr {
    source = lib.sources.terraform-provider-vultr;
  };

  dhess-nix-source = callPackage ../pkgs/dhess-nix-source { inherit (super) packageSource; };

  hyperkit = callPackage ../pkgs/hyperkit {
    inherit (super.darwin.apple_sdk.frameworks) Hypervisor vmnet SystemConfiguration;
    inherit (super.darwin.apple_sdk.libs) xpc;
    inherit (super.darwin) libobjc dtrace;
  };

  chamber = callPackage ../pkgs/chamber {};

in
{
  inherit (badhosts) badhosts-unified;
  inherit (badhosts) badhosts-fakenews badhosts-gambling badhosts-porn badhosts-social;
  inherit (badhosts) badhosts-fakenews-gambling badhosts-fakenews-porn badhosts-fakenews-social;
  inherit (badhosts) badhosts-gambling-porn badhosts-gambling-social;
  inherit (badhosts) badhosts-porn-social;
  inherit (badhosts) badhosts-fakenews-gambling-porn badhosts-fakenews-gambling-social;
  inherit (badhosts) badhosts-fakenews-porn-social;
  inherit (badhosts) badhosts-gambling-porn-social;
  inherit (badhosts) badhosts-fakenews-gambling-porn-social;
  inherit (badhosts) badhosts-all;

  inherit ccextractor;
  inherit chamber;
  inherit crosstool-ng-xtensa;
  inherit dhess-nix-source;
  inherit debian-ppp;
  inherit gawk_4_2_1;
  inherit hyperkit;
  inherit libprelude;
  inherit lorri;
  inherit mkCacert;
  inherit nixops;
  inherit ppp-devel;
  inherit suricata;
  inherit terraform-provider-okta;
  inherit terraform-provider-vultr;
  inherit trimpcap;
  inherit tsoff;
  inherit xtensa-esp32-toolchain;
}
