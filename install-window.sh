#!/usr/bin/env bash

cat /etc/pacman.d/mirrorlist
sudo pacman -Syu --needed cmake ninja git neovim nodejs-lts-jod npm python-pip ripgrep fd luarocks wl-clipboard speech-dispatcher zip unzip tldr power-profiles-daemon python-gobject lazygit btop ufw fwupd udisks2 nnn bluez bluetui noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-sourcecodepro-nerd man-db man-pages bemenu bemenu-wayland j4-dmenu-desktop tesseract-data-eng dunst libnotify rtkit polkit-gnome mpv imv zathura zathura-pdf-mupdf fcitx5 fcitx5-configtool fcitx5-qt fcitx5-chinese-addons libreoffice-fresh
sudo pacman -Rsun waybar wmenu
sudo pacman -Scc
sudo mandb

sudo bootctl set-timeout "0"
sudo mkdir /etc/systemd/logind.conf.d
sudo bash -c 'echo -e "[Login]\nHandlePowerKey=suspend" > /etc/systemd/logind.conf.d/power-key.conf'
sudo sed -zi '/EDITOR=nvim/!s/$/EDITOR=nvim/' /etc/environment
sudo sed -i "s/^#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=1s/g" /etc/systemd/system.conf
sudo sed -i "s/^# deny.*/deny = 10/g" /etc/security/faillock.conf

sudo systemctl enable --now bluetooth
sudo systemctl enable --now power-profiles-daemon
sudo systemctl enable --now ufw
sudo powerprofilesctl set power-saver
sudo ufw enable
sudo ufw allow 22/tcp

git config --global user.name "yongrongwang"
git config --global user.email "2278508989@qq.com"
ssh-keygen -t ed25519 -C "2278508989@qq.com"
cat ~/.ssh/id_ed25519.pub
while : ; do
    sudo bash -c "$(curl -fsSL https://get.hy2.sh/)"
    [ $? -ne 0 ] || break
done
ssh -T git@github.com

mkdir -p ~/Documents/repos
cd ~/Documents/repos
rm -rf ~/.config/nvim ble.sh dot-files dot-files-wm notes
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
git clone https://github.com/yongrongwang/starter.git ~/.config/nvim
git clone https://github.com/yongrongwang/dot-files.git
git clone https://github.com/yongrongwang/dot-files-wm.git
git clone https://github.com/yongrongwang/notes.git

make -C ble.sh install PREFIX=~/.local
cd dot-files
cp .bash* ~/
cp -r .config/lazygit ~/.config/
sudo cp -f etc/hysteria-client/config.yaml /etc/hysteria/config.yaml
cd ../dot-files-wm
cp -r .config/* ~/.config/
mv ~/.config/wallpapers ~/.local/share/
cd ..
rm -rf ble.sh

read -p "IP to ssh: " host
read -p "IP for hysteria: " ip
read -p "Port for hysteria: " port
read -p "Password for hysteria: " pwd
mkdir ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
echo -e "Host v\n  HostName\n  User root\n  ServerAliveInterval 600" > ~/.ssh/config
sed -i "s/HostName.*/HostName $host/g" ~/.ssh/config
sudo sed -i "s/server:.*/server: $ip:$port/g" /etc/hysteria/config.yaml
sudo sed -i "s/auth:.*/auth: $pwd/g" /etc/hysteria/config.yaml
sudo sed -i "s/server/client/g" /etc/systemd/system/hysteria-server.service
sudo sed -i "/ExecStart/iExecStartPre=/bin/sh -c 'until ping -c 1 baidu.com; do sleep 1; done;'" /etc/systemd/system/hysteria-server.service

sudo chown hysteria /etc/hysteria/*
sudo systemctl enable --now hysteria-server
systemctl status hysteria-server

export http_proxy=http://127.0.0.1:8080/
export https_proxy=$http_proxy
sleep 1
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf yay-bin

ssh-copy-id v
fwupdmgr refresh
fwupdmgr update

nvim
find ~/.cache/ -type f -amin +1 -delete
sudo reboot
