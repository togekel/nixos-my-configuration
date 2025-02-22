# NixOS Configuration for 24.11 with flakes
![MacOS-like Theme](https://github.com/user-attachments/assets/ad94e3ad-0bbd-42cd-9744-e589b647adf8)
## Fetures
- [x] support for Nix Flakes.
- [x] support for Nur.
- [x] support for flatpak (preset sjtu mirror)
- [x] enable home-manager (as nixos module).
- [x] chinese fonts, nerd fonts, meslo fonts, etc.
- [x] fcitx5 chinese supported.
- [x] enable zsh.
- [x] firefox-bin.
- [x] virtualbox.
- [x] gnome-software for graphical flatpak.
- [x] qq.
- [x] wechat.
- [x] wemeet-wayland-screenshare(nur).
- [x] wpsoffice-cn(nur).
- [x] preset github ssh key (personal use).
- [x] python pkgs (numpy,pandas,matplotlib).
- [x] macos-like gtk theme (installed but need to be selected by hand through gnome-tweaks).
- [x] bigsur hd background (~/.bigsur.jpg).
- [x] app menu.
- [x] logo menu.
- [x] system monitor on top.
- [x] systray (need by qq, wechat).
- [x] blur-shell.
- [x] dash-to-dock (need adjust by hand).
## Useful Shell Alias
- ll: `ls -l`
- modify: fetch configuration repo from github and cd
- commit: auto commit changes and push to remote.
- update: update remote flake.lock
- collect: `nix-store --gc`
- refresh: delete old generatons.
- rebuild: nixos-rebuild using remote flake.
- optimise: optimise storage by hard-linking.
- gte: `gnome-text-editor`
## Notice
- Don't directly use this flake! You need replace hardware-configuration.nix into your own and edit user info in configuration.nix.
- To launch console in logo menu, the shortcut should be changed into kgx (cmd of console).
