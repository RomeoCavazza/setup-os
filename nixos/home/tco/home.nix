{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    pywal
  ];

  xdg.configFile."foot/foot.ini".text = ''
    [include]
    include=/home/tco/.cache/wal/colors-foot.ini
  '';
}
