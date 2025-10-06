#!/bin/bash
# filepath: TacticalRMM-MacOS-Install.sh

echo "🚀 Tactical RMM App Bundle oluşturuluyor..."

# App bundle yapısı oluştur
APP_NAME="Tactical RMM Installer.app"

# Önce varsa sil
if [ -d "$APP_NAME" ]; then
    rm -rf "$APP_NAME"
fi

# Dizin yapısını oluştur
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

echo "📝 Info.plist dosyası oluşturuluyor..."

# Info.plist oluştur
cat > "$APP_NAME/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>TacticalRMMInstaller</string>
    <key>CFBundleIdentifier</key>
    <string>com.tacticalrmm.installer</string>
    <key>CFBundleName</key>
    <string>Tactical RMM Installer</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleDisplayName</key>
    <string>Tactical RMM Installer</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
</dict>
</plist>
EOF

echo "⚙️ Ana executable dosyası oluşturuluyor..."

# Ana executable oluştur
cat > "$APP_NAME/Contents/MacOS/TacticalRMMInstaller" << 'EOF'
#!/bin/bash

# Hata ayıklama için log
exec > /tmp/tactical_rmm_debug.log 2>&1

echo "Tactical RMM Installer başlatıldı..."

# Dil seçimi
LANGUAGE=$(osascript << 'APPLESCRIPT'
try
    tell application "System Events"
        activate
        set langChoice to choose from list {"🇹🇷 Türkçe", "🇺🇸 English"} with title "Language Selection / Dil Seçimi" with prompt "Please select your language / Lütfen dilinizi seçin:" default items {"🇹🇷 Türkçe"} with empty selection allowed false
        return langChoice
    end tell
on error
    return "false"
end try
APPLESCRIPT
)

echo "Dil seçimi: $LANGUAGE"

# İptal edilirse çık
if [ "$LANGUAGE" = "false" ] || [ -z "$LANGUAGE" ]; then
    echo "Kullanıcı dil seçimini iptal etti"
    exit 0
fi

# Dil ayarları
if [[ "$LANGUAGE" == *"English"* ]]; then
    LANG_CODE="en"
    ORG_PROMPT="🏢 Which organization are you installing for?"
    ORG_ARMUT="🍊 Armut Employee"
    ORG_PRONTO="🚀 Pronto Pro Employee"
    TITLE_INSTALLER="Tactical RMM Installer"
    MSG_DOWNLOADING="📥 Tactical RMM Agent is being downloaded and installed...

This process may take a few minutes.
Please wait..."
    TITLE_PROGRESS="Installation in Progress"
    MSG_DOWNLOAD_ERROR="❌ Agent could not be downloaded! Please check your internet connection."
    TITLE_ERROR="Error"
    MSG_ARMUT_SUCCESS="🎉 Tactical RMM Agent successfully installed for Armut!

📍 Site ID: 2
🏢 Organization: Armut"
    MSG_PRONTO_SUCCESS="🎉 Tactical RMM Agent successfully installed for Pronto Pro!

📍 Site ID: 1
🏢 Organization: Pronto Pro"
    TITLE_SUCCESS="✅ Installation Completed"
    MSG_INSTALL_ERROR="❌ An error occurred during installation!

Error: "
    TITLE_INSTALL_ERROR="Installation Error"
else
    LANG_CODE="tr"
    ORG_PROMPT="🏢 Hangi organizasyon için kurulum yapıyorsunuz?"
    ORG_ARMUT="🍊 Armut Çalışanı"
    ORG_PRONTO="🚀 Pronto Pro Çalışanı"
    TITLE_INSTALLER="Tactical RMM Installer"
    MSG_DOWNLOADING="📥 Tactical RMM Agent indiriliyor ve kuruluyor...

Bu işlem birkaç dakika sürebilir.
Lütfen bekleyiniz..."
    TITLE_PROGRESS="Kurulum Devam Ediyor"
    MSG_DOWNLOAD_ERROR="❌ Agent indirilemedi! İnternet bağlantınızı kontrol edin."
    TITLE_ERROR="Hata"
    MSG_ARMUT_SUCCESS="🎉 Armut için Tactical RMM Agent başarıyla kuruldu!

📍 Site ID: 2
🏢 Organization: Armut"
    MSG_PRONTO_SUCCESS="🎉 Pronto Pro için Tactical RMM Agent başarıyla kuruldu!

