{ pkgs, ... }:
with pkgs.stable;
[
  onefetch # Git repo infos
  fastfetch # neofetch replacement

  # core languages
  awscli2 # AWS CLI v2
  go
  lua
  nodejs
  python313
  typescript
]
