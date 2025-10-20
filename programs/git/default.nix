{
  config,
  pkgs,
  user,
  email,
  self,
  ...
}:
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
  };
  programs.git = {
    enable = true;
    package = pkgs.git;
    hooks = {
      prepare-commit-msg = "${self}/programs/git/hooks/prepare-commit-msg";
    };

    settings = {
      user = {
        email = "${email}";
        name = "${user}";
      };
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
