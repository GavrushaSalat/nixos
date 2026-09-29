# GUI applications
{ pkgs, ... }:
let
  arkStyled = pkgs.symlinkJoin {
    name = "ark";
    paths = [ pkgs.unstable.kdePackages.ark ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ark --add-flags "-stylesheet ${./ark.qss}"
    '';
  };
in
{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.telegram-desktop
    obsidian
    crosspipe
    vesktop
    spotify
    jetbrains-toolbox
    unstable.kdePackages.dolphin
    unstable.kdePackages.kio-extras
    unstable.kdePackages.ffmpegthumbs
    unstable.kdePackages.kdegraphics-thumbnailers
    unstable.kdePackages.gwenview
    arkStyled
    unstable.kdePackages.kimageformats
    unstable.kdePackages.qtimageformats
    vlc
    pavucontrol
    wiremix
    qt6Packages.qt6ct
    claude-desktop
    codex-desktop
    libreoffice
    qbittorrent
    gnome-calculator
    zathura
    imv
  ];
}
