{
  inputs,
  pkgs,
  config,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  zen-browser = config.lib.nixGLWrap.wrap inputs.zen-browser.packages.${system}.twilight; # or twilight
in
{
  programs.zen-browser = {
    enable = true;
    package = zen-browser;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      NoDefaultBookmarks = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default =
      let
        containers = {
          Work = {
            color = "blue";
            icon = "briefcase";
            id = 1;
          };
          Life = {
            color = "green";
            icon = "tree";
            id = 2;
          };
        };

        spaces = {
          "Hackuity" = {
            id = "572910e1-4468-4832-a869-0b3a93e2f165";
            icon = "👨🏻‍💻";
            position = 1000;
            container = containers.Work.id;
          };
        };

        pins = {
          "mail" = {
            id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://outlook.live.com/mail/";
            isEssential = true;
            position = 101;
          };

          "Jira" = {
            id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://hackuity.atlassian.net/issues/?filter=-1";
            isEssential = true;
            position = 102;
          };

          "Notion" = {
            id = "8af62707-0722-4049-9801-bedced343333";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://www.notion.so/hackuity";
            isEssential = true;
            position = 103;
          };

          "Dust" = {
            id = "0ac3121a-fcff-4880-a344-fb5e0427951d";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://dust.tt/w/aoBYee1dKf/conversation/new#?selectedTab=favorites";
            isEssential = true;
            position = 104;
          };

          "Github" = {
            id = "efbd1d59-fd11-43a6-9996-c58d8bd30ee5";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://github.com/Hackuity";
            isEssential = true;
            position = 105;
          };

          "Grafana Prod" = {
            id = "c1b87b4b-7b2b-4f74-bdb0-06d42f62e70e";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://grafana.ops.hy.hackuity.io";
            isEssential = true;
            position = 106;
          };

          "Silae" = {
            id = "f63a50cf-8bd3-43e7-b989-409364f37bec";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://rh.silae.fr/login";
            isEssential = false;
            position = 107;
          };

          "Sharepoint" = {
            id = "c5f3be3b-1c55-4630-9812-af1e2055c944";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://hackuity.sharepoint.com/sites/TeamGeneral/Documents%20partages/Forms/AllItems.aspx";
            isEssential = false;
            position = 108;
          };

          "Excel Recup" = {
            id = "7a52f47a-30c6-4a7e-bdf7-ef1c5fef7c91";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://hackuity.sharepoint.com/:x:/r/sites/TeamGeneral/_layouts/15/doc2.aspx?sourcedoc=%7B9C0A107B-F0C7-459E-9F18-665E6403964B%7D";
            isEssential = false;
            position = 109;
          };

          "Leapsome" = {
            id = "835f941a-a8d8-4e59-b4b8-1907816a5488";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            url = "https://www.leapsome.com/app/#/dashboard";
            isEssential = false;
            position = 110;
          };

          # Folder
          "Nix" = {
            id = "d85a9026-1458-4db6-b115-346746bcc692";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            isGroup = true;
            isFolderCollapsed = true;
            editedTitle = true;
            position = 200;
          };

          "Nixpkgs Reference Manual" = {
            id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            folderParentId = pins."Nix".id;
            url = "https://nixos.org/manual/nixpkgs/stable/";
            position = 201;
          };

          "Home Manager appendix" = {
            id = "92931d60-fd40-4707-9512-a57b1a6a3919";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            folderParentId = pins."Nix".id;
            url = "https://home-manager.dev/manual/unstable/options.xhtml";
            position = 202;
          };

          "Voyager Layout" = {
            id = "2eed5614-3896-41a1-9d0a-a3283985359b";
            container = containers.Work.id;
            workspace = spaces."Hackuity".id;
            folderParentId = pins."Nix".id;
            url = "https://configure.zsa.io/voyager/layouts/bmGJV/latest/0";
            position = 203;
          };
        };
      in
      {
        containersForce = true;
        pinsForce = true;
        spacesForce = true;

        inherit containers spaces pins;

        settings.browser = {
          tabs.warnOnClose = false;
          download.panel.shown = false;
        };

        search = {
          force = true;
          default = "ddg";
        };
      };

  };

  xdg.mimeApps =
    let
      value =
        let
          zen-browser = zen-browser;
        in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name value;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
}
