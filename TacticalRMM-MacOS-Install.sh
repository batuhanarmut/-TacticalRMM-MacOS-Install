#!/bin/bash

echo "🚀 Tactical RMM macOS Installer"
echo "Repository: https://github.com/batuhanarmut/-TacticalRMM-MacOS-Install"
echo ""

# macOS kontrolü
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Bu script sadece macOS üzerinde çalışır!"
    exit 1
fi

# Dil seçimi
echo "🌍 Dil seçimi..."
LANGUAGE=$(osascript -e '
tell application "System Events"
    activate
    set langChoice to choose from list {"🇹🇷 Türkçe", "🇺🇸 English"} with title "Language Selection / Dil Seçimi" with prompt "Please select your language / Lütfen dilinizi seçin:" default items {"🇹🇷 Türkçe"}
    return langChoice as string
end tell
')

# İptal kontrolü
if [ "$LANGUAGE" = "false" ]; then
    echo "❌ Kurulum iptal edildi."
    exit 0
fi

echo "✅ Seçilen dil: $LANGUAGE"

# Dil ayarları
if [[ "$LANGUAGE" == *"English"* ]]; then
    ORG_PROMPT="🏢 Which organization are you installing for?"
    ORG_ARMUT="🍊 Armut Employee"
    ORG_PRONTO="🚀 Pronto Pro Employee"
    TITLE_INSTALLER="Tactical RMM Installer"
    MSG_DOWNLOADING="Downloading Tactical RMM Agent..."
    MSG_DOWNLOAD_ERROR="❌ Download failed! Check your internet connection."
    MSG_ARMUT_SUCCESS="🎉 Tactical RMM Agent successfully installed for Armut!"
    MSG_PRONTO_SUCCESS="🎉 Tactical RMM Agent successfully installed for Pronto Pro!"
    TITLE_SUCCESS="✅ Installation Completed"
    BTN_OK="OK"
else
    ORG_PROMPT="🏢 Hangi organizasyon için kurulum yapıyorsunuz?"
    ORG_ARMUT="🍊 Armut Çalışanı"
    ORG_PRONTO="🚀 Pronto Pro Çalışanı"
    TITLE_INSTALLER="Tactical RMM Installer"
    MSG_DOWNLOADING="Tactical RMM Agent indiriliyor..."
    MSG_DOWNLOAD_ERROR="❌ İndirme başarısız! İnternet bağlantınızı kontrol edin."
    MSG_ARMUT_SUCCESS="🎉 Armut için Tactical RMM Agent başarıyla kuruldu!"
    MSG_PRONTO_SUCCESS="🎉 Pronto Pro için Tactical RMM Agent başarıyla kuruldu!"
    TITLE_SUCCESS="✅ Kurulum Tamamlandı"
    BTN_OK="Tamam"
fi

# Organizasyon seçimi
echo "🏢 Organizasyon seçimi..."
CHOICE=$(osascript -e "
tell application \"System Events\"
    activate
    set theChoice to choose from list {\"$ORG_ARMUT\", \"$ORG_PRONTO\"} with title \"$TITLE_INSTALLER\" with prompt \"$ORG_PROMPT\" default items {\"$ORG_ARMUT\"}
    return theChoice as string
end tell
")

# İptal kontrolü
if [ "$CHOICE" = "false" ]; then
    echo "❌ Kurulum iptal edildi."
    exit 0
fi

echo "✅ Seçilen organizasyon: $CHOICE"

# Progress notification
osascript -e "display notification \"$MSG_DOWNLOADING\" with title \"$TITLE_INSTALLER\""

# Geçici dizin
TEMP_DIR="/tmp/tactical_rmm_$(date +%s)"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "📥 Tactical RMM Agent indiriliyor..."

# Agent indir
if curl -L -o tacticalagent 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'; then
    echo "✅ İndirme tamamlandı"
    chmod +x tacticalagent
else
    echo "❌ İndirme başarısız!"
    osascript -e "display dialog \"$MSG_DOWNLOAD_ERROR\" buttons {\"$BTN_OK\"}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Kurulum parametreleri
if [[ "$CHOICE" == *"Armut"* ]]; then
    AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
    SITE_ID="2"
    SUCCESS_MSG="$MSG_ARMUT_SUCCESS"
    echo "🍊 Armut için kurulum başlıyor..."
else
    AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
    SITE_ID="1"
    SUCCESS_MSG="$MSG_PRONTO_SUCCESS"
    echo "🚀 Pronto Pro için kurulum başlıyor..."
fi

# Kurulum komutu
INSTALL_CMD="$TEMP_DIR/tacticalagent -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id $SITE_ID --agent-type workstation --auth $AUTH_TOKEN"

echo "⚙️ Agent kuruluyor... (Admin şifresi istenecek)"

# Kurulum yap
if osascript -e "do shell script \"$INSTALL_CMD\" with administrator privileges" 2>/dev/null; then
    echo "🎉 Kurulum başarılı!"
    osascript -e "display dialog \"$SUCCESS_MSG\" with title \"$TITLE_SUCCESS\" buttons {\"$BTN_OK\"}"
else
    echo "❌ Kurulum başarısız!"
    osascript -e "display dialog \"❌ Kurulum sırasında hata oluştu!\" buttons {\"$BTN_OK\"}"
fi

# Temizlik
echo "🧹 Geçici dosyalar temizleniyor..."
rm -rf "$TEMP_DIR"

echo "✅ İşlem tamamlandı!"
exit 0
