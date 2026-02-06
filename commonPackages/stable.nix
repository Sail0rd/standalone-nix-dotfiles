{ pkgs, ... }:
with pkgs.stable;
[
  onefetch # Git repo infos
  fastfetch # neofetch replacement
  awscli2 # AWS CLI v2
  go
  nodejs
  python313
]
