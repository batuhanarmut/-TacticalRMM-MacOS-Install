#!/bin/bash

# Tactical RMM Agent Kurulum Scripti
# macOS için Armut ve Pronto Pro seçenekleri

clear

# Dil seçimi
echo "=== Tactical RMM Agent Kurulum ==="
echo "=== Tactical RMM Agent Installation ==="
echo ""
echo "Dil seçiniz / Select Language:"
echo "1) Türkçe"
echo "2) English"
echo ""
read -p "Seçiminiz / Your choice (1-2): " LANG_CHOICE

if [ "$LANG_CHOICE" = "1" ]; then
    LANG="TR"
    COMPANY_PROMPT="Şirket seçiniz:"
    COMPANY_ARMUT="Armut"
    COMPANY_PRONTO="Pronto Pro"
    CHOICE_PROMPT="Seçiminiz"
    INVALID_CHOICE="Geçersiz seçim! Script sonlandırılıyor."
    DOWNLOADING="İndiriliyor..."
    INSTALLING="Kuruluyor..."
    SUCCESS="Kurulum başarıyla tamamlandı!"
    ERROR="Hata oluştu!"
    CONFIRM_PROMPT="Devam etmek istiyor musunuz? (y/n):"
else
    LANG="EN"
    COMPANY_PROMPT="Select Company:"
    COMPANY_ARMUT="Armut"
    COMPANY_PRONTO="Pronto Pro"
    CHOICE_PROMPT="Your choice"
    INVALID_CHOICE="Invalid choice! Exiting script."
    DOWNLOADING="Downloading..."
    INSTALLING="Installing..."
    SUCCESS="Installation completed successfully!"
    ERROR="An error occurred!"
    CONFIRM_PROMPT="Do you want to continue? (y/n):"
fi

clear
echo "================================="
echo "$COMPANY_PROMPT"
echo "1) $COMPANY_ARMUT"
echo "2) $COMPANY_PRONTO"
echo "================================="
echo ""
read -p "$CHOICE_PROMPT (1-2): " COMPANY_CHOICE

# Şirket seçimine göre parametreleri ayarla
case $COMPANY_CHOICE in
    1)
        # Armut parametreleri
        CLIENT_ID="1"
        SITE_ID="2"
        AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
        COMPANY_NAME="Armut"
        ;;
    2)
        # Pronto Pro parametreleri
        CLIENT_ID="1"
        SITE_ID="1"
        AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
        COMPANY_NAME="Pronto Pro"
        ;;
    *)
        echo "$INVALID_CHOICE"
        exit 1
        ;;
esac

# Onay al
clear
echo "================================="
if [ "$LANG" = "TR" ]; then
    echo "Seçilen Şirket: $COMPANY_NAME"
    echo "Tactical RMM Agent kurulumu başlatılacak."
else
    echo "Selected Company: $COMPANY_NAME"
    echo "Tactical RMM Agent installation will start."
fi
echo "================================="
echo ""
read -p "$CONFIRM_PROMPT " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    exit 0
fi

# macOS mimarisi kontrolü
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    AGENT_ARCH="arm64"
elif [ "$ARCH" = "x86_64" ]; then
    AGENT_ARCH="amd64"
else
    echo "$ERROR Desteklenmeyen mimari: $ARCH"
    exit 1
fi

# Agent dosya adı
AGENT_FILE="tacticalagent-v2.9.1-darwin-$AGENT_ARCH"

# Kurulum başlat
clear
echo "================================="
echo "$DOWNLOADING"
echo "Company: $COMPANY_NAME"
echo "Architecture: $AGENT_ARCH"
echo "================================="

# Agent'ı indir
curl -L -o "$AGENT_FILE" "https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=$AGENT_ARCH&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io"

if [ $? -eq 0 ]; then
    echo ""
    echo "$INSTALLING"
    
    # Çalıştırılabilir yap
    chmod +x "$AGENT_FILE"
    
    # Agent'ı kur
    sudo ./"$AGENT_FILE" -m install \
        --api https://api.trmm.homeruntech.io \
        --client-id "$CLIENT_ID" \
        --site-id "$SITE_ID" \
        --agent-type workstation \
        --auth "$AUTH_TOKEN"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "================================="
        echo "$SUCCESS"
        echo "Company: $COMPANY_NAME"
        echo "================================="
        
        # Temizlik
        rm -f "$AGENT_FILE"
    else
        echo ""
        echo "================================="
        echo "$ERROR"
        echo "================================="
        exit 1
    fi
else
    echo ""
    echo "================================="
    echo "$ERROR"
    echo "================================="
    exit 1
fi
