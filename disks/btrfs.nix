# Btrfs layout on pre-created partitions (dual boot: the disk also holds
# Windows, so disko must not repartition it).  The partitions are created by
# hand with these GPT partlabels (see INSTALL.md); disko only formats and
# mounts them.  disko's destroy stage never wipes partition devices, so wipe
# the new partitions with `wipefs -a` before running it.
{ esp ? "/dev/disk/by-partlabel/nixos-boot"
, swap ? "/dev/disk/by-partlabel/nixos-swap"
, root ? "/dev/disk/by-partlabel/nixos-root"
}:
{ ... }:
{
  disko.devices.disk = {
    esp = {
      device = esp;
      type = "disk";
      destroy = false;
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [ "fmask=0077" "dmask=0077" ];
      };
    };

    swap = {
      device = swap;
      type = "disk";
      destroy = false;
      content.type = "swap";
    };

    nixos = {
      device = root;
      type = "disk";
      destroy = false;
      content = {
        type = "btrfs";
        extraArgs = [ "-L" "nixos" "-f" ];
        subvolumes =
          let
            opts = [ "compress=zstd:1" "noatime" ];
          in
          {
            "@root" = { mountpoint = "/"; mountOptions = opts; };
            "@home" = { mountpoint = "/home"; mountOptions = opts; };
            "@nix" = { mountpoint = "/nix"; mountOptions = opts; };
            "@snapshots" = { mountpoint = "/.snapshots"; mountOptions = opts; };
          };
      };
    };
  };
}
