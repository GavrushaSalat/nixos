# Remote desktop: wayvnc over Tailscale
{ pkgs, ... }:
{
  # Tailscale: mesh VPN so devices on the tailnet (e.g. Android tablet)
  # can reach this PC from anywhere without opening ports to the internet.
  services.tailscale.enable = true;

  # Trust the tailscale interface fully — it's only reachable by devices
  # authenticated to this Tailscale account, so services like wayvnc
  # don't need per-port firewall rules to be usable over it.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";

  # VNC server for niri (wlr-screencopy + virtual input protocols).
  # Runs as a per-user service tied to the graphical session, so the PC
  # must be logged into niri (screen can be locked/off) for it to work.
  environment.systemPackages = [ pkgs.wayvnc ];

  systemd.user.services.wayvnc = {
    description = "wayvnc VNC server (remote desktop over Tailscale)";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      # Bound to 0.0.0.0, but the firewall only lets the tailscale0
      # interface reach port 5900 — not exposed on LAN.
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --render-cursor 0.0.0.0 5900";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
