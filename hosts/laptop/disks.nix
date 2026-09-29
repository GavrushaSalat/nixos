{ ... }:
{
  # ESP 2G, swap 16G, btrfs 636G — after Windows (p1–p4) on nvme0n1
  imports = [
    (import ../../disks/btrfs.nix { })
  ];
}
