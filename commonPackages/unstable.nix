{ pkgs, ... }:
with pkgs;
[
  bat # prettier cat
  bottom # System monitor
  curl # HTTP cli client
  dive # Docker image explorer
  doggo # better dig
  du-dust # prettier du
  duf # prettier df
  fd # easier find
  fx # Terminal JSON viewer
  htop # prettier top
  jq # JSON processor
  killall # processes killer
  lnav # log viewer
  nix-tree # Nix packages tree
  nmap # network scanner
  procs # processes viewer
  ripgrep # practical grep
  ranger # file manager
  ripgrep # grep used by telescope in neovim
  sd # sed alternative
  skopeo # inspect container registries
  tree # directory tree
  tldr # practical man pages
  unzip # zip extractor
  wget # download utility
  yq-go # YAML processor
  zip # zip utility

  # git extensions
  git-crypt
  pre-commit
  gitmoji-cli
  git-graph

  # Tools
  trivy # vulnerability scanner
  gh # GitHub CLI
  # awscli2 # AWS CLI v2
  fluxcd # GitOps for Kubernetes
  talosctl # Talos OS CLI
  kind # Kubernetes in Docker

  # Kubernetes
  k9s
  kubectl
  kubectl-cnpg # CNPG management plugin
  kubectl-ktop # Top for kube cluster
  kubectl-explore # better kubectl explain
  kubectx
  kubesec
  kubeconform

  # secrets
  sops
  age

  # Test / Fun
  kcl # Kubernetes Configuration Language
  jujutsu # easier git
]
