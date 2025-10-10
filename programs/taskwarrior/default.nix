{pkgs, ...}: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    colorTheme = "dark-blue-256";
    config = {
      report.list.columns = [
        "id"
        "start"
        "priority"
        "project"
        "due"
        "description"
        "urgency"
        "tags"
      ];
      report.list.labels = [
        "ID"
        "Started"
        "Priority"
        "Project"
        "Due"
        "Description"
        "Urgency"
        "Tags"
      ];
    };
  };
}
