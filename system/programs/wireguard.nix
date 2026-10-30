{
  config,
  ...
}:
{
  # WireGuard private key for the "condor" tunnel, kept in sops.
  sops.secrets.wg_condor_private_key = {
    key = "wireguard/condor/private-key";
  };

  # Render the key into an env file that NetworkManager's ensureProfiles
  # substitutes into the connection profile (keeps the key out of the Nix store).
  sops.templates."wg-condor.env".content = ''
    WG_CONDOR_PRIVATE_KEY=${config.sops.placeholder.wg_condor_private_key}
  '';

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.templates."wg-condor.env".path ];

    # Declared here so it auto-registers in NetworkManager on every rebuild,
    # which makes it show up (and toggleable) in Noctalia.
    profiles.condor = {
      connection = {
        id = "condor";
        type = "wireguard";
        interface-name = "condor";
        # Toggle it on demand from Noctalia; don't auto-connect on boot.
        autoconnect = false;
      };

      wireguard = {
        private-key = "$WG_CONDOR_PRIVATE_KEY";
      };

      # Server (condor) public key.
      "wireguard-peer.Dgxu1X5vPM+D88TkCibScGwIiHTewlDwEhQQezda3S4=" = {
        # Force IPv4: the server's WireGuard is only reachable over IPv4
        # (UDP/51820 does not traverse IPv6), and IPv4-only networks (e.g.
        # university) must work too. ipv4.blckr.dev has an A record only.
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
