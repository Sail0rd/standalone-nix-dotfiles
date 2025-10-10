{ pkgs, ...}: {

  home.packages = with pkgs; [
    gitmoji-cli
  ];
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "C";
          context = "files";
          description = "Commit changes using gitmojis";
          command = "git commit -m '{{ .Form.emoji }} {{ .Form.message }}'";
          prompts = [
            {
              type = "menuFromCommand";
              command = "gitmoji -l";
              title = "Select a gitmoji:";
              filter = "^(.*?) - (:.*?:) - (.*)$";
              valueFormat = "{{ .group_1 }}";
              labelFormat = "{{ .group_1 }} - {{ .group_3 }}";
              key = "emoji";
            }
            {
              type = "input";
              title = "Enter a commit message:";
              key = "message";
            }
          ];
        }
      ];
    };
  };
}
