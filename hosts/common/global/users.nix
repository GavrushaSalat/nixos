# User declarations
{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.misha = {
    isNormalUser = true;
    description = "misha";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
}
