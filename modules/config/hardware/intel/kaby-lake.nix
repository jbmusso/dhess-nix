# Configuration common to Intel Kaby Lake physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.intel.kaby-lake;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.intel.kaby-lake = {
    enable = mkEnableOption "Enable Intel Kaby Lake hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  };
}
