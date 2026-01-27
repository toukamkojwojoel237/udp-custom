#!/bin/bash

# Run as root
[[ "$(whoami)" != "root" ]] && {
    echo -e "\033[1;33m[\033[1;31mError\033[1;33m] \033[1;37m- \033[1;33myou need to run as root\033[0m"
    rm /home/ubuntu/install.sh &>/dev/null
    exit 0
}

#=== setup ===
cd 
rm -rf /root/udp
mkdir -p /root/udp
rm -rf /etc/UDPCustom
mkdir -p /etc/UDPCustom
sudo touch /etc/UDPCustom/udp-custom
udp_dir='/etc/UDPCustom'
udp_file='/etc/UDPCustom/udp-custom'

# Installation des dépendances (Ajout de python3 et pip pour le Bot)
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget curl dos2unix neofetch python3 python3-pip at

# === LIEN VERS TON REPOSIT (JOEL DATA) ===
REPO="https://raw.githubusercontent.com/toukamkojwojoel237/udp-custom/main"

# Chargement du module depuis ton repo
source <(curl -sSL "$REPO/module/module")

# Check Ubuntu version
if [ "$(lsb_release -rs)" = "8*|9*|10*|11*|16.04*|18.04*" ]; then
  clear
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  print_center -ama -e "\e[1m\e[33mOS Incompatible\e[0m"
  print_center -ama -e "\e[1m\e[33mUse Ubuntu 20 or higher\e[0m"
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  rm /home/ubuntu/install.sh
  exit 1
else
  clear
  echo ""
  print_center -ama "A Compatible OS/Environment Found"
  print_center -ama " ⇢ Installation begins...! <"
  sleep 3

  # [change timezone to UTC +0]
  echo ""
  echo " ⇢ JOEL DATA OFFICIAL SCRIPT"
  echo " ⇢ UDP Custom Pro"
  sleep 3

  # [+clean up+]
  rm -rf $udp_file &>/dev/null
  rm -rf /etc/UDPCustom/module &>/dev/null
  rm -rf /usr/bin/udp &>/dev/null
  systemctl stop udp-custom &>/dev/null

  # [+get files FROM YOUR REPO ⇣⇣⇣+]
  source <(curl -sSL "$REPO/module/module") &>/dev/null
  wget -O /etc/UDPCustom/module "$REPO/module/module" &>/dev/null
  chmod +x /etc/UDPCustom/module

  # Téléchargement du binaire UDP
  wget "$REPO/bin/udp-custom-linux-amd64" -O /root/udp/udp-custom &>/dev/null
  chmod +x /root/udp/udp-custom

  # Limiter & Gateway
  wget -O /etc/limiter.sh "$REPO/module/limiter.sh"
  cp /etc/limiter.sh /etc/UDPCustom
  chmod +x /etc/limiter.sh
  chmod +x /etc/UDPCustom
  
  wget -O /etc/udpgw "$REPO/module/udpgw"
  mv /etc/udpgw /bin
  chmod +x /bin/udpgw

  # [+services+]
  wget -O /etc/udpgw.service "$REPO/config/udpgw.service"
  wget -O /etc/udp-custom.service "$REPO/config/udp-custom.service"
  
  mv /etc/udpgw.service /etc/systemd/system
  mv /etc/udp-custom.service /etc/systemd/system

  chmod 640 /etc/systemd/system/udpgw.service
  chmod 640 /etc/systemd/system/udp-custom.service
  
  systemctl daemon-reload &>/dev/null
  systemctl enable udpgw &>/dev/null
  systemctl start udpgw &>/dev/null
  systemctl enable udp-custom &>/dev/null
  systemctl start udp-custom &>/dev/null

  # [+config+]
  wget "$REPO/config/config.json" -O /root/udp/config.json &>/dev/null
  chmod +x /root/udp/config.json

  # [+menu (TON FICHIER MODIFIÉ)]
  wget -O /usr/bin/udp "$REPO/module/udp" 
  chmod +x /usr/bin/udp
  
  ufw disable &>/dev/null
  sudo apt-get remove --purge ufw firewalld -y
  apt remove netfilter-persistent -y
  clear
  echo ""
  echo ""
  print_center -ama "${a103:-setting up, please wait...}"
  sleep 6
  title "${a102:-Installation Successful}"
  print_center -ama "${a103:-  To show menu type: \nudp\n}"
  echo -ne "\n\033[1;31mENTER \033[1;33mpour entrer au \033[1;32mMENU!\033[0m"; read
  udp
  
fi
