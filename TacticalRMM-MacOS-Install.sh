#!/bin/bash

# Tactical RMM Agent - macOS Only
# Armut & Pronto Pro Installer

clear
echo "╔══════════════════════════════════════╗"
echo "║    Tactical RMM Agent - macOS        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Company selection
echo "Şirket Seçin / Select Company:"
echo ""
echo "  1) Armut"
echo "  2) Pronto Pro"
echo ""

while true; do
    read -p "Seçiminiz (1 veya 2): " company
    case $company in
        1)
            echo "✓ Armut seçildi"
            CLIENT_ID=1
            SITE_ID=2
            AUTH="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
            COMPANY_NAME="Armut"
            break
            ;;
        2)
            echo "✓ Pronto Pro seçildi"
            CLIENT_ID=1
            SITE_ID=1
            AUTH="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
            COMPANY_NAME="Pronto Pro"
            break
            ;;
        *)
            echo "❌ Geçersiz seçim! 1 veya 2 girin."
            ;;
    esac
done

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Bu script sadece macOS için tasarlanmıştır!"
    exit 1
fi

# Detect Mac architecture
MAC_ARCH=$(uname -m)
if [[ "$MAC_ARCH" == "arm64" ]]; then
    AGENT_ARCH="arm64"
    echo "🖥️  Apple Silicon (M1/M2/M3) tespit edildi"
else
    AGENT_ARCH="amd64"
    echo "🖥️  Intel Mac tespit edildi"
fi

echo ""
echo "📦 $COMPANY_NAME için agent indiriliyor..."

# Download agent
AGENT_FILE="tactical-agent-macos-$AGENT_ARCH"
DOWNLOAD_URL="https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=$AGENT_ARCH&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io"

if curl -L -s -o "$AGENT_FILE" "$DOWNLOAD_URL"; then
    echo "✅ İndirme tamamlandı"
else
    echo "❌ İndirme başarısız!"
    exit 1
fi

# Make executable
chmod +x "$AGENT_FILE"

echo ""
echo "🔧 $COMPANY_NAME için agent kuruluyor..."
echo "🔑 Admin şifresi gerekebilir..."

# Install agent
if sudo ./"$AGENT_FILE" -m install \
    --api https://api.trmm.homeruntech.io \
    --client-id $CLIENT_ID \
    --site-id $SITE_ID \
    --agent-type workstation \
    --auth $AUTH; then
    
    echo ""
    echo "🎉 BAŞARILI!"
    echo ""
    echo "Agent Bilgileri:"
    echo "├─ Şirket: $COMPANY_NAME"
    echo "├─ Client ID: $CLIENT_ID"
    echo "├─ Site ID: $SITE_ID"
    echo "└─ Mimari: $MAC_ARCH"
    echo ""
    echo "✅ Agent başarıyla kuruldu ve çalışıyor!"
    
else
    echo ""
    echo "❌ Kurulum başarısız!"
    echo "Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin."
    exit 1
fi

# Cleanup
rm -f "$AGENT_FILE"
echo ""
echo "🧹 Geçici dosyalar temizlendi"
echo "🏁 Kurulum tamamlandı!"
