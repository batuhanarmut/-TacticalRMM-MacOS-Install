#!/bin/bash

# Tactical RMM Agent Kurulum Scripti
# Armut ve Pronto Pro için

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Dil seçimi
echo -e "${BLUE}=== Tactical RMM Agent Kurulum Scripti ===${NC}"
echo ""
echo "1) Türkçe"
echo "2) English"
echo ""
read -p "Dil seçin / Select language (1-2): " lang_choice

case $lang_choice in
    1)
        echo -e "${GREEN}Türkçe seçildi${NC}"
        echo ""
        echo -e "${YELLOW}Hangi şirket için agent kurmak istiyorsunuz?${NC}"
        echo "1) Armut"
        echo "2) Pronto Pro"
        echo ""
        read -p "Şirket seçin (1-2): " company_choice
        
        case $company_choice in
            1)
                echo -e "${GREEN}Armut seçildi. Agent kuruluyor...${NC}"
                CLIENT_ID=1
                SITE_ID=2
                AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
                COMPANY_NAME="Armut"
                ;;
            2)
                echo -e "${GREEN}Pronto Pro seçildi. Agent kuruluyor...${NC}"
                CLIENT_ID=1
                SITE_ID=1
                AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
                COMPANY_NAME="Pronto Pro"
                ;;
            *)
                echo -e "${RED}Geçersiz seçim!${NC}"
                exit 1
                ;;
        esac
        ;;
    2)
        echo -e "${GREEN}English selected${NC}"
        echo ""
        echo -e "${YELLOW}Which company do you want to install the agent for?${NC}"
        echo "1) Armut"
        echo "2) Pronto Pro"
        echo ""
        read -p "Select company (1-2): " company_choice
        
        case $company_choice in
            1)
                echo -e "${GREEN}Armut selected. Installing agent...${NC}"
                CLIENT_ID=1
                SITE_ID=2
                AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
                COMPANY_NAME="Armut"
                ;;
            2)
                echo -e "${GREEN}Pronto Pro selected. Installing agent...${NC}"
                CLIENT_ID=1
                SITE_ID=1
                AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
                COMPANY_NAME="Pronto Pro"
                ;;
            *)
                echo -e "${RED}Invalid selection!${NC}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo -e "${RED}Geçersiz seçim! / Invalid selection!${NC}"
        exit 1
        ;;
esac

# Agent kurulumu
echo ""
echo -e "${BLUE}$COMPANY_NAME için Tactical RMM Agent kuruluyor...${NC}"
echo -e "${BLUE}Installing Tactical RMM Agent for $COMPANY_NAME...${NC}"
echo ""

# Agent dosyasını indir
echo -e "${YELLOW}Agent dosyası indiriliyor... / Downloading agent file...${NC}"
curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'

if [ $? -eq 0 ]; then
    echo -e "${GREEN}İndirme tamamlandı! / Download completed!${NC}"
else
    echo -e "${RED}İndirme hatası! / Download error!${NC}"
    exit 1
fi

# Dosyayı çalıştırılabilir yap
echo -e "${YELLOW}Dosya izinleri ayarlanıyor... / Setting file permissions...${NC}"
chmod +x tacticalagent-v2.9.1-darwin-arm64

# Agent'ı kur
echo -e "${YELLOW}Agent kuruluyor... / Installing agent...${NC}"
sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id $CLIENT_ID --site-id $SITE_ID --agent-type workstation --auth $AUTH_TOKEN

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ $COMPANY_NAME için Tactical RMM Agent başarıyla kuruldu!${NC}"
    echo -e "${GREEN}✅ Tactical RMM Agent successfully installed for $COMPANY_NAME!${NC}"
    echo ""
    echo -e "${BLUE}Agent bilgileri / Agent info:${NC}"
    echo -e "Şirket / Company: $COMPANY_NAME"
    echo -e "Client ID: $CLIENT_ID"
    echo -e "Site ID: $SITE_ID"
else
    echo ""
    echo -e "${RED}❌ Agent kurulumu başarısız! / Agent installation failed!${NC}"
    exit 1
fi

# Temizlik
echo -e "${YELLOW}Geçici dosyalar temizleniyor... / Cleaning temporary files...${NC}"
rm -f tacticalagent-v2.9.1-darwin-arm64

echo ""
echo -e "${GREEN}Kurulum tamamlandı! / Installation completed!${NC}"
