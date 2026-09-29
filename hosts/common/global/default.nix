# Global system config: nix settings, locale, networking
{ outputs, inputs, lib, ... }:
{
  imports = [
    ./users.nix
    ./services.nix
    ./audio.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = builtins.attrValues outputs.overlays;
  nix.settings.auto-optimise-store = true;

  networking.networkmanager.enable = true;
  # Don't block boot waiting for network — services that need it retry on their own
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  services.automatic-timezoned.enable = true;
  services.timesyncd.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_MONETARY = "ru_RU.UTF-8";
  };
}
