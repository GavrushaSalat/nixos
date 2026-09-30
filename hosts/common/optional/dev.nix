# Development tools and runtimes
{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    claude-code
    nodejs
    pnpm
    unstable.bun
    python315
    uv
    maven
    ghgrab
    gnumake
    go
    manix
    gcc
    gradle
    android-studio
    jdk17
  ];
}
