#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==> Linux dağıtımı algılanıyor...${NC}"

# 1. Dağıtım tespiti ve Fastfetch kurulumu
if [ -f /etc/debian_version ]; then
    DISTRO="ubuntu"
    echo -e "${YELLOW}[!] Ubuntu/Debian tabanlı sistem algılandı.${NC}"
    sudo apt update && sudo apt install fastfetch -y
elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
    echo -e "${YELLOW}[!] Arch Linux tabanlı sistem algılandı.${NC}"
    sudo pacman -S fastfetch --noconfirm
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
    echo -e "${YELLOW}[!] Fedora tabanlı sistem algılandı.${NC}"
    sudo dnf install fastfetch -y
elif [ -f /etc/os-release ] && grep -q "suse" /etc/os-release; then
    DISTRO="opensuse"
    echo -e "${YELLOW}[!] openSUSE tabanlı sistem algılandı.${NC}"
    sudo zypper install fastfetch -y
else
    DISTRO="auto"
    echo -e "${RED}[X] Dağıtım otomatik tanınamadı, varsayılan logo kullanılacak.${NC}"
fi

# 2. Klasör yapısı ve yedekleme
mkdir -p ~/.config/fastfetch
if [ -f ~/.config/fastfetch/config.jsonc ]; then
    mv ~/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc.bak
fi

# 3. Config indirme (Kendi kullanıcı adın ve depo adınla değiştir)
echo -e "${BLUE}==> Sxinar Fastfetch tasarımı indiriliyor...${NC}"
curl -sS https://raw.githubusercontent.com/Sxinar/fastfetch-config/main/config.jsonc -o ~/.config/fastfetch/config.jsonc

# 4. SİHİRLİ DOKUNUŞ: Logoyu dağıtıma göre küçük logoya zorla
if [ "$DISTRO" != "auto" ]; then
    # config.jsonc içindeki "type": "auto" kısmını "type": "${DISTRO}_small" yapar
    # Örn: fedora_small, arch_small veya ubuntu_small olur. Tasarım asla kaymaz!
    sed -i "s/\"type\": \"auto\"/\"type\": \"${DISTRO}_small\"/g" ~/.config/fastfetch/config.jsonc
fi

echo -e "${GREEN}[✓] Kurulum başarıyla tamamlandı! 'fastfetch' yazarak test edebilirsiniz.${NC}"
