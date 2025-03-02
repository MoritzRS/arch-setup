#!/bin/bash
set -e;

#################################
#
# Arch Linux Post-Install Script
#
# Created:  2025-03-02
# Device:   Lenovo IdeaPad 5 15ARE05
# CPU:      AMD Ryzen 5 4500U
# GPU:      AMD Ryzen APU
# RAM:      16GB
# Storage:  512GB SSD (NVMe)
# Desktop:  Gnome
#
#################################

GIT_USER="MoritzRS";
GIT_EMAIL="replace@me.com";


########## Git Configuration ##########
git config --global user.name "$GIT_USER";
git config --global user.email "$GIT_EMAIL";
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret;


########## NodeJS Version Manager ##########
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh";
nvm install --lts;


########## Flatpak User Applications ##########
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;

flatpak install --user -y flathub org.chromium.Chromium;
flatpak install --user -y flathub org.mozilla.firefox;
flatpak install --user -y flathub org.gnome.Epiphany;
flatpak install --user -y flathub app.zen_browser.zen;

flatpak install --user -y flathub org.sqlitebrowser.sqlitebrowser;
flatpak install --user -y flathub org.filezillaproject.Filezilla;
flatpak install --user -y flathub org.remmina.Remmina;

flatpak install --user -y flathub md.obsidian.Obsidian;
flatpak install --user -y flathub com.github.jeromerobert.pdfarranger;
flatpak install --user -y flathub org.onlyoffice.desktopeditors;

flatpak install --user -y flathub com.mattjakeman.ExtensionManager;

wget https://github.com/th-ch/youtube-music/releases/download/v3.7.4/YouTube-Music-3.7.4-x86_64.flatpak && \
    flatpak install --user -y YouTube-Music-3.7.4-x86_64.flatpak && \
    rm YouTube-Music-3.7.4-x86_64.flatpak;


########## Gnome Extensions ##########
wget https://github.com/domferr/tilingshell/releases/download/16.2.0/tilingshell@ferrarodomenico.com.zip && \
    gnome-extensions install tilingshell@ferrarodomenico.com.zip && \
    rm tilingshell@ferrarodomenico.com.zip;

wget https://github.com/micheleg/dash-to-dock/releases/download/extensions.gnome.org-v100/dash-to-dock@micxgx.gmail.com.zip && \
    gnome-extensions install dash-to-dock@micxgx.gmail.com.zip && \
    rm dash-to-dock@micxgx.gmail.com.zip;


########## Gnome Settings ##########
gsettings set org.gnome.desktop.interface color-scheme "'prefer-dark'";
gsettings set org.gnome.desktop.interface enable-hot-corners false;
gsettings set org.gnome.desktop.interface show-battery-percentage true;
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]";
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true;

gsettings set org.gnome.desktop.session idle-delay 0;
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'nothing'";
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "'nothing'";

gsettings set org.gnome.desktop.background picture-uri "'file:///usr/share/backgrounds/gnome/blobs-l.svg'";
gsettings set org.gnome.desktop.background picture-uri-dark "'file:///usr/share/backgrounds/gnome/blobs-d.svg'";
gsettings set org.gnome.desktop.screensaver picture-uri "'file:///usr/share/backgrounds/gnome/blobs-d.svg'";

gsettings set org.gnome.shell favorite-apps "['app.zen_browser.zen.desktop', 'org.chromium.Chromium.desktop', 'org.mozilla.firefox.desktop', 'org.gnome.Epiphany.desktop', 'com.github.th_ch.youtube_music.desktop', 'md.obsidian.Obsidian.desktop', 'com.mitchellh.ghostty.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.remmina.Remmina.desktop', 'org.gnome.SystemMonitor.desktop']";