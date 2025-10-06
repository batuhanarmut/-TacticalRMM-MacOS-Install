#!/bin/bash

echo "=============================================="
echo "   Tactical RMM Agent Kurulum / Installation   "
echo "=============================================="

# Şirket seçimi
echo "Lütfen şirketinizi seçin / Please select your company:"
echo "1 - Armut"
echo "2 - Pronto Pro"
read -p "Seçiminizi girin / Enter your choice (1/2): " company

# Dil seçimi
echo "Lütfen dili seçin / Please select language:"
echo "1 - Türkçe"
echo "2 - English"
read -p "Seçiminizi girin / Enter your choice (1/2): " lang

echo "----------------------------------------------"

if [ "$company" = "1" ]; then
    if [ "$lang" = "1" ]; then
        echo "Armut çalışanı için kurulum komutu:"
        echo "curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 2 --agent-type workstation --auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
    else
        echo "Installation command for Armut employee:"
        echo "curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 2 --agent-type workstation --auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
    fi
elif [ "$company" = "2" ]; then
    if [ "$lang" = "1" ]; then
        echo "Pronto Pro çalışanı için kurulum komutu:"
        echo "curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 1 --agent-type workstation --auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
    else
        echo "Installation command for Pronto Pro employee:"
        echo "curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io --client-id 1 --site-id 1 --agent-type workstation --auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
    fi
else
    echo "Geçersiz seçim / Invalid selection."
fi

echo "=============================================="
