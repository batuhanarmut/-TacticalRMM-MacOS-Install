#!/bin/bash

# Tactical RMM Agent Kurulum Scripti - MacOS
# Armut ve Pronto Pro için

set -e  # Hata durumunda scripti durdur

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Başlık
clear
echo -e "${BLUE}=== Tactical RMM Agent Kurulum Scripti - MacOS ===${NC}"
echo

# Dil seçimi
echo "1) Türkçe"
echo "2) English"
echo
while true; do
    read -p "Dil seçin / Select language (1-2): " lang_choice
    case $lang_choice in
        1|2) break;;
        *) echo -e "${RED}Geçersiz seçim! / Invalid selection!${NC}";;
    esac
done

# Şirket seçimi
echo
if [ "$lang_choice" = "1" ]; then
    echo -e "${GREEN}Türkçe seçildi${NC}"
    echo
    echo -e "${YELLOW}Hangi şirket için agent kurmak istiyorsunuz?${NC}"
    echo "1) Armut"
    echo "2) Pronto Pro"
    echo
    while true; do
        read -p "Şirket seçin (1-2): " company_choice
        case $company_choice in
            1|2) break;;
            *) echo -e "${RED}Geçersiz seçim!${NC}";;
        esac
    done
else
    echo -e "${GREEN}English selected${NC}"
    echo
    echo -e "${YELLOW}Which company do you want to install the agent for?${NC}"
    echo "1) Armut"
    echo "2) Pronto Pro"
    echo
    while true; do
        read -p "Select company (1-2): " company_choice
        case $company_choice in
            1|2) break;;
            *) echo -e "${RED}Invalid selection!${NC}";;
        esac
    done
fi

# Şirket bilgilerini ayarla
if [ "$company_choice" = "1" ]; then
    CLIENT_ID=1
    SITE_ID=2
    AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
    COMPANY_NAME="Armut"
else
    CLIENT_ID=1
    SITE_ID=1
    AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
    COMPANY_NAME="Pronto Pro"
fi

# Onay mesajı
echo
if [ "$lang_choice" = "1" ]; then
    echo -e "${GREEN}$COMPANY_NAME seçildi. Agent kuruluyor...${NC}"
else
    echo -e "${GREEN}$COMPANY_NAME selected. Installing agent...${NC}"
fi

# MacOS mimarisi tespit et
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    AGENT_ARCH="arm64"
    AGENT_FILE="tacticalagent-v2.9.1-darwin-arm64"
else
    AGENT_ARCH="amd64"
    AGENT_FILE="tacticalagent-v2.9.1-darwin-amd64"
fi

echo
if [ "$lang_choice" = "1" ]; then
    echo -e "${BLUE}$COMPANY_NAME için Tactical RMM Agent kuruluyor...${NC}"
    echo -e "${BLUE}Mimari: $ARCH${NC}"
else
    echo -e "${BLUE}Installing Tactical RMM Agent for $COMPANY_NAME...${NC}"
    echo -e "${BLUE}Architecture: $ARCH${NC}"
fi
echo

# Agent dosyasını indir
if [ "$lang_choice" = "1" ]; then
    echo -e "${YELLOW}Agent dosyası indiriliyor...${NC}"
else
    echo -e "${YELLOW}Downloading agent file...${NC}"
fi

DOWNLOAD_URL="https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=$AGENT_ARCH&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io"

if curl -L -o "$AGENT_FILE" "$DOWNLOAD_URL"; then
    if [ "$lang_choice" = "1" ]; then
        echo -e "${GREEN}İndirme tamamlandı!${NC}"
    else
        echo -e "${GREEN}Download completed!${NC}"
    fi
else
    if [ "$lang_choice" = "1" ]; then
        echo -e "${RED}İndirme hatası!${NC}"
    else
        echo -e "${RED}Download error!${NC}"
    fi
    exit 1
fi

# Dosyayı çalıştırılabilir yap
if [ "$lang_choice" = "1" ]; then
    echo -e "${YELLOW}Dosya izinleri ayarlanıyor...${NC}"
else
    echo -e "${YELLOW}Setting file permissions...${NC}"
fi

chmod +x "$AGENT_FILE"

# Agent'ı kur
if [ "$lang_choice" = "1" ]; then
    echo -e "${YELLOW}Agent kuruluyor...${NC}"
    echo -e "${YELLOW}Sudo şifresi gerekebilir...${NC}"
else
    echo -e "${YELLOW}Installing agent...${NC}"
    echo -e "${YELLOW}Sudo password may be required...${NC}"
fi

if sudo ./"$AGENT_FILE" -m install --api https://api.trmm.homeruntech.io --client-id $CLIENT_ID --site-id $SITE_ID --agent-type workstation --auth $AUTH_TOKEN; then
    echo
    if [ "$lang_choice" = "1" ]; then
        echo -e "${GREEN}✅ $COMPANY_NAME için Tactical RMM Agent başarıyla kuruldu!${NC}"
        echo
        echo -e "${BLUE}Agent bilgileri:${NC}"
    else
        echo -e "${GREEN}✅ Tactical RMM Agent successfully installed for $COMPANY_NAME!${NC}"
        echo
        echo -e "${BLUE}Agent info:${NC}"
    fi
    echo -e "Şirket / Company: $COMPANY_NAME"
    echo -e "Client ID: $CLIENT_ID"
    echo -e "Site ID: $SITE_ID"
    echo -e "Mimari / Architecture: $ARCH"
else
    echo
    if [ "$lang_choice" = "1" ]; then
        echo -e "${RED}❌ Agent kurulumu başarısız!${NC}"
    else
        echo -e "${RED}❌ Agent installation failed!${NC}"
    fi
    exit 1
fi

# Temizlik
if [ "$lang_choice" = "1" ]; then
    echo -e "${YELLOW}Geçici dosyalar temizleniyor...${NC}"
else
    echo -e "${YELLOW}Cleaning temporary files...${NC}"
fi

rm -f "$AGENT_FILE"

echo
if [ "$lang_choice" = "1" ]; then
    echo -e "${GREEN}🎉 Kurulum tamamlandı!${NC}"
    echo -e "${BLUE}Agent başarıyla çalışıyor ve Tactical RMM sunucusuna bağlandı.${NC}"
else
    echo -e "${GREEN}🎉 Installation completed!${NC}"
    echo -e "${BLUE}Agent is successfully running and connected to Tactical RMM server.${NC}"
fi
