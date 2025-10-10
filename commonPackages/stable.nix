{ pkgs, ... }:
with pkgs.stable;
[
  onefetch # Git repo infos
  fastfetch # neofetch replacement

  # core languages
  go
  lua
  nodejs
  python313
  typescript
]
