#!/bin/bash
set -e;

#################################
#
# Arch Linux Post-Install Script
#
# Created:  2025-03-27
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


########## Rustup ##########
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y;


########## Dotfiles ##########
git clone https://github.com/MoritzRS/dotfiles.git && \
    cp -r ./dotfiles/.config/* ~/.config/ && \
    cp ./dotfiles/.zshrc ~/.zshrc && \
    rm -rf dotfiles;


########## Flatpak User Applications ##########
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;

# Gnome Desktop Suite
flatpak install --user -y flathub org.gnome.baobab;
flatpak install --user -y flathub org.gnome.Boxes;
flatpak install --user -y flathub org.gnome.Calculator;
flatpak install --user -y flathub org.gnome.Calendar;
flatpak install --user -y flathub org.gnome.Characters;
flatpak install --user -y flathub org.gnome.clocks;
flatpak install --user -y flathub org.gnome.Connections;
flatpak install --user -y flathub org.gnome.Contacts;
flatpak install --user -y flathub org.gnome.Decibels;
flatpak install --user -y flathub org.gnome.DejaDup;
flatpak install --user -y flathub org.gnome.Epiphany;
flatpak install --user -y flathub org.gnome.font-viewer;
flatpak install --user -y flathub org.gnome.Logs;
flatpak install --user -y flathub org.gnome.Loupe;
flatpak install --user -y flathub org.gnome.Maps;
flatpak install --user -y flathub org.gnome.Papers;
flatpak install --user -y flathub org.gnome.Showtime;
flatpak install --user -y flathub org.gnome.Snapshot;
flatpak install --user -y flathub org.gnome.SoundRecorder;
flatpak install --user -y flathub org.gnome.TextEditor;
flatpak install --user -y flathub org.gnome.Weather;

flatpak install --user -y flathub org.gnome.World.Secrets;
flatpak install --user -y flathub com.belmoussaoui.Authenticator;
flatpak install --user -y flathub com.mattjakeman.ExtensionManager;
flatpak install --user -y flathub io.github.mrvladus.List;
flatpak install --user -y flathub app.drey.Dialect;
flatpak install --user -y flathub re.sonny.Eloquent;
flatpak install --user -y flathub org.gnome.gitlab.somas.Apostrophe;
flatpak install --user -y flathub com.github.johnfactotum.Foliate;

# Additional Browsers
flatpak install --user -y flathub com.google.Chrome;
flatpak install --user -y flathub org.chromium.Chromium;
flatpak install --user -y flathub org.mozilla.firefox;
flatpak install --user -y flathub app.zen_browser.zen;

# Development Tools
flatpak install --user -y flathub com.github.marhkb.Pods;
flatpak install --user -y flathub org.sqlitebrowser.sqlitebrowser;
flatpak install --user -y flathub org.filezillaproject.Filezilla;

# Office and Documentation
flatpak install --user -y flathub md.obsidian.Obsidian;
flatpak install --user -y flathub com.github.jeromerobert.pdfarranger;
flatpak install --user -y flathub org.onlyoffice.desktopeditors;
flatpak install --user -y flathub org.inkscape.Inkscape;

# Youtube Music
wget https://github.com/th-ch/youtube-music/releases/download/v3.7.5/YouTube-Music-3.7.5-x86_64.flatpak && \
    flatpak install --user -y YouTube-Music-3.7.5-x86_64.flatpak && \
    rm YouTube-Music-3.7.5-x86_64.flatpak;


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

gsettings set org.gnome.desktop.background picture-uri "'file:///usr/share/backgrounds/gnome/amber-l.jxl'";
gsettings set org.gnome.desktop.background picture-uri-dark "'file:///usr/share/backgrounds/gnome/amber-d.jxl'";
gsettings set org.gnome.desktop.screensaver picture-uri "'file:///usr/share/backgrounds/gnome/amber-l.jxl'";

gsettings set org.gnome.shell favorite-apps "['app.zen_browser.zen.desktop', 'org.chromium.Chromium.desktop', 'org.mozilla.firefox.desktop', 'org.gnome.Epiphany.desktop', 'com.github.th_ch.youtube_music.desktop', 'md.obsidian.Obsidian.desktop', 'com.mitchellh.ghostty.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.gnome.Connections.desktop', 'org.gnome.SystemMonitor.desktop']";

