{
  username, lib, ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.${username} =
    { config, lib, ... }:
    {
      home.stateVersion = "25.05";

      # Forcefully remove files that block Home Manager activation
      home.activation.clobberConflicts = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -f $HOME/.gtkrc-2.0
        rm -f $HOME/.gtkrc-2.0.hm-backup
        rm -f $HOME/.gtkrc-2.0.backup
        rm -f $HOME/.config/zellij/config.kdl.backup
      '';
    };
}