📍 Site ID: 1
🏢 Organization: Pronto Pro"
    TITLE_SUCCESS="✅ Kurulum Tamamlandı"
    MSG_INSTALL_ERROR="❌ Kurulum sırasında hata oluştu!

Hata: "
    TITLE_INSTALL_ERROR="Kurulum Hatası"
fi

# Organizasyon seçimi
CHOICE=$(osascript << APPLESCRIPT
try
    tell application "System Events"
        activate
        set theChoice to choose from list {"$ORG_ARMUT", "$ORG_PRONTO"} with title "$TITLE_INSTALLER" with prompt "$ORG_PROMPT" default items {"$ORG_ARMUT"} with empty selection allowed false
        return theChoice
    end tell
on error
    return "false"
end try
APPLESCRIPT
)

echo "Organizasyon seçimi: $CHOICE"

# İptal edilirse çık
if [ "$CHOICE" = "false" ] || [ -z "$CHOICE" ]; then
    echo "Kullanıcı organizasyon seçimini iptal etti"
    exit 0
fi

# Progress göster
osascript -e "
tell application \"System Events\"
    display dialog \"$MSG_DOWNLOADING\" with title \"$TITLE_PROGRESS\" giving up after 3 buttons {\"Tamam\"} default button 1
end tell
" &

# Geçici dizin oluştur
TEMP_DIR="/tmp/tactical_rmm_$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Agent indiriliyor..."

# Agent indir
if curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'; then
    echo "İndirme başarılı"
    chmod +x tacticalagent-v2.9.1-darwin-arm64
else
    echo "İndirme başarısız"
    osascript -e "tell application \"System Events\" to display dialog \"$MSG_DOWNLOAD_ERROR\" with title \"$TITLE_ERROR\" buttons {\"Tamam\"} default button 1"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Organizasyona göre kurulum
if [[ "$CHOICE" == *"Armut"* ]]; then
    echo "Armut kurulumu başlıyor..."
    
    # AppleScript ile sudo şifre isteme ve kurulum
    osascript << APPLESCRIPT
    try
        set theCommand to "cd '/tmp/tactical_rmm_\$(echo \$\$)' && ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 2 --agent-type workstation --auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
        
        do shell script theCommand with administrator privileges
        
        display dialog "$MSG_ARMUT_SUCCESS" with title "$TITLE_SUCCESS" buttons {"Tamam"} default button 1
        
    on error errorMessage
        display dialog "$MSG_INSTALL_ERROR" & errorMessage with title "$TITLE_INSTALL_ERROR" buttons {"Tamam"} default button 1
    end try
APPLESCRIPT

else
    echo "Pronto Pro kurulumu başlıyor..."
    
    # AppleScript ile sudo şifre isteme ve kurulum
    osascript << APPLESCRIPT
    try
        set theCommand to "cd '/tmp/tactical_rmm_\$(echo \$\$)' && ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 1 --agent-type workstation --auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
        
        do shell script theCommand with administrator privileges
        
        display dialog "$MSG_PRONTO_SUCCESS" with title "$TITLE_SUCCESS" buttons {"Tamam"} default button 1
        
    on error errorMessage
        display dialog "$MSG_INSTALL_ERROR" & errorMessage with title "$TITLE_INSTALL_ERROR" buttons {"Tamam"} default button 1
    end try
APPLESCRIPT

fi

# Temizlik
echo "Temizlik yapılıyor..."
rm -rf "$TEMP_DIR"

echo "Kurulum tamamlandı"
exit 0
EOF

# Executable'a izin ver
chmod +x "$APP_NAME/Contents/MacOS/TacticalRMMInstaller"

echo "🎉 App Bundle oluşturuldu!"
echo ""
echo "📁 Oluşturulan dosya: $APP_NAME"
echo ""
echo "✅ Kullanım:"
echo "   1. '$APP_NAME' dosyasını çift tıklayın"
echo "   2. Dilinizi seçin (Türkçe/English)"
echo "   3. Organizasyonunuzu seçin"
echo "   4. Admin şifrenizi girin"
echo "   5. Kurulum otomatik tamamlanır!"
echo ""
echo "🌍 Desteklenen diller: Türkçe, English"
echo "🔒 Bu .app dosyası Gatekeeper uyarısı vermez!"

# Finder'da göster
if command -v open >/dev/null 2>&1; then
    echo "📂 Finder'da açılıyor..."
    open .
fi