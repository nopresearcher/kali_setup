#!/bin/bash
# icons
# ❌⏳💀🎉 ℹ️ ⚠️ 🚀 ✅ ♻ 🚮 🛡 🔧  ⚙ 

# run update and upgrade, before running script
# apt update && apt upgrade -y
# curl -L --silent https://bit.ly/320yIij | bash
#
# you may want to modify a few things like:
# configure_git
# configure_vim
# configure_wireshark
#
# TODO 
# change /etc/resolv.conf to 8.8.8.8
# systemctl enable sshd
# sed sshd_config for permit root login and password, x11 forwarding, etc
# systemctl restart sshd
# /usr/bin/script --append --flush --timing=/root/history/timing_"$(date +"%Y_%m_%d_%H_%M_%S_%N_%p").log" /root/history/terminal_"$(date +"%Y_%m_%d_%H_%M_%S_%N_%p").log"
# pip3 list --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install --upgrade
# pip list --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --upgrade
# gsettings set org.gnome.desktop.background picture-uri '/root/utils/kali_setup/media/wallpaper/dark-kali-2560-1600.png'
# git@github.com:mbahadou/postenum.git - postenumeration script
# git@github.com:j3ssie/Osmedeus.git - web scanning framework with local web server
# for loop for python packages in case one errors out

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

# set git to cache credentials for 30 minutes
git config --global credential.helper "cache --timeout=1800"

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

configure_environment(){
    echo "HISTTIMEFORMAT='%m/%d/%y %T '" >> /root/.bashrc
}

apt_update() {
    printf "  ⏳  apt-get update\n" | tee -a script.log
    apt-get update -qq >> script.log 2>>script_error.log
}

apt_upgrade() {
    printf "  ⏳  apt-get upgrade\n" | tee -a script.log
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq >> script.log 2>>script_error.log
}

apt_package_install() {
    echo "\n [+] installing $1 via apt-get\n" >> script.log
    apt-get install -y -q $1 >> script.log 2>>script_error.log
}

