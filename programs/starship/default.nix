{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.starship = {
    enable = true;
    settings = {
      format =
        let
          git = "$git_branch$git_commit$git_state$git_status";
        in
        ''
          $username$hostname($cmd_duration) $kubernetes $fill ($nix_shell)
          $directory(${git}) $fill
          $jobs$character
        '';

      fill = {
        symbol = " ";
        disabled = false;
      };

      git_branch = {
        style = "bold red";
        ignore_branches = [
          "main"
          "master"
        ];
      };

      git_status = {
        conflicted = "⚔️ ";
        diverged = "🔱";
        untracked = "🔎";
        ahead = "⏫";
        behind = "⏬";
        modified = "📝";
        staged = "📂";
        renamed = "🔄";
        deleted = "✘";
        style = "bright-white";
      };

      # Core
      username = {
        format = "[$user]($style)";
        show_always = true;
      };

      hostname = {
        format = "[@$hostname]($style) ";
        ssh_only = false;
        style = "bold green";
      };
      cmd_duration = {
        format = "took [$duration]($style) ";
      };

      directory = {
        format = "[$path]($style)( [$read_only]($read_only_style)) ";
      };

      nix_shell = {
        format = "[($name \\(develop\\) <- )$symbol]($style) ";
        impure_msg = "";
        symbol = " ";
        style = "bold blue";
      };

      character = {
        error_symbol = "  [⚠ ](bold red)";
        success_symbol = "  [➡️](bold green)";
      };

      # time = {
      #   format = "\\[[$time]($style)\\]";
      #   disabled = false;
      # };

      kubernetes = {
        disabled = false;
        format = "[⎈ $context \($namespace\)]($style) ";
      };

      # Icon changes only \/
      aws.symbol = "  ";
      conda.symbol = " ";
      dart.symbol = " ";
      directory.read_only = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      gcloud.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      nim.symbol = "󰆥 ";
      nodejs.symbol = " ";
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      shlvl.symbol = "";
      swift.symbol = "󰛥 ";
      terraform.symbol = "󱁢";
    };
  };
}
