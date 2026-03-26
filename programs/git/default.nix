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
      # pre-push = "${self}/programs/git/hooks/pre-push";
    };

    settings = {
      alias = {
        # Better log
        l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
        adog = "log --all --decorate --oneline --graph";
      };
      user = {
        email = "${email}";
        name = "${user}";
      };
      pull.rebase = true;
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
