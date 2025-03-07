self: super:

let

  inherit (super) callPackage;

  # Upstream cfssl is out of date.
  cfssl = callPackage ../pkgs/cfssl {};

  # More recent version than upstream.
  aws-vault = callPackage ../pkgs/aws-vault {};

  # More recent version than upstream.
  minikube = callPackage ../pkgs/minikube {
    inherit (super.darwin.apple_sdk.frameworks) vmnet;
    inherit (super) hyperkit;
  };

  # Upstream disables macOS.
  libvmaf = callPackage ../pkgs/libvmaf {};

  # Upstream is out of date.
  aws-okta = callPackage ../pkgs/aws-okta {
    source = super.lib.dhess-nix.sources.aws-okta;
  };

  # Upstream is out of date.
  oauth2_proxy = callPackage ../pkgs/oauth2_proxy {};

in
{

  # A more recent ipxe than nixpkgs has.
  ipxe = callPackage ../pkgs/misc/ipxe {};

  # Use OpenSSL 1.1 in unbound so that it can resolve DNS over TLS names.
  unbound = callPackage (super.path + "/pkgs/tools/networking/unbound") {
    openssl = super.openssl_1_1;
  };


  # Enable TLS v1.2 in wpa_supplicant.
  wpa_supplicant = super.wpa_supplicant.overrideAttrs (drv: {
    extraConfig = drv.extraConfig + ''
     CONFIG_TLSV12=y
    '';
  });

  # Use fdk_aac in ffmpeg-full.
  #
  # Don't override super; it disables a bunch of things on macOS.
  ffmpeg-full = callPackage (super.path + "/pkgs/development/libraries/ffmpeg-full") {
    nonfreeLicensing = true;
    fdkaacExtlib = true;
    fdk_aac = super.fdk_aac;
    inherit libvmaf;
    nvenc = false;
    inherit (super.darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration;

    frei0r = if super.stdenv.isDarwin then null else super.frei0r;
  };

  inherit aws-okta;
  inherit aws-vault;
  inherit cfssl;
  inherit libvmaf;
  inherit minikube;
  inherit oauth2_proxy;
}