kali_metapackages() {
    printf "  ⏳  install Kali metapackages\n" | tee -a script.log
    for package in kali-linux-forensic kali-linux-pwtools kali-linux-rfid kali-linux-sdr kali-linux-voip kali-linux-web kali-linux-wireless forensics-all
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_kernel_headers() {
    printf "  ⏳  install kernel headers\n" | tee -a script.log
    apt -y -qq install make gcc "linux-headers-$(uname -r)" >> script.log 2>>script_error.log \
    || printf ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
    if [[ $? != 0 ]]; then
    echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue installing kernel headers${RESET}" 1>&2
        printf " ${YELLOW}[i]${RESET} Are you ${YELLOW}USING${RESET} the ${YELLOW}latest kernel${RESET}?"
        printf " ${YELLOW}[i]${RESET} ${YELLOW}Reboot${RESET} your machine"
    fi
}

install_python2_related(){
    printf "  ⏳  Installing python2 related libraries\n" | tee -a script.log
    # terminaltables - 
    # pwntools - 
    # xortool - 
    pip -q install terminaltables pwntools xortool
}

install_python3_pip(){
    printf "  ⏳  Installing python3-pip for python3 libraries\n" | tee -a script.log
    apt-get install -y -q python3-pip >> script.log 2>>script_error.log
}

install_python3_related(){
    printf "  ⏳  Installing python3 related libraries\n" | tee -a script.log
    # pipenv - python virtual environments
    # pysmb - python smb library used in some exploits
    # pycryptodome - python crypto module
    # pysnmp - 
    # requests - 
    # future - 
    # paramiko - 
    # selenium - control chrome browser
    # awscli - 
    # ansible - 
    # urh - universal radio hacker
    # pymodbus - python REPL for interacting with modbus devices
    # htbcli - hack the box cli
    pip3 -q install pipenv pysmb pycryptodome pysnmp requests future paramiko selenium awscli ansible urh pymodbus htbcli
}

install_base_os_tools(){
    printf "  ⏳  Installing base os tools programs\n" | tee -a script.log
    # apt-transport-https - enable https for apt
    # network-manager-openvpn-gnome - 
    # openresolv - 
    # strace - 
    # ltrace - 
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
    # libappindicator3-1 - support library for google chrome
    for package in apt-transport-https network-manager-openvpn-gnome openresolv strace ltrace sshfs nfs-common open-vm-tools-desktop sshuttle autossh gimp transmission-gtk dbeaver jq aria2 git-sizer cython3 python3-psutil python3-pyqt5 python3-zmq libappinidcator3-1
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_usb_gps(){
    printf "  ⏳  Installing gpsd for USB GPS Receivers\n" | tee -a script.log
    # gpsd - daemon for USB GPS device
    # gpsd-clients - communicate with gpsd and utilities
    for package in gpsd gpsd-clients
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_rf_tools(){
    printf "  ⏳  Installing tools for rf tools like hackrf\n" | tee -a script.log
    # hackrf - for hackrf device
    # libhackrf-dev - development library for hackrf - firmware upgrades
    # libhackrf0 - library for hackrf
    for package in hackrf libhackrf-dev libhackrf0
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_re_tools(){
    printf "  ⏳  Installing re programs\n" | tee -a script.log
    # exiftool - 
    # okteta - 
    # hexcurse - 
    for package in exiftool okteta hexcurse
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_exploit_tools(){
    printf "  ⏳  Installing exploit programs\n" | tee -a script.log
    # gcc-multilib - multi arch libs
    # mingw-w64 - windows compile
    # crackmapexec - pass the hash
    for package in gcc-multilib mingw-w64 crackmapexec
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_steg_programs(){
    printf "  ⏳  Installing steg programs\n" | tee -a script.log
    # stegosuite - steganography
    # steghide - steganography
    # steghide-doc - documentation for steghide
    # audacity - sound editor / spectogram
    for package in stegosuite steghide steghide-doc audacity
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_web_tools(){
    printf "  ⏳  Installing web programs\n" | tee -a script.log
    # gobuster - directory brute forcer
    for package in gobuster
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_mobile_tools(){
    printf "  ⏳  Installing web programs\n" | tee -a script.log
    # dex2jar - 
    for package in dex2jar
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_screencast_tools(){
    printf "  ⏳  Installing web programs\n" | tee -a script.log
    # ffmpeg - video codec support
    # ffmpeg-doc - documentation for ffmpeg
    # obs-studio - screen recording, streaming software
    for package in ffmpeg ffmpeg-doc
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

folder_prep(){
    # create folders for later installs and workflow
    printf "  ⏳  making directories\n" | tee -a script.log
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
    mkdir -p /root/ctf
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
    mkdir -p /root/.ssh
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/history
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
}

github_desktop() {
    printf "  ⏳  Github desktop - fork for linux https://github.com/shiftkey/desktop/releases\n" | tee -a script.log
    cd /root/Downloads
    wget --quiet https://github.com/shiftkey/desktop/releases/download/release-2.1.0-linux1/GitHubDesktop-linux-2.1.0-linux1.deb    
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    apt_package_install ./GitHubDesktop-linux*
    rm -f ./GitHubDesktop-linux*
}

install_vscode() {
    printf "  ⏳  Installing VS Code\n" | tee -a script.log
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
    apt-get install -y -q code >> script.log 2>>script_error.log
}

configure_vscode() {
    printf "  🔧  configure wireshark\n" | tee -a script.log
    code --user-data-dir /root/.vscode --install-extension christian-kohler.path-intellisense >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension coenraads.bracket-pair-colorizer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension eamodio.gitlens >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ibm.output-colorizer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-azuretools.vscode-docker >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-python.python >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode.cpptools >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh-edit >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh-explorer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension romanpeshkov.vscode-text-tables >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension shakram02.bash-beautify >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension shan.code-settings-sync >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension visualstudioexptteam.vscodeintellicode >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension vscode-icons-team.vscode-icons >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension yzhang.markdown-all-in-one >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension bibhasdn.unique-lines >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension wix.vscode-import-cost >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension aaron-bond.better-comments >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension formulahendry.auto-rename-tag >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension emilast.logfilehighlighter >> script.log 2>>script_error.log
}

install_rtfm(){
    printf "  ⏳  Installing RTFM\n" | tee -a script.log
    git clone --quiet https://github.com/leostat/rtfm.git /opt/rtfm/
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    chmod +x /opt/rtfm/rtfm.py
    /opt/rtfm/rtfm.py -u >> script.log 2>&1
    ln -s /opt/rtfm/rtfm.py /usr/local/bin/rtfm.py
}

install_docker(){
    printf "  ⏳  Installing docker\n" | tee -a script.log
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
    printf "  ⏳  Install cyberchef docker container\n" | tee -a script.log
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

pull_jsdetox(){
    printf "  ⏳  Install cyberchef docker container\n" | tee -a script.log
    docker pull remnux/jsdetox >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo "# Run docker jsdetox" >> script_todo.log  
    echo "# docker run --rm -p 3000:3000 remnux/jsdetox" >> script_todo.log  
    echo "# http://localhost:3000/" >> script_todo.log  
    echo "# docker ps" >> script_todo.log  
    echo "# docker stop <container id>" >> script_todo.log  
}

install_ghidra(){
    printf "  ⏳  Install Ghidra\n" | tee -a script.log
    cd /root/utils
    wget --quiet https://www.ghidra-sre.org/ghidra_9.1_PUBLIC_20191023.zip    
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    unzip -qq ghidra*
    ln -s /root/utils/ghidra_9.1*/ghidraRun /usr/local/bin/ghidraRun
    rm ghidra*.zip
}

install_peda() {
    printf "  ⏳  Install Python Exploit Development Assistance\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/longld/peda.git ~/peda
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    echo "source /root/utils/peda/peda.py" >> ~/.gdbinit
}

install_gef(){
    printf "  ⏳  Install GDB Enhanced Features - similar to peda\n" | tee -a script.log
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
    printf "  ⏳  Install binary ninja\n" | tee -a script.log
    cd /root/utils
    wget --quiet https://cdn.binary.ninja/installers/BinaryNinja-demo.zip
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    unzip -qq BinaryNinja-demo.zip
    rm BinaryNinja-demo.zip
    ln -s /root/utils/binaryninja/binaryninja /usr/local/bin/binaryninja
    cd ~
}

install_routersploit_framework(){
    printf "  ⏳  Install routersploit framework\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://www.github.com/threat9/routersploit
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    cd routersploit
    python3 -m pip install -q -r requirements.txt
    ln -s /root/utils/routersploit/rsf.py /usr/local/bin/rsf.py
    cd ~
}

install_stegcracker(){
    printf "  ⏳  Install Stegcracker\n" | tee -a script.log
    curl --silent https://raw.githubusercontent.com/Paradoxis/StegCracker/master/stegcracker > /usr/local/bin/stegcracker
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi    
    chmod +x /usr/local/bin/stegcracker
}

install_wine(){
    printf "  ⏳  Install wine & wine32\n" | tee -a script.log
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
    printf "  ⏳  Install dirseach\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/maurosoria/dirsearch.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    ln -s /root/utils/dirsearch/dirsearch.py /usr/local/bin/dirsearch.py
    cd /root
}

install_clicknroot(){
    printf "  ⏳  Install ClickNRoot\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/evait-security/ClickNRoot.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_reptile(){
    printf "  ⏳  Install Reptile\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/f0rb1dd3n/Reptile.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_ctfdscraper() {
    printf "  ⏳  Install CTFD Scraper\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/ichinano/CTFdScraper.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

install_chrome(){
    printf "  ⏳  Install Chrome\n" | tee -a script.log
    wget --quiet https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    dpkg -i ./google-chrome-stable_current_amd64.deb >> script.log
    apt --fix-broken install -y
    rm -f ./google-chrome-stable_current_amd64.deb
    # enable chrome start as root
    cp /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable.old && sed -i 's/^\(exec.*\)$/\1 --user-data-dir/' /usr/bin/google-chrome-stable
    sed -i -e 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --no-sandbox@g' /usr/share/applications/google-chrome.desktop 
    # chrome alias
    echo "alias chrome='google-chrome-stable --no-sandbox file:///root/dev/start_page/index.html'" >> /root/.bashrc
}

install_chromium(){
    printf "  ⏳  Install Chromium\n" | tee -a script.log
    apt_package_install chromium
    echo "# simply override settings above" >> /etc/chromium/default
    echo 'CHROMIUM_FLAGS="--password-store=detect --user-data-dir"' >> /etc/chromium/default
}

install_nmap_vulscan(){
    printf "  ⏳  Install NMAP vulscan\n" | tee -a script.log
    cd /usr/share/nmap/scripts/
    git clone --quiet https://github.com/scipag/vulscan.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

install_lazydocker(){
    printf "  ⏳  Install lazydocker\n" | tee -a script.log
    cd /root/utils
    curl --silent https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

bash_aliases() {
    printf "  ⏳  adding bash aliases\n" | tee -a script.log
    # git aliases
    echo "alias gs='git status'" >> /root/.bashrc
    echo "alias ga='git add -A'" >> /root/.bashrc
    # increase history size
    sed -i "s/HISTSIZE=1000/HISTSIZE=1000000/g" /root/.bashrc
}

john_bash_completion() {
    printf "  ⏳  enabling john bash completion\n" | tee -a script.log
    echo ". /usr/share/bash-completion/completions/john.bash_completion" >> /root/.bashrc
}

unzip_rockyou(){
    printf "  ⏳  Install gunzip rockyou\n" | tee -a script.log
    cd /usr/share/wordlists/
    gunzip -q /usr/share/wordlists/rockyou.txt.gz
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

enable_vbox_clipboard(){
    printf "  ⏳  enable vbox clipboard support\n" | tee -a script.log
    echo "# Enable VirtualBox Clipboard" >> /root/.bashrc
    echo "VBoxClient --clipboard" >> /root/.bashrc
}

install_gnome_theme(){
    printf "  ⏳  install gnome tweak packages & custom theme\n" | tee -a script.log
    apt_package_install gtk2-engines-murrine 
    apt_package_install gtk2-engines-pixbuf
    cd ~
    git clone --quiet https://github.com/vinceliuice/vimix-gtk-themes
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd vimix-gtk-themes
    ./Install -n vimix -c dark -t beryl >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

install_sourcepro_font(){
    printf "  ⏳  install sourcepro font\n" | tee -a script.log
    cd /root
    curl --silent --output google-mono-source.zip https://fonts.google.com/download?family=Source%20Code%20Pro >> script.log 2>>script_error.log
    7z x google-mono-source.zip >> script.log
    mv SourceCodePro-* /usr/share/fonts
    rm google-mono-source.zip
}

configure_gnome_settings(){
    # use "dconf watch /" then use gnome tweks to change settings and it will print below
    printf "  🔧  tweaking gnome settings\n" | tee -a script.log
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
    # automatically empty trash and temp files after 7 days; reduce recent file history
    dconf write /org/gnome/desktop/privacy/recent-files-max-age "'30'"
    dconf write /org/gnome/desktop/privacy/remove-old-trash-files "'true'"
    dconf write /org/gnome/desktop/privacy/remove-old-temp-files "'true'"
    dconf write /org/gnome/desktop/privacy/old-files-age "'uint32 7'"
    # configure favorites side bar
    dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'firefox-esr.desktop', 'kali-burpsuite.desktop', 'zenmap-root.desktop', 'kali-msfconsole.desktop', 'code.desktop']"
    # show trash icon
    # show application windows at bottom
    dconf write /org/gnome/shell/enabled-extensions "['apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'workspace-indicator@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'ProxySwitcher@flannaghan.com', 'EasyScreenCast@iacopodeenosee.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'desktop-icons@csoriano', 'window-list@gnome-shell-extensions.gcampax.github.com']"
    # fix application menu width
    sed -i "s/this.categoriesBox.box.width = 275;/this.mainBox.box.width = 900;\\n\\tthis.categoriesBox.box.width = 500;/g" /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com/extension.js
}

enable_auto_login_gnome(){
    printf "  🔧  enabling autologin\n" | tee -a script.log
    sed -i "s/^#.*AutomaticLoginEnable/AutomaticLoginEnable/g ; s/#.*AutomaticLogin/AutomaticLogin/g" /etc/gdm3/daemon.conf
}


enable_auto_login_lightdm(){
    printf "  🔧  enabling autologin\n" | tee -a script.log
    sed -i "s/^#.*autologin-guest=false/autologin-guest=false/g ; s/#.*autologin-user=user/autologin-user=root/g ; s/#.*autologin-user-timeout=0/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
    # prevent screen lock
    sed -i '$ a Hidden=true' /etc/xdg/autostart/light-locker.desktop
}

configure_xfce_settings(){
    # windows management
    xfconf-query -n -c xfwm4 -p /general/snap_to_border -t bool -s true
    xfconf-query -n -c xfwm4 -p /general/snap_to_windows -t bool -s true
    xfconf-query -n -c xfwm4 -p /general/wrap_windows -t bool -s false
    xfconf-query -n -c xfwm4 -p /general/wrap_workspaces -t bool -s false
    # pointer auto focus
    xfconf-query -n -c xfwm4 -p /general/click_to_focus -t bool -s false
}
configure_vmware_tools_share(){
    cat > /usr/local/sbin/mount-shared-folders <<-ENDOFVM
    #!/bin/sh
    vmware-hgfsclient | while read folder; do
        vmwpath="/mnt/hgfs/\${folder}"
        echo "[i] Mounting \${folder}   (\${vmwpath})"
        sudo mkdir -p "\${vmwpath}"
        sudo umount -f "\${vmwpath}" 2>/dev/null
        sudo vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "\${vmwpath}"
    done
    sleep 2s
    ENDOFVM
    sudo chmod +x /usr/local/sbin/mount-shared-folders
}

configure_vmware_tools_restart(){
    cat > /usr/local/sbin/restart-vm-tools <<-ENDOFVMWARE
    #!/bin/sh
    systemctl stop run-vmblock\\\\x2dfuse.mount
    sudo killall -q -w vmtoolsd
    systemctl start run-vmblock\\\\x2dfuse.mount
    systemctl enable run-vmblock\\\\x2dfuse.mount
    sudo vmware-user-suid-wrapper vmtoolsd -n vmusr 2>/dev/null
    sudo vmtoolsd -b /var/run/vmroot 2>/dev/null
    ENDOFVMWARE
    sudo chmod +x /usr/local/sbin/restart-vm-tools
}

configure_gdb(){
    printf "  🔧  configure gdb\n" | tee -a script.log
    cd /root
    cat > .gdbinit <<-ENDOFGDB
    # use intel assembly syntax
    set disassembly-flavor intel
    # follow child process if forked # change to 'parent' if you want to follow parent process after fork
    set follow-fork-mode child
    # attempt to disassemble next line
    set disassemble-next-line on
    # ensure history is on
    set history save on
    # function to print xxd like output, xxd 0xaddress 10,  good for strings
    define xxd
        dump binary memory /tmp/dump.bin $arg0 $arg0+$arg1
        eval "shell xxd -o %p /tmp/dump.bin", $arg0
    end
    # load peda
    source /root/utils/peda/peda.py
	ENDOFGDB
}

configure_vim(){
    printf "  🔧  configure vim\n" | tee -a script.log
    cd /root
    cat > .vimrc <<-ENDOFVIM
    set tabstop=8
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set background=dark " Enable dark background within editing are and syntax highlighting
    syntax on   " turn on code syntax highlighting
    set mouse=a
    set number  " show line numbers
    set ttyfast		" Make the keyboard fast
    set timeout timeoutlen=1000 ttimeoutlen=50
    set showmode		" always show what mode we're currently editing in
    set showcmd		" Show (partial) command in status line.
    set showmatch		" Show matching brackets.
    set ignorecase		" Do case insensitive matching
    set smartcase		" Do smart case matching
    set incsearch		" Show search matches while typing
    " set autowrite		" Automatically save before commands like :next and :make
    set hidden		" Hide buffers when they are abandoned
    " set nobackup            " do not keep a backup file, use versions instead
    set history=500         " keep 500 lines of command line history
    set ruler               " show the cursor position all the time
    set nowrap              " NO WRAPPING OF THE LINES!
    set hlsearch    	" highlight all matches after search
    set encoding=utf-8      " UTF8 Support
	ENDOFVIM
}

configure_gedit(){
    printf "  🔧  configure gedit\n" | tee -a script.log
    # show line numbers
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
    # set theme to match the rest of dark themes
    gsettings set org.gnome.gedit.preferences.editor scheme oblivion
}

configure_wireshark(){
    printf "  🔧  configure wireshark\n" | tee -a script.log
    cd /root
    mkdir -p /root/.config/wireshark
    cat > /root/.config/wireshark/preferences <<-ENDOFWIRESHARK
    # Default capture device
    # A string
    capture.device: eth0

    # Scroll packet list during capture?
    # TRUE or FALSE (case-insensitive)
    capture.auto_scroll: FALSE

    # Resolve addresses to names?
    # TRUE or FALSE (case-insensitive), or a list of address types to resolve.
    name_resolve: FALSE

    # Resolve Ethernet MAC address to manufacturer names
    # TRUE or FALSE (case-insensitive)
    nameres.mac_name: FALSE

    # Resolve TCP/UDP ports into service names
    # TRUE or FALSE (case-insensitive)
    nameres.transport_name: FALSE

    # Capture in Pcap-NG format?
    # TRUE or FALSE (case-insensitive)
    capture.pcap_ng: FALSE

    # Font name for packet list, protocol tree, and hex dump panes.
    # A string
    gui.qt.font_name: Monospace,10,-1,5,50,0,0,0,0,0

    # Resolve addresses to names?
    # TRUE or FALSE (case-insensitive), or a list of address types to resolve.
    name_resolve: FALSE

    # Display all hidden protocol items in the packet list.
    # TRUE or FALSE (case-insensitive)
    protocols.display_hidden_proto_items: TRUE
	ENDOFWIRESHARK
}

configure_git(){
    printf "  🔧  Configure git username, email, name\n" | tee -a script.log
    git config --global user.name "NOP Researcher"
    git config --global user.email nopresearcher@gmail.com
    git config --global credential.username "nopresearcher"
}

configure_metasploit(){
    printf "  🔧  configure metasploit\n" | tee -a script.log
    service postgresql start >> script.log
    msfdb init >> script.log
}

update_wpscan(){
    printf "  ⏳  update wpscan\n" | tee -a script.log
    wpscan --update >> script.log
}

pull_utilities(){
    printf "  ⏳  Pull nopresearcher utilities\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/nopresearcher/utilities.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    ln -s /root/utils/utilities/serveme /usr/local/bin/serveme
    ln -s /root/utils/utilities/ips /usr/local/bin/ips
    ln -s /root/utils/utilities/revshell-php /usr/local/bin/revshell-php
    ln -s /root/utils/utilities/public /usr/local/bin/public

}

configure_eth0(){
    printf " ⏳ adding eth0 dhcp\n" | tee -a script.log
    echo "auto eth0" >> /etc/network/interfaces
    echo "allow-hotplug eth0" >> /etc/network/interfaces
    echo "iface eth0 inet dhcp" >> /etc/network/interfaces
    service networking restart
}

pull_kali_setup(){
    printf "  ⏳  Pull kali setup script\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/nopresearcher/kali_setup.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

apt_cleanup(){
    printf "  ♻  cleaning up apt\n" | tee -a script.log
    DEBIAN_FRONTEND=noninteractive apt-get -f install >> script.log 2>>script_error.log
    apt-get -y autoremove >> script.log 2>>script_error.log
    apt-get -y autoclean >> script.log 2>>script_error.log
    apt-get -y clean >> script.log 2>>script_error.log
}

additional_clean(){
    printf "  ♻  additional cleaning\n" | tee -a script.log
    cd /root # go home
    updatedb # update slocated database
    history -cw 2>/dev/null # clean history
}

manual_stuff_to_do(){
    printf "  ⏳  Adding Manual work\n" | tee -a script.log
    echo "======Firefox addons=====" >> script_todo.log
    echo "FoxyProxy Standard" >> script_todo.log
    echo "" >> script_todo.log
    echo "======Password=====" >> script_todo.log
    echo "CHANGE YO PASSWORD" >> script_todo.log
    echo "passwd root" >> script_todo.log
}

compute_finish_time(){
    finish_time=$(date +%s)
    echo -e "  ⌛ Time (roughly) taken: ${YELLOW}$(( $(( finish_time - start_time )) / 60 )) minutes${RESET}"
    echo "\n\n Install completed - $finish_time \n" >> script.log
}

script_todo_print() {
    printf "  ⏳  Printing todo\n" | tee -a script.log
    cat script_todo.log
}

main () {
    compute_start_time
    configure_environment
    apt_update
    #apt_upgrade
    kali_metapackages
    install_kernel_headers
    install_python2_related
    install_python3_pip
    install_python3_related
    install_base_os_tools
    install_usb_gps
    install_rf_tools
    install_re_tools
    install_exploit_tools
    install_steg_programs
    install_web_tools
    install_mobile_tools
    install_screencast_tools
    folder_prep
    github_desktop
    install_vscode
    configure_vscode
    install_rtfm
    install_docker
    pull_cyberchef
    pull_jsdetox
    install_ghidra
    install_peda
    #install_gef
    install_binary_ninja
    install_routersploit_framework
    install_stegcracker
    install_wine
    install_dirsearch
    install_clicknroot
    install_reptile
    install_ctfdscraper
    #install_chrome
    #install_chromium
    install_nmap_vulscan
    install_lazydocker
    bash_aliases
    john_bash_completion
    unzip_rockyou
    #enable_vbox_clipboard
    #install_gnome_theme
    install_sourcepro_font
    #configure_gnome_settings
    #enable_auto_login_gnome
    enable_auto_login_lightdm
    configure_xfce_settings
    configure_vmware_tools_share
    configure_vmware_tools_restart
    configure_gdb
    configure_vim
    #configure_gedit
    configure_wireshark
    #configure_git
    configure_metasploit
    update_wpscan
    pull_utilities
    configure_eth0
    pull_kali_setup
    apt_cleanup
    additional_clean
    manual_stuff_to_do
    compute_finish_time
    script_todo_print
}

main    
