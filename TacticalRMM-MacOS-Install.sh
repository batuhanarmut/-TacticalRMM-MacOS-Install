#!/bin/bash
# filepath: tactical_rmm_installer.sh

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logo ve başlık
print_header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           TACTICAL RMM INSTALLER            ║"
    echo "║              macOS Kurulum Aracı            ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Dil seçimi
select_language() {
    echo -e "${YELLOW}Dil Seçimi / Language Selection:${NC}"
    echo "1) Türkçe"
    echo "2) English"
    echo ""
    read -p "Seçiminizi yapın (1-2): " lang_choice
    
    case $lang_choice in
        1) LANGUAGE="tr" ;;
        2) LANGUAGE="en" ;;
        *) 
            echo -e "${RED}Geçersiz seçim! Türkçe olarak devam ediliyor...${NC}"
            LANGUAGE="tr"
            ;;
    esac
}


show_menu_tr() {
    echo -e "${GREEN}Hangi organizasyon için kurulum yapıyorsunuz?${NC}"
    echo ""
    echo "1) 🏢 Armut Çalışanı"
    echo "2) 🚀 Pronto Pro Çalışanı"
    echo "3) ❌ Çıkış"
    echo ""
    read -p "Seçiminizi yapın (1-3): " choice
}


show_menu_en() {
    echo -e "${GREEN}Which organization are you installing for?${NC}"
    echo ""
    echo "1) 🏢 Armut Employee"
    echo "2) 🚀 Pronto Pro Employee"
    echo "3) ❌ Exit"
    echo ""
    read -p "Make your choice (1-3): " choice
}

# Armut kurulumu
install_armut() {
    if [ "$LANGUAGE" = "tr" ]; then
        echo -e "${BLUE}Armut için Tactical RMM Agent kuruluyor...${NC}"
    else
        echo -e "${BLUE}Installing Tactical RMM Agent for Armut...${NC}"
    fi
    
    echo -e "${YELLOW}Agent indiriliyor...${NC}"
    curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'
    
    if [ $? -eq 0 ]; then
        echo -e "${YELLOW}Dosya izinleri ayarlanıyor...${NC}"
        chmod +x tacticalagent-v2.9.1-darwin-arm64
        
        echo -e "${YELLOW}Agent kuruluyor (sudo gerekli)...${NC}"
        sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 2 --agent-type workstation --auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Armut Tactical RMM Agent başarıyla kuruldu!${NC}"
        else
            echo -e "${RED}❌ Kurulum sırasında hata oluştu!${NC}"
        fi
    else
        echo -e "${RED}❌ Agent indirilemedi!${NC}"
    fi
}

# Pronto Pro kurulumu
install_pronto() {
    if [ "$LANGUAGE" = "tr" ]; then
        echo -e "${BLUE}Pronto Pro için Tactical RMM Agent kuruluyor...${NC}"
    else
        echo -e "${BLUE}Installing Tactical RMM Agent for Pronto Pro...${NC}"
    fi
    
    echo -e "${YELLOW}Agent indiriliyor...${NC}"
    curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'
    
    if [ $? -eq 0 ]; then
        echo -e "${YELLOW}Dosya izinleri ayarlanıyor...${NC}"
        chmod +x tacticalagent-v2.9.1-darwin-arm64
        
        echo -e "${YELLOW}Agent kuruluyor (sudo gerekli)...${NC}"
        sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 1 --agent-type workstation --auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Pronto Pro Tactical RMM Agent başarıyla kuruldu!${NC}"
        else
            echo -e "${RED}❌ Kurulum sırasında hata oluştu!${NC}"
        fi
    else
        echo -e "${RED}❌ Agent indirilemedi!${NC}"
    fi
}

# Ana program
main() {
    print_header
    select_language
    
    while true; do
        print_header
        
        if [ "$LANGUAGE" = "tr" ]; then
            show_menu_tr
        else
            show_menu_en
        fi
        
        case $choice in
            1)
                install_armut
                echo ""
                read -p "Devam etmek için Enter'a basın..."
                ;;
            2)
                install_pronto
                echo ""
                read -p "Devam etmek için Enter'a basın..."
                ;;
            3)
                if [ "$LANGUAGE" = "tr" ]; then
                    echo -e "${GREEN}Güle güle!${NC}"
                else
                    echo -e "${GREEN}Goodbye!${NC}"
                fi
                exit 0
                ;;
            *)
                if [ "$LANGUAGE" = "tr" ]; then
                    echo -e "${RED}Geçersiz seçim! Lütfen 1-3 arası bir sayı girin.${NC}"
                else
                    echo -e "${RED}Invalid choice! Please enter a number between 1-3.${NC}"
                fi
                sleep 2
                ;;
        esac
    done
}

main
