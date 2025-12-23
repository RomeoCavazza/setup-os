{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  environment.systemPackages = with pkgs; [
    emacs29-pgtk

    # Useful deps for Emacs workflows
    ripgrep fd
    clang cmake gnumake libtool
    sqlite

    # LSP (lightweight baseline)
    nil
    nodePackages.bash-language-server

    # Org / Docs
    pandoc
    graphviz

    # LaTeX (medium profile; avoid full unless you really need it)
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        wrapfig
        ulem
        capt-of
        hyperref;
    })
  ];
}
