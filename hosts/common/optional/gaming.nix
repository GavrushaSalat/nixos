# Gaming: Steam and related config
{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
  };

  programs.gamescope.enable = true;

  # Wine (for FMS RC simulator)
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    winetricks
  ];
}
