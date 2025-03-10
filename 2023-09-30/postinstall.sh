#!/bin/bash
set -e;

#################################
#
# Arch Linux Post-Install Script
#
# Created:  2023-09-30
# Device:   Lenovo IdeaPad 5 15ARE05
# CPU:      AMD Ryzen 5 4500U
# GPU:      AMD Ryzen APU
# RAM:      16GB
# Storage:  512GB SSD (NVMe)
# Desktop:  Gnome
#
#################################

########## Change Password ##########
passwd;


########## Update System ##########
sudo pacman -Syyu;


########## Install Essentials ##########
sudo pacman -S --needed --noconfirm git wget neovim;


########## Setup Gnome ##########
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'";
dconf write /org/gnome/desktop/interface/enable-hot-corners false;
dconf write /org/gnome/desktop/interface/show-battery-percentage true;

dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'de')]";
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true;

dconf write /org/gnome/desktop/session/idle-delay "uint32 0";
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'";
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type "'nothing'";

dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/gnome/blobs-l.svg'";
dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/gnome/blobs-d.svg'";
dconf write /org/gnome/desktop/screensaver/picture-uri "'file:///usr/share/backgrounds/gnome/blobs-d.svg'";

dconf write /org/gnome/shell/favorite-apps "['com.google.Chrome.desktop', 'org.mozilla.firefox.desktop', 'org.gnome.Epiphany.desktop', 'org.gnome.Console.desktop', 'com.visualstudio.code.desktop', 'org.gnome.Nautilus.desktop', 'md.obsidian.Obsidian.desktop', 'org.remmina.Remmina.desktop', 'org.gnome.Software.desktop', 'gnome-system-monitor.desktop']";

dconf write /org/gnome/Console/font-scale 1.2;

########## Install Grub Theme ##########
git clone --depth=1 https://github.com/vinceliuice/grub2-themes grub-themes;
cd grub-themes;
sudo ./install.sh -t tela -s 1080p;
cd ..;
rm -rf grub-themes;


########## Ensure proper Graphics Drivers ##########
sudo pacman -S --needed --noconfirm \
    vulkan-icd-loader \
    vulkan-radeon \
    mesa;


########## Install Python ###########
sudo pacman -S --needed --noconfirm python python-pip;


########## Install Node Version Manager ##########
NVM_DIR="$HOME/.nvm";
git clone https://github.com/nvm-sh/nvm.git ${NVM_DIR};
cd ${NVM_DIR};
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`;
\. ${NVM_DIR}/nvm.sh;
chmod 777 ${NVM_DIR};
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 18;


########## Install and Setup ZSH ##########
sudo pacman -S --needed --noconfirm zsh starship;
sudo usermod -s /usr/bin/zsh mrs;
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-plugins/zsh-autosuggestions;
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-plugins/zsh-syntax-highlighting;

mkdir -p ~/.config;
starship preset pastel-powerline > ~/.config/starship.toml;

cat <<EOF > ~/.zshrc
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"

alias ls="ls --color=auto"
alias code="flatpak run com.visualstudio.code"

source ~/.zsh/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "\$(starship init zsh)"
EOF


########## Install User Programs ##########
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
flatpak install -y flathub com.google.Chrome;
flatpak install -y flathub org.mozilla.firefox;
flatpak install -y flathub org.gnome.Epiphany;
flatpak install -y flathub org.gnome.gitlab.somas.Apostrophe;
flatpak install -y flathub rest.insomnia.Insomnia;
flatpak install -y flathub com.visualstudio.code;
flatpak install -y flathub org.sqlitebrowser.sqlitebrowser;
flatpak install -y flathub org.filezillaproject.Filezilla;
flatpak install -y flathub md.obsidian.Obsidian;
flatpak install -y flathub com.github.jeromerobert.pdfarranger;
flatpak install -y flathub org.remmina.Remmina;
flatpak install -y flathub org.onlyoffice.desktopeditors;


########### Install VSCode Extensions ###########
flatpak run com.visualstudio.code --install-extension eamodio.gitlens;
flatpak run com.visualstudio.code --install-extension esbenp.prettier-vscode;
flatpak run com.visualstudio.code --install-extension svelte.svelte-vscode;
flatpak run com.visualstudio.code --install-extension bradlc.vscode-tailwindcss;
flatpak run com.visualstudio.code --install-extension ms-python.python;
flatpak run com.visualstudio.code --install-extension ms-python.vscode-pylance;
flatpak run com.visualstudio.code --install-extension zhuangtongfa.Material-theme;


########### Setup VS-Code Default Settings ##########
mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User;
cat <<EOF > ~/.var/app/com.visualstudio.code/config/Code/User/settings.json
{
  "window.zoomLevel": 1,
  "workbench.colorTheme": "One Dark Pro Darker",
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.profiles.linux": {
    "bash": {
      "path": "/usr/bin/flatpak-spawn",
      "args": ["--host", "--env=TERM=xterm-256color", "bash"]
      "icon": "terminal-bash",
      "overrideName": true
    }
  }
}
EOF
