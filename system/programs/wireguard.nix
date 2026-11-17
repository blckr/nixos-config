{
  config,
  ...
}:
{
  sops.secrets.wg_condor_private_key = {
    key = "wireguard/condor/private-key";
  };

  # Keeps the private key out of the Nix store
  sops.templates."wg-condor.env".content = ''
    WG_CONDOR_PRIVATE_KEY=${config.sops.placeholder.wg_condor_private_key}
  '';

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.templates."wg-condor.env".path ];

    # Declared here so it shows up in Noctalia
    profiles.condor = {
      connection = {
        id = "condor";
        type = "wireguard";
        interface-name = "condor";
        autoconnect = false;
      };

      wireguard = {
        private-key = "$WG_CONDOR_PRIVATE_KEY";
      };

      "wireguard-peer.Dgxu1X5vPM+D88TkCibScGwIiHTewlDwEhQQezda3S4=" = {
        # The server's WireGuard is only reachable over IPv4 (A record only)
        endpoint = "ipv4.blckr.dev:51820";
        allowed-ips = "192.168.100.0/24;192.168.178.0/24;";
        persistent-keepalive = 25;
      };

      ipv4 = {
        method = "manual";
        address1 = "192.168.100.2/24";
        dns = "192.168.100.1;";
      };

      ipv6 = {
        method = "disabled";
      };
    };
  };
}
