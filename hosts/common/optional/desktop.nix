# Window managers, display manager, system-level desktop
{ inputs, pkgs, ... }:
let
  thyxThemed = (pkgs.callPackage "${inputs.thyx}/default.nix" { }).overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${./thyx-dms.conf} $out/share/sddm/themes/thyx/theme.conf
    '';
  });
in
{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.thyx.nixosModules.default
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.xwayland.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    wayland.compositor = "kwin";
    thyx = {
      enable = true;
      package = thyxThemed;
    };
    enableHidpi = true;
    settings.Theme = {
      CursorTheme = "phinger-cursors-dark";
      CursorSize = 24;
    };
  };

  systemd.services.display-manager.environment = {
    KWIN_FORCE_SW_CURSOR = "1";
  };

  # DMS system-level: packages, systemd service, polkit
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };

  gtk.iconCache.enable = true;

  environment.systemPackages = with pkgs; [
    phinger-cursors
    unstable.satty
    libnotify
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    mpvpaper
    waypaper
    xwayland-satellite
  ];
}
