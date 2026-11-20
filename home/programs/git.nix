# Identity comes from sops on NixOS (system/programs/git.nix) and from ~/.gitconfig.local on the Mac
{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "hx";
    };
  };
}
