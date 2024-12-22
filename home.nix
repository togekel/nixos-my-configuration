{ lib, config, pkgs, ... }:
let
  my-zsh-additional-pkgs = (with pkgs; [
    zsh
    oh-my-zsh
    starship
    thefuck
  ]);
  my-agda = pkgs.agda.withPackages (p: [
    p.standard-library
  ]);
  my-python = pkgs.python3.withPackages (p: [
    p.numpy
    p.pandas
    p.matplotlib
  ]);
  spacemacsconfig = import ./.spacemacs;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "feng";
  home.homeDirectory = "/home/feng";
  
  # Install Firefox.
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };

  # Install and config git.
  programs.git = {
    enable = true;
    userName = "Togekel";
    userEmail = "1274911994@qq.com";
  };

  # Enable Zsh.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch";
      collect = "sudo nix-store --gc";
      refresh = "sudo nix-collect-garbage -d";
      optimise = "sudo nix-store --optimise";
      rebuild = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    # Oh-my-zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  # Enable StarShip.
  programs.starship.enable = true;

  # Enable Emacs.
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };



  # Install Apps.
  home.packages = (with pkgs; [
    my-agda
    my-python
    pyright
  ]) ++
  my-zsh-additional-pkgs;


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # Home Manager Activations.
  home.activation = {
    spacemacs-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ ! -d "$HOME/.emacs.d" && ! -e "$HOME/.spacemacs" ]] ; then
        run git clone https://github.com/syl20bnr/spacemacs.git $HOME/.emacs.d
        run cp -r $spacemacsconfig $HOME/.spacemacs
        run chmod 700 $HOME/.spacemacs
      fi
    '';
  };
}
