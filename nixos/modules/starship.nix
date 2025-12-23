{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      # Custom Cyberpunk Format
      format = builtins.concatStringsSep "" [
        "[░▒▓](#00f0ff)"
        "[  ](bg:#00f0ff fg:#090c0c)"
        "[](fg:#00f0ff bg:#1d2230)"
        "$directory"
        "[](fg:#1d2230 bg:none)"
        "$character"
      ];

      directory = {
        style = "fg:#00f0ff bg:#1d2230";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      character = {
        success_symbol = "[ ❯](bold #00f0ff)";
        error_symbol   = "[ ❯](bold #ff0055)";
      };
    };
  };
}
