# Core CLI tools and utilities
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssh
    wget
    ripgrep
    fzf
    glow
    ffmpeg
    v4l-utils
    lm_sensors
    usbutils
    tree
    unzip
    p7zip
    unar
    dialog
    python314Packages.grip
    xxh
    ncdu
    zoxide
    vim
    git
    curl
    xdg-utils
    pandoc
    grim
    slurp
    cmus

    # Fun
    genact
    hollywood
    cbonsai
    uwufetch
  ];
}
