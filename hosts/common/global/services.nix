# System services: printing, input, polkit, keyring
{ ... }:
{
  services.printing.enable = true;
  services.upower.enable = true;
  services.libinput.enable = true;
  services.udisks2.enable = true; # removable disk mounting (udisksctl, udiskie, Dolphin)

  security.polkit.enable = true;
  security.sudo.extraConfig = "Defaults pwfeedback";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
