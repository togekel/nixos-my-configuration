{ lib, config, pkgs, ... }:
let
  my-zsh-additional-pkgs = (with pkgs; [
    zsh
    oh-my-zsh
    starship
    thefuck
  ]);
  my-python = pkgs.python3.withPackages (p: [
  		p.pip
    p.numpy
    p.pandas
    p.matplotlib
    p.scipy
    p.sympy
  ]);
  dev-tools = (with pkgs; [
    gcc
    gnumake
    cmake
  ]);
  jetbrains-clion = pkgs.jetbrains.clion.overrideAttrs (finalAttrs: previousAttrs: {
    fromSource = true;
  });
  jetbrains-pycharm = pkgs.jetbrains.pycharm-professional.overrideAttrs (finalAttrs: previousAttrs: {
    fromSource = true;
  });
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "feng";
  home.homeDirectory = "/home/feng";
  
  # Install Firefox.
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
    package = pkgs.firefox-bin;
    languagePacks = [
			"zh-CN"
		];
		profiles.feng = {
			id = 0;
			name = "feng";
			isDefault = true;
			search = {
				default = "Bing";
				force = true;
			};
		};
  };
  
  # Install VSCode.
  programs.vscode = {
		enable = true;
		package = pkgs.vscode.fhs;
	};
  
  # Install Thunderbird.
	programs.thunderbird.enable = true;

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
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake github:togekel/nixos-my-configuration#nixos --impure";
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
      prefetch-nur = "nix-prefetch-url --unpack https://github.com/nix-community/NUR/archive/master.tar.gz";
      three-re = "refresh && rebuild && reboot";
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
    qq
    wechat-uos
    # wpsoffice-cn # This version is old. Use Nur.
    jetbrains-clion # CLion for C Dev.
    jetbrains-pycharm # PyCharm for Python Dev.
    nur.repos.novel2430.wemeet-bin-bwrap-wayland-screenshare
    nur.repos.novel2430.wpsoffice-cn # winfonts needed.
    zotero-beta
    planner # wbs
    super-productivity # todo app
    gimp # image processing
    vlc # video player
    amberol # music player
    blanket # focus listening
    texliveFull # LaTeX
    gummi # LaTeX IDE
    impression # Make bootable device
		motrix # Downloader.
		birdtray # Thunderbird tray.
  ]) ++ (with pkgs.gnomeExtensions; [
    kimpanel
    dash-to-dock
    logo-menu
    blur-my-shell
    appindicator # systray
    tiling-shell # tiling-shell
  ]) ++ 
  my-zsh-additional-pkgs ++
  dev-tools; # tools for c dev.
  
  # Fix libstdc++.so.6 missing bug.
  home.sessionVariables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  
  # Set GTK/QT Theme.
  home.sessionVariables.GTK_THEME = "WhiteSur-Light";
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
    theme = {
      name = "WhiteSur-Light";
      package = pkgs.whitesur-gtk-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
  };
  	xdg = {
  	  portal = {
  	    enable = true;
  	    extraPortals = with pkgs; [
  	      xdg-desktop-portal
  	      xdg-desktop-portal-gtk
  	    ];
  	    config.common.default = "*";
  	  };
  	};

  # Enable dconf.
  dconf = {
    enable = true;
    settings = {
			"org/gnome/desktop/app-folders" = {
				folder-children = [
					"Utilities"
					"YaST"
					"Pardus"
					"3f168635-fcc7-478d-9cc0-6c53c016b855"
					"ff66f84b-120c-4f5f-b1be-ea30109916f9"
					"36b23990-0fba-4117-b12e-70dd67f7d40d"
					"8df02a2b-1971-4662-9958-79020815a932"
					"45325cfe-068d-4172-8200-360e786a510a"
					"a9a37de2-e709-4139-9a1e-ffb28e3210e6"
					"c4fc5d17-3acc-44b9-8511-7af4dbeb81bb"
				];
			};
			"org/gnome/desktop/app-folders/folders/36b23990-0fba-4117-b12e-70dd67f7d40d" = {
				apps = [
					"org.gnome.Snapshot.desktop"
					"gimp.desktop"
					"io.bassi.Amberol.desktop"
					"com.rafaelmardojai.Blanket.desktop"
					"vlc.desktop"
				];
				name = "图像影音";
				translate = false;
			};
			"org/gnome/desktop/app-folders/folders/3f168635-fcc7-478d-9cc0-6c53c016b855" = {
				apps = [
					"fcitx5-configtool.desktop"
					"org.fcitx.Fcitx5.desktop"
					"org.fcitx.fcitx5-migrator.desktop"
					"cups.desktop"
					"kbd-layout-viewer5.desktop"
				];
				name = "输入输出";
				translate = false;
			};
			"org/gnome/desktop/app-folders/folders/45325cfe-068d-4172-8200-360e786a510a" = {
				apps = [
					"wps-office-wps.desktop"
					"wps-office-et.desktop"
					"wps-office-wpp.desktop"
					"wps-office-prometheus.desktop"
					"wps-office-pdf.desktop"
				];
				name = "办公";
			};
			"org/gnome/desktop/app-folders/folders/8df02a2b-1971-4662-9958-79020815a932" = {
				apps = [
					"gummi.desktop"
					"clion.desktop"
					"zotero.desktop"
					"pycharm-professional.desktop"
					"super-productivity.desktop"
					"app.drey.Planner.desktop"
					"code.desktop"
				];
				name = "科研";
				translate = false;
			};
			"org/gnome/desktop/app-folders/folders/Pardus" = {
				categories = [
					"X-Pardus-Apps"
				];
				name = "X-Pardus-Apps.directory";
				translate=true;
			};
			"org/gnome/desktop/app-folders/folders/Utilities" = {
				apps = [
					"org.freedesktop.GnomeAbrt.desktop"
					"nm-connection-editor.desktop"
					"org.gnome.baobab.desktop"
					"org.gnome.Connections.desktop"
					"org.gnome.DejaDup.desktop"
					"org.gnome.DiskUtility.desktop"
					"org.gnome.Evince.desktop"
					"org.gnome.FileRoller.desktop"
					"org.gnome.font-viewer.desktop"
					"org.gnome.Loupe.desktop"
					"org.gnome.seahorse.Application.desktop"
					"org.gnome.tweaks.desktop"
					"org.gnome.Usage.desktop"
				];
				categories = [ "X-GNOME-Utilities" ];
				name = "X-GNOME-Utilities.directory";
				translate = true;
			};
			"org/gnome/desktop/app-folders/folders/YaST" = {
				categories = [ "X-SuSE-YaST" ];
				name = "suse-yast.directory";
				translate = true;
			};
			"org/gnome/desktop/app-folders/folders/a9a37de2-e709-4139-9a1e-ffb28e3210e6" = {
				apps = [ 
					"org.gnome.SystemMonitor.desktop"
					"org.gnome.clocks.desktop"
					"org.gnome.Extensions.desktop"
					"org.gnome.Software.desktop"
				];
				name = "附件";
				translate = false;
			};
			"org/gnome/desktop/app-folders/folders/c4fc5d17-3acc-44b9-8511-7af4dbeb81bb" = {
				apps = [
					"io.gitlab.adhami3310.Impression.desktop"
					"org.gnome.TextEditor.desktop"
					"motrix.desktop"
				];
				name = "便捷";
				translate = false;
			};
			"org/gnome/desktop/app-folders/folders/ff66f84b-120c-4f5f-b1be-ea30109916f9" = {
				apps = [
					"com.tencent.wechat.desktop"
					"wemeet-bin.desktop""qq.desktop"
				];
				name = "聊天";
				translate = false;
			};
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = (with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          kimpanel.extensionUuid
          dash-to-dock.extensionUuid
          logo-menu.extensionUuid
          applications-menu.extensionUuid
          places-status-indicator.extensionUuid
          user-themes.extensionUuid
          # system-monitor.extensionUuid # Useless
          appindicator.extensionUuid
          light-style.extensionUuid
          tiling-shell.extensionUuid
        ]);
      };
      "org/gnome/Console" = {
        custom-font = "MesloLGM Nerd Font 13";
        theme = "auto";
        use-system-font = false;
      };
      "org/gnome/TextEditor" = {
        custom-font = "Mononoki Nerd Font 13";
        use-system-font = false;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/feng/.bigsur.jpg";
        picture-uri-dark = "file:///home/feng/.bigsur.jpg";
      };
      "org/gnome/desktop/interface" = {
        cursor-theme = "WhiteSur-cursors";
        gtk-theme = "WhiteSur-Light";
        icon-theme = "WhiteSur";
        document-font-name = "Mononoki Nerd Font 11";
        monospace-font-name = "Mononoki Nerd Font Mono 10";
      };
      "org/gnome/shell/extensions/Logo-menu" = {
        menu-button-icon-image = 23;
        menu-button-terminal = "kgx";
        symbolic-icon = true;
        use-custom-icon = false;
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = true;
        custom-theme-shrink = true;
        show-show-apps-button = false;
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-Light";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = false;
        night-light-schedule-from = 18.0;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "Launch Terminal";
      };
      "org/gnome/shell/extensions/tilingshell" = {
        enable-autotiling = true;
        enable-blur-selected-tilepreview = true;
        enable-blur-snap-assistant = true;
        enable-screen-edges-windows-suggestions = true;
        enable-tiling-system-windows-suggestions = true;
        top-edge-maximize = true;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
				blur = true;
				enable-all = true;
			};
			"org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
				blur = true;
				static-blur = false;
			};
			"org/gnome/shell/extensions/blur-my-shell/panel" = {
				force-light-text = true;
				static-blur = false;
			};
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
  
  # Auto start apps.
  home.file.".config/autostart".text = "motrix.desktop";
}
