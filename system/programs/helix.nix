{
  username,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lazygit
    rust-analyzer
  ];
  environment.variables.EDITOR = "hx";
  environment.variables.VISUAL = "hx";
}
