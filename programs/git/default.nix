{
  config,
  pkgs,
  user,
  email,
  self,
  ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
    hooks = {
      prepare-commit-msg = "${self}/programs/git/hooks/prepare-commit-msg";
    };
    userEmail = "${email}";
    userName = "${user}";
    extraConfig = {
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };
}
