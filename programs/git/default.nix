{
  config,
  pkgs,
  self,
  ...
}: {
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
      prepare-commit-msg = "${self}/assets/hooks/prepare-commit-msg";
    };
    userEmail = "mguilbaud@hackuity.io";
    userName = "mathis";
    signing = {
      key = "3F3207C8D88C3ACC1E91A8C9E38C93040B06B56B";
      # signByDefault = false; # I only want to sign commits, not tags
    };
    extraConfig = {
      commit.gpgsign = true;
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
