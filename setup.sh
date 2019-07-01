#!/bin/bash
# icons
# ❌⏳💀🎉 ℹ️ ⚠️ 🚀 ✅ ♻ 🚮 🛡 🔧  ⚙ 

# run update and upgrade, before running script
# apt update && apt upgrade -y
# curl -L --silent https://bit.ly/320yIij | bash

# TODO 
# systemctl enable sshd
# sed sshd_config for permit root login and password, x11 forwarding, etc
# systemctl restart sshd

# set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE="\033[01;34m" # Heading
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'
BOLD="\033[01;01m" # Highlight
RESET="\033[00m" # Normal

# set env variable for apt-get installs
export DEBIAN_FRONTEND=noninteractive

# verify running as root
if [[ "${EUID}" -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}" 1>&2
  echo -e ' '${RED}'[!]'${RESET}" Quitting..." 1>&2
  exit 1
else
  echo -e "  🚀 ${BOLD}Starting Kali setup script${RESET}"
fi


compute_start_time(){
    start_time=$(date +%s)
    echo "\n\n Install started - $start_time \n" >> script.log
}

apt_update() {
    printf "  ⏳  apt-get update\n"
    apt-get update -qq >> script.log 2>>script_error.log
}

apt_upgrade() {
    printf "  ⏳  apt-get upgrade\n"
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq >> script.log 2>>script_error.log
}

apt_package_install() {
    echo "\n [+] installing $1 via apt-get\n" >> script.log
    apt-get install -y -qq --print-uris $1 >> script.log 2>>script_error.log
}

kali_metapackages() {
    printf "  ⏳  install Kali metapackages\n"
    for package in kali-linux-forensic kali-linux-pwtools kali-linux-rfid kali-linux-sdr kali-linux-voip kali-linux-web kali-linux-wireless forensics-all
    do
        apt_package_install $package
    done
}

install_kernel_headers() {
    printf "  ⏳  install kernel headers\n"
    apt -y -qq install make gcc "linux-headers-$(uname -r)" >> script.log 2>>script_error.log \
    || printf ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
    if [[ $? != 0 ]]; then
    echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue installing kernel headers${RESET}" 1>&2
        printf " ${YELLOW}[i]${RESET} Are you ${YELLOW}USING${RESET} the ${YELLOW}latest kernel${RESET}?"
        printf " ${YELLOW}[i]${RESET} ${YELLOW}Reboot${RESET} your machine"
    fi
}

install_python2_related(){
    printf "  ⏳  Installing python2 related libraries\n"
    # terminaltables - 
    # pwntools - 
    pip -q install terminaltables pwntools xortool
}

install_python3_related(){
    printf "  ⏳  Installing python3 related libraries\n"
    # pipenv - python virtual environments
    # pysmb - python smb library used in some exploits
    # pycryptodome - python crypto module
    # pysnmp - 
    # requests - 
    # future - 
    # paramiko - 
    pip3 -q install pipenv pysmb pycryptodome pysnmp requests future paramiko
}

install_base_os_tools(){
    printf "  ⏳  Installing base os tools programs\n"
    # apt-transport-https - enable https for apt
    # network-manager-openvpn-gnome - 
    # openresolv - 
    # strace - 
    # ltrace - 
    # gnome-screenshot - 
    # sshfs - mount file system over ssh
    # nfs-common - 
    # open-vm-tools-desktop - for vmware intergration
    # sshuttle - VPN/proxy over ssh 
    # autossh - specify password ofr ssh in cli
    # gimp - graphics design
    # transmission-gtk - bittorrent client
    # dbeaver - GUI universal db viewer
    # jq - cli json processor
    # aria2 - CLI download manager with torrent and http resume support
    # git-sizer - detailed size information on git repos
    for package in apt-transport-https network-manager-openvpn-gnome openresolv strace ltrace gnome-screenshot sshfs nfs-common open-vm-tools-desktop sshuttle autossh gimp transmission-gtk dbeaver jq aria2 git-sizer
    do
        apt_package_install $package
    done 
}

install_usb_gps(){
    printf "  ⏳  Installing gpsd for USB GPS Receivers\n"
    # gpsd - daemon for USB GPS device
    # gpsd-clients - communicate with gpsd and utilities
    for package in gpsd gpsd-clients
    do
        apt_package_install $package
    done
}

install_re_tools(){
    printf "  ⏳  Installing re programs\n"
    # exiftool - 
    # okteta - 
    # hexcurse - 
    for package in exiftool okteta hexcurse
    do
        apt_package_install $package
    done 
}

install_exploit_tools(){
    printf "  ⏳  Installing exploit programs\n"
    # gcc-multilib - multi arch libs
    # mingw-w64 - windows compile
    # crackmapexec - pass the hash
    for package in gcc-multilib mingw-w64 crackmapexec
    do
        apt_package_install $package
    done 
}

install_steg_programs(){
    printf "  ⏳  Installing steg programs\n"
    # stegosuite - steganography
    # steghide - steganography
    # steghide-doc - documentation for steghide
    for package in stegosuite steghide steghide-doc  
    do
        apt_package_install $package
    done
}

install_web_tools(){
    printf "  ⏳  Installing web programs\n"
    # gobuster - directory brute forcer
    for package in gobuster
    do
        apt_package_install $package
    done 
}

folder_prep(){
    # create folders for later installs and workflow
    printf "  ⏳  making directories\n"
    mkdir -p /root/git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/utils
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/dev
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/share
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
}

github_desktop() {
    printf "  ⏳  Github desktop - fork for linux https://github.com/shiftkey/desktop/releases\n"
    cd /root/Downloads
    wget --quiet https://github.com/shiftkey/desktop/releases/download/release-1.6.6-linux2/GitHubDesktop-linux-1.6.6-linux2.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    apt_package_install ./GitHubDesktop-linux*
    rm -f ./GitHubDesktop-linux*
}

vscode() {
     printf "  ⏳  Installing VS Code\n"
    # Download the Microsoft GPG key, and convert it from OpenPGP ASCII 
    # armor format to GnuPG format
    curl --silent https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    # Move the file into your apt trusted keys directory (requires root)
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    # Add the VS Code Repository
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

    # Update and install Visual Studio Code 
    apt_update
    apt_package_install code
}

install_rtfm(){
    printf "  ⏳  Installing RTFM\n"
    git clone --quiet https://github.com/leostat/rtfm.git /opt/rtfm/
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    chmod +x /opt/rtfm/rtfm.py
    /opt/rtfm/rtfm.py -u >> script.log 2>&1
    sed -i '/export PATH/s/$/\/opt\/rtfm:/' /root/.bashrc
}

install_docker(){
    printf "  ⏳  Installing docker\n"
    curl -fsSL --silent https://download.docker.com/linux/debian/gpg | sudo apt-key add - >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo 'deb https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list
    apt_update
    echo "\n [+] installing docker-ce via apt-get\n" >> script.log
    apt-get install -y -q docker-ce >> script.log 2>>script_error.log
    systemctl enable docker >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    docker version >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

pull_cyberchef(){
    printf "  ⏳  Install cyberchef docker container\n"
    docker pull remnux/cyberchef >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo "# Run docker cyberchef" >> script_todo.log  
    echo "# docker run -d -p 8080:8080 remnux/cyberchef" >> script_todo.log  
    echo "# http://localhost:8080/" >> script_todo.log  
    echo "# docker ps" >> script_todo.log  
    echo "# docker stop <container id>" >> script_todo.log  
}

install_ghidra(){
    printf "  ⏳  Install Ghidra\n"
    cd /root/utils
    wget --quiet https://www.ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    unzip -qq ghidra*
    sed -i '/export PATH/s/$/\/root\/utils\/ghidra_9.0:/' /root/.bashrc
    rm ghidra*.zip
}

install_peda() {
    printf "  ⏳  Install Python Exploit Development Assistance\n"
    cd /root/utils
    git clone --quiet https://github.com/longld/peda.git ~/peda
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    echo "source /root/utils/peda/peda.py" >> ~/.gdbinit
}

install_gef(){
    printf "  ⏳  Install GDB Enhanced Features - similar to peda\n"
    cd /root/utils
    wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    echo source /root/utils/.gdbinit-gef.py >> ~/.gdbinit
    cd ~
}

install_binary_ninja(){
    printf "  ⏳  Install binary ninja\n"
    cd /root/utils
    wget --quiet https://cdn.binary.ninja/installers/BinaryNinja-demo.zip
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    unzip -qq BinaryNinja-demo.zip
    rm BinaryNinja-demo.zip
    sed -i '/export PATH/s/$/\/root\/utils\/binaryninja:/' /root/.bashrc
    cd ~
}

install_routersploit_framework(){
    printf "  ⏳  Install routersploit framework\n"
    cd /root/utils
    git clone --quiet https://www.github.com/threat9/routersploit
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    cd routersploit
    python3 -m pip install -q -r requirements.txt
    sed -i '/export PATH/s/$/\/root\/utils\/routersploit:/' /root/.bashrc
    cd ~
}

install_stegcracker(){
    printf "  ⏳  Install Stegcracker\n"
    curl --silent https://raw.githubusercontent.com/Paradoxis/StegCracker/master/stegcracker > /usr/local/bin/stegcracker
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi    
    chmod +x /usr/local/bin/stegcracker
}

install_wine(){
    printf "  ⏳  Install wine & wine32\n"
    dpkg --add-architecture i386
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    apt_update
    apt_package_install wine32 
    apt_package_install wine
}

install_dirsearch(){
    printf "  ⏳  Install dirseach\n"
    cd /root/utils
    git clone --quiet https://github.com/maurosoria/dirsearch.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_chrome(){
    printf "  ⏳  Install Chrome\n"
    wget --quiet https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    apt_package_install ./google-chrome-stable_current_amd64.deb
    rm -f ./google-chrome-stable_current_amd64.deb
    # enable chrome start as root
    cp /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable.old && sed -i 's/^\(exec.*\)$/\1 --user-data-dir/' /usr/bin/google-chrome-stable
    sed -i -e 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --no-sandbox@g' /usr/share/applications/google-chrome.desktop 
    # chrome alias
    echo "alias chrome='google-chrome-stable --no-sandbox file:///root/dev/start_page/index.html'" >> /root/.bashrc
}

install_chromium(){
    printf "  ⏳  Install Chromium\n"
    apt_package_install chromium
    echo "# simply override settings above" >> /etc/chromium/default
    echo 'CHROMIUM_FLAGS="--password-store=detect --user-data-dir"' >> /etc/chromium/default
}

install_nmap_vulscan(){
    printf "  ⏳  Install NMAP vulscan\n"
    cd /usr/share/nmap/scripts/
    git clone --quiet https://github.com/scipag/vulscan.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

bash_aliases() {
    printf "  ⏳  adding bash aliases\n"
    # git aliases
    echo "alias gs='git status'" >> /root/.bashrc
    echo "alias ga='git add -A'" >> /root/.bashrc
    # increase history size
    sed -i "s/HISTSIZE=1000/HISTSIZE=1000000/g" /root/.bashrc
    # establish path baseline
    echo "export PATH=$PATH:" >> /root/.bashrc
}

john_bash_completion() {
    printf "  ⏳  enabling john bash completion\n"
    echo ". /usr/share/bash-completion/completions/john.bash_completion" >> /root/.bashrc
}

unzip_rockyou(){
    printf "  ⏳  Install gunzip rockyou\n"
    cd /usr/share/wordlists/
    gunzip -q /usr/share/wordlists/rockyou.txt.gz
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_gnome_theme(){
    printf "  ⏳  install gnome tweak packages & custom theme\n"
    apt_package_install gtk2-engines-murrine 
    apt_package_install gtk2-engines-pixbuf
    cd ~
    git clone --quiet https://github.com/vinceliuice/vimix-gtk-themes
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd vimix-gtk-themes
    ./Install -n vimix -c dark -t beryl
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

install_sourcepro_font(){
    printf "  ⏳  install sourcepro font\n"
    cd /root
    curl --silent --output google-mono-source.zip https://fonts.google.com/download?family=Source%20Code%20Pro
    7z x google-mono-source.zip >> script.log
    mv SourceCodePro-* /usr/share/fonts
    rm google-mono-source.zip
}

configure_gnome_settings(){
    # use "dconf watch /" then use gnome tweks to change settings and it will print below
    printf "  ⏳  tweaking gnome settings\n"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout '0'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout '0'
    gsettings set org.gnome.desktop.session idle-delay '0'
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.interface enable-animations false
    # set dark theme
    dconf write /org/gnome/desktop/interface/icon-theme "'Zen-Kali-Dark'"
    dconf write /org/gnome/desktop/interface/gtk-theme "'vimix-dark-laptop-beryl'"
    dconf write /org/gnome/shell/extensions/user-theme/name "'vimix-dark-laptop-beryl'"
    # set scaling for tiny fonts
    dconf write /org/gnome/desktop/interface/text-scaling-factor 0.79999999999999982
    # set more detailed date/time
    dconf write /org/gnome/desktop/interface/clock-show-seconds true
    dconf write /org/gnome/desktop/interface/clock-show-date true
    dconf write /org/gnome/desktop/interface/clock-show-weekday true
    # set font
    dconf write /org/gnome/desktop/interface/monospace-font-name "'Source Code Pro 11'"
    # set cursor focus
    dconf write /org/gnome/desktop/wm/preferences/focus-mode "'sloppy'"
    # show trash icon
    # show application windows at bottom
    dconf write /org/gnome/shell/enabled-extensions "['apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'workspace-indicator@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'ProxySwitcher@flannaghan.com', 'EasyScreenCast@iacopodeenosee.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'desktop-icons@csoriano', 'window-list@gnome-shell-extensions.gcampax.github.com']"
    # fix application menu width
    sed -i "s/this.categoriesBox.box.width = 275;/this.mainBox.box.width = 900;\\n\\tthis.categoriesBox.box.width = 500;/g" /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com/extension.js
}

enable_auto_login(){
    printf "  ⏳  enabling autologin\n"
    sed -i "s/^#.*AutomaticLoginEnable/AutomaticLoginEnable/g ; s/#.*AutomaticLogin/AutomaticLogin/g" /etc/gdm3/daemon.conf
}

compute_finish_time(){
    finish_time=$(date +%s)
    echo -e "  ⌛ Time (roughly) taken: ${YELLOW}$(( $(( finish_time - start_time )) / 60 )) minutes${RESET}"
    echo "\n\n Install completed - $finish_time \n" >> script.log
}

main () {
    compute_start_time
    apt_update
    #apt_upgrade
    kali_metapackages
    install_kernel_headers
    install_python2_related
    install_python3_related
    install_base_os_tools
    install_usb_gps
    install_re_tools
    install_exploit_tools
    install_steg_programs
    install_web_tools
    folder_prep
    github_desktop
    vscode
    install_rtfm
    install_docker
    pull_cyberchef
    install_ghidra
    install_peda
    #install_gef
    install_binary_ninja
    install_routersploit_framework
    install_stegcracker
    install_wine
    install_dirsearch
    install_chrome
    install_chromium
    install_nmap_vulscan
    bash_aliases
    john_bash_completion
    unzip_rockyou
    install_gnome_theme
    install_sourcepro_font
    configure_gnome_settings
    enable_auto_login
    compute_finish_time
}

main    
