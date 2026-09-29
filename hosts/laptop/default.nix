# Host: laptop (Gigabyte G5 KF: i5-12500H + RTX 4060 Laptop, Optimus)
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/global
    ../common/optional/cli.nix
    ../common/optional/dev.nix
    ../common/optional/apps.nix
    ../common/optional/security.nix
    ../common/optional/happ.nix
    ../common/optional/amnezia.nix
    ../common/optional/remote-desktop.nix
    ../common/optional/desktop.nix
    ../common/optional/fonts.nix
    ../common/optional/gaming.nix
    ../common/optional/docker.nix
    ./dual-boot.nix
    ./disks.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # Stock (1080p) variant of the theme — the panel is 1920x1080
    theme = pkgs.stdenvNoCC.mkDerivation {
      pname = "cybergrub-2077";
      version = "unstable-2026-08-06";
      src = pkgs.fetchFromGitHub {
        owner = "Goldensit0";
        repo = "CyberGRUB-2077-4K-monitor-adapted";
        rev = "677be65d0442969181d0d53caa11c7495dd94c27";
        hash = "sha256-mDy8QAD4AO5Rb+LCpMgOkCQ1loQ2qToe2Mfg1uEbN0I=";
      };
      installPhase = ''
        cp -r CyberGRUB-2077 $out
        cp img/logos/nixos.png $out/logo.png
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # Keep automatic snapshots of the home subvolume.  The snapshot directory
  # is itself a subvolume so it is not included recursively in snapshots.
  systemd.services.home-snapshots-init = {
    description = "Create the Btrfs subvolume for home snapshots";
    wantedBy = [ "multi-user.target" ];
    before = [ "snapper-timeline.service" "snapper-cleanup.service" ];
    unitConfig = {
      ConditionPathExists = "!/home/.snapshots";
      RequiresMountsFor = "/home";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs subvolume create /home/.snapshots";
    };
  };

  # Smaller retention than on the Redmi
  services.snapper = {
    persistentTimer = true;
    configs.home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ "misha" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 6;
      TIMELINE_LIMIT_DAILY = 5;
      TIMELINE_LIMIT_WEEKLY = 2;
      TIMELINE_LIMIT_MONTHLY = 2;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };

  systemd.services.snapper-timeline = {
    requires = [ "home-snapshots-init.service" ];
    after = [ "home-snapshots-init.service" ];
  };
  systemd.services.snapper-cleanup = {
    requires = [ "home-snapshots-init.service" ];
    after = [ "home-snapshots-init.service" ];
  };

  networking.hostName = "nixos";
  system.stateVersion = "26.05";

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  # acpi_call: direct EC access for fan control
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.kernelPackages = pkgs.linuxPackages;

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = (pkgs.unstable.linuxKernel.packagesFor config.boot.kernelPackages.kernel).nvidiaPackages.latest;
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics.enable = true;
}
