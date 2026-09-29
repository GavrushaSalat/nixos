# Home-manager entrypoint for misha
{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./shell.nix
    ./programs.nix
    ./wm.nix
    ./kde.nix
  ];

  home.username = "misha";
  home.homeDirectory = "/home/misha";
  home.stateVersion = "26.05";
}
