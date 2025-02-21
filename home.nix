{ lib, config, pkgs, nur, ... }:
let
  my-zsh-additional-pkgs = (with pkgs; [
    zsh
    oh-my-zsh
    starship
    thefuck
  ]);
  my-python = pkgs.python3.withPackages (p: [
    p.numpy
    p.pandas
    p.matplotlib
  ]);
  #nur = import (builtins.fetchTarball {
  #  url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
  #  sha256 = "07cpf1rnq58il6nffnx4yafdly8if6ykxy8bylgnhl5pr80509la";
  #}) {};
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "feng";
  home.homeDirectory = "/home/feng";
  
  # Install Firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

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
      rebuild = "sudo nixos-rebuild switch --flake github:togekel/nixos-my-configuration#nixos";
      collect = "sudo nix-store --gc";
      refresh = "sudo nix-collect-garbage -d";
      optimise = "sudo nix-store --optimise";
      update = ''
        git clone git@github.com:togekel/nixos-my-configuration /tmp/nixos-my-configuration
        cd /tmp/nixos-my-configuration
        nix flake update --flake .
        git add .
        git commit -m "update flake.lock"
        git push origin main
        cd
        rm -rf /tmp/nixos-my-configuration
      '';
      gte = "gnome-text-editor";
      modify = ''
        git clone git@github.com:togekel/nixos-my-configuration
        cd nixos-my-configuration
      '';
      commit = ''
        git add .
        git commit -m "update"
        git push origin main
        cd ..
        rm -rf nixos-my-configuration
      '';
      open = "xdg-open";
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

  # Install Apps.
  home.packages = (with pkgs; [
    whitesur-icon-theme # WhiteSur icon theme.
    whitesur-cursors # WhiteSur Cursor theme.
    whitesur-gtk-theme # WhiteSur Gtk theme.
    gnome-tweaks # Tweaks to change looking.
    my-python
    evolution # Email Client.
    qq
    wechat-uos
    # wpsoffice-cn # This version is old. Use Nur.
    # jetbrains.clion # CLion for C Dev.
  ]) ++ (with pkgs.gnomeExtensions; [
    kimpanel
    dash-to-dock
    logo-menu
    blur-my-shell
    appindicator
  ]) ++ (with nur.repos; [
    novel2430.wemeet-bin-bwrap-wayland-screenshare
    novel2430.wpsoffice-cn
  ]) ++ 
  my-zsh-additional-pkgs;

  # Enable dconf.
  dconf = {
    enable = true;
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = (with pkgs.gnomeExtensions; [
        blur-my-shell.extensionUuid
        kimpanel.extensionUuid
        dash-to-dock.extensionUuid
        logo-menu.extensionUuid
        applications-menu.extensionUuid
        places-status-indicator.extensionUuid
        user-themes.extensionUuid
        system-monitor.extensionUuid
        appindicator.extensionUuid
        light-style.extensionUuid
      ]);
    };
  };


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


  home.file.".ssh" = {
    recursive = true;
    source = ./ssh;
  };
  
  home.file.".bigsur.jpg" = {
    source = builtins.fetchurl {
      url = "https://images.hdqwalls.com/wallpapers/big-sur-apple-5k-78.jpg";
      sha256 = "1vj0i17izsgig124d47qwhjjhih4ma6k9gvkfh3qnz7qhkvyzp5z";
    };
  };
}
