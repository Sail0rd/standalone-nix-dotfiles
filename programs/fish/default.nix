{
  hostname,
  lib,
  config,
  user,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
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
      k = "kubecolor";
      kpf = "kubecolor port-forward";
      klo = "kubecolor logs -f";
      # Get
      kg = "kubecolor get";
      kgns = "kubecolor get ns";
      kgp = "kubecolor get pods";
      kgs = "kubecolor get secrets";
      kgd = "kubecolor get deploy";
      kgrs = "kubecolor get rs";
      kgss = "kubecolor get sts";
      kgds = "kubecolor get ds";
      kgcm = "kubecolor get configmap";
      kgcj = "kubecolor get cronjob";
      kgj = "kubecolor get job";
      kgsvc = "kubecolor get svc -o wide";
      kgn = "kubecolor get no -o wide";
      kgins = "kubecolor get ingress";
      kgr = "kubecolor get roles";
      kgrb = "kubecolor get rolebindings";
      kgcr = "kubecolor get clusterroles";
      kgcrb = "kubecolor get clusterrolebindings";
      kgsa = "kubecolor get sa";
      kgnp = "kubecolor get netpol";
      # Edit
      ke = "kubecolor edit";
      kens = "kubecolor edit ns";
      kes = "kubecolor edit secrets";
      ked = "kubecolor edit deploy";
      kers = "kubecolor edit rs";
      kess = "kubecolor edit sts";
      keds = "kubecolor edit ds";
      kesvc = "kubecolor edit svc";
      kecm = "kubecolor edit cm";
      kecj = "kubecolor edit cj";
      ker = "kubecolor edit roles";
      kecr = "kubecolor edit clusterroles";
      kerb = "kubecolor edit clusterrolebindings";
      kesa = "kubecolor edit sa";
      kenp = "kubecolor edit netpol";
      # Describe
      kd = "kubecolor describe";
      kdns = "kubecolor describe ns";
      kdp = "kubecolor describe pod";
      kds = "kubecolor describe secrets";
      kdd = "kubecolor describe deploy";
      kdrs = "kubecolor describe rs";
      kdss = "kubecolor describe sts";
      kdds = "kubecolor describe ds";
      kdsvc = "kubecolor describe svc";
      kdcm = "kubecolor describe cm";
      kdcj = "kubecolor describe cj";
      kdj = "kubecolor describe job";
      kdsa = "kubecolor describe sa";
      kdr = "kubecolor describe roles";
      kdrb = "kubecolor describe rolebindings";
      kdcr = "kubecolor describe clusterroles";
      kdcrb = "kubecolor describe clusterrolebindings";
      kdnp = "kubecolor describe netpol";
      # Delete
      kdel = "kubecolor delete";
      kdelns = "kubecolor delete ns";
      kdels = "kubecolor delete secrets";
      kdelp = "kubecolor delete po";
      kdeld = "kubecolor delete deployment";
      kdelrs = "kubecolor delete rs";
      kdelss = "kubecolor delete sts";
      kdelds = "kubecolor delete ds";
      kdelsvc = "kubecolor delete svc";
      kdelcm = "kubecolor delete cm";
      kdelcj = "kubecolor delete cj";
      kdelj = "kubecolor delete job";
      kdelr = "kubecolor delete roles";
      kdelrb = "kubecolor delete rolebindings";
      kdelcr = "kubecolor delete clusterroles";
      kdelcrb = "kubecolor delete clusterrolebindings";
      kdelsa = "kubecolor delete sa";
      kdelnp = "kubecolor delete netpol";
      # Config
      kcfg = "kubecolor config";
      kcfgv = "kubecolor config view";
      kcfgns = "kubecolor config set-context --current --namespace";
      kcfgcurrent = "kubecolor config current-context";
      kcfggc = "kubecolor config get-contexts";
      kcfgsc = "kubecolor config set-context";
      kcfguc = "kubecolor config use-context";

      kns = "kubens";
      kc = "kubectx";
      knet = "kubectl run tmp-shell --rm -i --tty --overrides='{\"spec\": {\"hostNetwork\": true}}'  --image nicolaka/netshoot";
      # kc = "kconf";

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
      k-delete-ns = {
        body = ''
          kubecolor get namespace "$argv[1]" -o json \
            | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
            | kubecolor replace --raw /api/v1/namespaces/"$argv[1]"/finalize -f -
        '';
      };
    };
  };
}
