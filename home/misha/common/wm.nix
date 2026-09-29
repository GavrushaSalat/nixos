# Niri, cursor, session variables, portals, and polkit
{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = (pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "rosewater";
      }).overrideAttrs (_: { dontDropIconThemeCache = true; });
    };
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "rosewater";
    tmux.enable = true;
    btop.enable = true;
    fzf.enable = true;
    zsh-syntax-highlighting.enable = true;
  };

  home.sessionVariables = {
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "Darkly";
    QT_PLUGIN_PATH = "${pkgs.unstable.darkly}/lib/qt-6/plugins:${pkgs.unstable.kdePackages.plasma-integration}/lib/qt-6/plugins";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    ICON_THEME = "Papirus-Dark";
    XCURSOR_THEME = "phinger-cursors-dark";
    XCURSOR_SIZE = "24";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  services.polkit-gnome.enable = true;

  # Auto-mount removable disks to /run/media/misha/<label>
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };

  xdg.configFile."systemd/user/niri.service.d/egl.conf".text = ''
    [Service]
    Environment=__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json:/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
  '';

  # Niri routes ScreenCast to the GNOME backend. Keep both the GNOME and GTK
  # portals visible to user services for screen sharing and desktop dialogs.
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  xdg.configFile."niri/startup-layout.sh" = {
    source = ./niri/startup-layout.sh;
    executable = true;
  };
  xdg.configFile."niri/screenshot.sh" = {
    source = ./niri/screenshot.sh;
    executable = true;
  };

  home.file."Pictures/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  xdg.configFile."ghostty/shaders" = {
    source = ./ghostty-shaders;
    recursive = true;
  };
}
