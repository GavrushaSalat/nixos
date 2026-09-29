{ inputs, lib, pkgs, ... }:
let
  wanInterface = "wlp0s20f3";
  discordHosts = [
    "discord.com"
    "discord.gg"
    "discordapp.com"
    "discordapp.net"
    "discord.media"
    "discordcdn.com"
  ];
in
{
  imports = [
    ({ config, pkgs, lib, utils, ... }:
      builtins.removeAttrs
        (import "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/zapret2.nix" {
          inherit config pkgs lib utils;
        })
        [ "meta" ])
  ];

  networking.nftables.enable = true;

  services.zapret2 = {
    enable = true;
    package = pkgs.unstable.zapret2;
    firewall.configureAutomatically = false;

    profiles = {
      discord_tls = {
        hosts.include = discordHosts;
        parameters = [
          "--filter-tcp=443"
          "--filter-l7=tls"
          "--payload=tls_client_hello"
          "--lua-desync=fake:blob=fake_default_tls:tcp_ts=-1000:repeats=1"
          "--lua-desync=fakedsplit:pos=1,midsld:tcp_ts=-1000"
        ];
      };

      discord_quic = {
        hosts.include = discordHosts;
        parameters = [
          "--filter-udp=443"
          "--filter-l7=quic"
          "--payload=quic_initial"
          "--lua-desync=fake:blob=fake_default_quic:repeats=6"
        ];
      };

      discord_voice.parameters = [
        "--filter-udp=19294-19344,50000-65535"
        "--filter-l7=discord,stun"
        "--payload=stun,discord_ip_discovery"
        "--lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=4"
      ];
    };
  };

  systemd.services."nfqws2@default" = {
    wantedBy = lib.mkForce [ ];
    unitConfig.ConditionPathExists = "!/sys/class/net/throne-tun";
  };

  networking.nftables.tables.zapret2_discord = {
    family = "inet";
    content = ''
      define WAN = "${wanInterface}"
      define DESYNC_MARK = 0x40000000
      define QNUM = 200

      chain post {
        type filter hook postrouting priority 101; policy accept;
        meta mark 0x2023 accept
        meta mark 0x2024 accept
        oifname $WAN meta mark & $DESYNC_MARK == 0 tcp dport 443 ct original packets 1-16 queue num $QNUM bypass
        oifname $WAN meta mark & $DESYNC_MARK == 0 udp dport { 443, 19294-19344, 50000-65535 } ct original packets 1-16 queue num $QNUM bypass
      }

      chain pre {
        type filter hook prerouting priority -101; policy accept;
        meta mark 0x2023 accept
        meta mark 0x2024 accept
        iifname $WAN meta mark & $DESYNC_MARK == 0 tcp sport 443 ct reply packets 1-16 queue num $QNUM bypass
        iifname $WAN meta mark & $DESYNC_MARK == 0 udp sport { 443, 19294-19344, 50000-65535 } ct reply packets 1-16 queue num $QNUM bypass
      }

      chain predefrag {
        type filter hook output priority -401; policy accept;
        meta mark & $DESYNC_MARK != 0 notrack
      }
    '';
  };
}
