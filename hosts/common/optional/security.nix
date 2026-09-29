# Security and pentesting tools
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.nuclei
    unstable.nuclei-templates
  ];
}
