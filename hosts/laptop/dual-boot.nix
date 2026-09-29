# Dual boot with Windows on the same disk (nvme0n1)
{ ... }:
{
  # ntfs-3g needed to mount Windows NTFS (handles dirty/hibernated volumes)
  boot.supportedFilesystems = [ "ntfs" ];

  # Windows C: drive (nvme0n1p3, 1.5T NTFS)
  # NOTE: disable Fast Startup in Windows for safe read-write access:
  #   Control Panel → Power Options → Choose what power buttons do → Turn off fast startup
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/5208F44808F42D1B";
    fsType = "ntfs-3g";
    options = [
      "uid=1000"
      "gid=100"
      "dmask=022"
      "fmask=133"
      "nofail"
    ];
  };

  # Windows keeps the RTC in local time
  time.hardwareClockInLocalTime = true;
}
