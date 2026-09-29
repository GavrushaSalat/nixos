{ inputs, ... }:
{
  imports = [ "${inputs.happ-nixos}/happ-module.nix" ];

  services.happ.enable = true;
}
