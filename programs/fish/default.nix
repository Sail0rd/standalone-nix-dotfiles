{
  hostname,
  lib,
  config,
  user,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit =
      ''
        fish_vi_key_bindings &&
        ${pkgs.starship}/bin/starship init fish | source
      ''
      + lib.strings.optionalString config.programs.taskwarrior.enable ''
        task list
      '';

    shellAbbrs = {
      # Nix
      ns = "nix-shell";
      nd = "nix develop --command fish";
      nr = "home-manager switch --flake ~/.config/home-manager#${hostname}";
      nu = "nix flake update";
      ngc = "nix-collect-garbage -d";
      nfmt = "nix run nixpkgs#nixpkgs-fmt";

      # Docker
      dc = "docker compose";

      # Kube
      # Other
      k = "kubectl";
      kpf = "kubectl port-forward";
      klo = "kubectl logs -f";
      # Get
      kg = "kubectl get";
      kgns = "kubectl get ns";
      kgp = "kubectl get pods";
      kgs = "kubectl get secrets";
      kgd = "kubectl get deploy";
      kgrs = "kubectl get rs";
      kgss = "kubectl get sts";
      kgds = "kubectl get ds";
      kgcm = "kubectl get configmap";
      kgcj = "kubectl get cronjob";
      kgj = "kubectl get job";
      kgsvc = "kubectl get svc -o wide";
      kgn = "kubectl get no -o wide";
      kgr = "kubectl get roles";
      kgrb = "kubectl get rolebindings";
      kgcr = "kubectl get clusterroles";
      kgcrb = "kubectl get clusterrolebindings";
      kgsa = "kubectl get sa";
      kgnp = "kubectl get netpol";
      # Edit
      ke = "kubectl edit";
      kens = "kubectl edit ns";
      kes = "kubectl edit secrets";
      ked = "kubectl edit deploy";
      kers = "kubectl edit rs";
      kess = "kubectl edit sts";
      keds = "kubectl edit ds";
      kesvc = "kubectl edit svc";
      kecm = "kubectl edit cm";
      kecj = "kubectl edit cj";
      ker = "kubectl edit roles";
      kecr = "kubectl edit clusterroles";
      kerb = "kubectl edit clusterrolebindings";
      kesa = "kubectl edit sa";
      kenp = "kubectl edit netpol";
      # Describe
      kd = "kubectl describe";
      kdns = "kubectl describe ns";
      kdp = "kubectl describe pod";
      kds = "kubectl describe secrets";
      kdd = "kubectl describe deploy";
      kdrs = "kubectl describe rs";
      kdss = "kubectl describe sts";
      kdds = "kubectl describe ds";
      kdsvc = "kubectl describe svc";
      kdcm = "kubectl describe cm";
      kdcj = "kubectl describe cj";
      kdj = "kubectl describe job";
      kdsa = "kubectl describe sa";
      kdr = "kubectl describe roles";
      kdrb = "kubectl describe rolebindings";
      kdcr = "kubectl describe clusterroles";
      kdcrb = "kubectl describe clusterrolebindings";
      kdnp = "kubectl describe netpol";
      # Delete
      kdel = "kubectl delete";
      kdelns = "kubectl delete ns";
      kdels = "kubectl delete secrets";
      kdelp = "kubectl delete po";
      kdeld = "kubectl delete deployment";
      kdelrs = "kubectl delete rs";
      kdelss = "kubectl delete sts";
      kdelds = "kubectl delete ds";
      kdelsvc = "kubectl delete svc";
      kdelcm = "kubectl delete cm";
      kdelcj = "kubectl delete cj";
      kdelj = "kubectl delete job";
      kdelr = "kubectl delete roles";
      kdelrb = "kubectl delete rolebindings";
      kdelcr = "kubectl delete clusterroles";
      kdelcrb = "kubectl delete clusterrolebindings";
      kdelsa = "kubectl delete sa";
      kdelnp = "kubectl delete netpol";
      # Config
      kcfg = "kubectl config";
      kcfgv = "kubectl config view";
      kcfgns = "kubectl config set-context --current --namespace";
      kcfgcurrent = "kubectl config current-context";
      kcfggc = "kubectl config get-contexts";
      kcfgsc = "kubectl config set-context";
      kcfguc = "kubectl config use-context";

      kns = "kubens";
      kc = "kubectx";

      # Other
      cat = "bat -p";

      # Git
      gsw = "git switch";
      gst = "git status";
      gd = "git diff";
      gg = "git-graph";
      lg = "lazygit";
    };

    shellAliases = {
      mkdir = "mkdir -p";
      nix-shell = ''nix-shell --command "fish"'';
    };

    functions = {
      backup = {
        body = ''
          cp $argv[1] $argv[1].bak
        '';
      };
      restore = {
        body = ''
          mv $argv[1] (echo $argv[1] | sed s/.bak//)
        '';
      };
      mkcd = {
        body = ''
          mkdir -p -- $argv[1]
          and cd -- $argv[1]
        '';
      };
      tarup = {
        body = ''
          tar -czvf $argv[1].tar.gz $argv[1]
        '';
      };
      tardown = {
        body = ''
          tar -xzvf $argv[1]
        '';
      };
      docker_sha = {
        body = ''
          docker buildx imagetools inspect "$argv[1]" --format "{{json .Manifest}}" | jq -r .digest
        '';
      };
    };
  };
}
