#!/bin/bash

# Renk tanımları
RED="\\033[1;31m"
GREEN="\\033[1;32m"
YELLOW="\\033[1;33m"
CYAN="\\033[1;36m"
RESET="\\033[0m"

# Kutulu başlık
echo -e "${CYAN}==============================================${RESET}"
echo -e "${GREEN}   Tactical RMM Agent Kurulum / Installation   ${RESET}"
echo -e "${CYAN}==============================================${RESET}"

# Şirket seçimi
echo -e "${YELLOW}Lütfen şirketinizi seçin / Please select your company:${RESET}"
echo -e "${CYAN}1${RESET} - Armut"
echo -e "${CYAN}2${RESET} - Pronto Pro"
read -p "$(echo -e ${YELLOW}Seçiminizi girin / Enter your choice (1/2):${RESET} ) " company

# Dil seçimi
echo -e "${YELLOW}Lütfen dili seçin / Please select language:${RESET}"
echo -e "${CYAN}1${RESET} - Türkçe"
echo -e "${CYAN}2${RESET} - English"
read -p "$(echo -e ${YELLOW}Seçiminizi girin / Enter your choice (1/2):${RESET} ) " lang

echo -e "${CYAN}----------------------------------------------${RESET}"

if [ "$company" = "1" ]; then
    if [ "$lang" = "1" ]; then
        echo -e "${GREEN}Armut çalışanı için kurulum komutu:${RESET}"
        echo -e "${CYAN}curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io —client-id 1 —site-id 2 —agent-type workstation —auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1${RESET}"
    else
        echo -e "${GREEN}Installation command for Armut employee:${RESET}"
        echo -e "${CYAN}curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io —client-id 1 —site-id 2 —agent-type workstation —auth b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1${RESET}"
    fi
elif [ "$company" = "2" ]; then
    if [ "$lang" = "1" ]; then
        echo -e "${GREEN}Pronto Pro çalışanı için kurulum komutu:${RESET}"
        echo -e "${CYAN}curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io —client-id 1 —site-id 1 —agent-type workstation —auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e${RESET}"
    else
        echo -e "${GREEN}Installation command for Pronto Pro employee:${RESET}"
        echo -e "${CYAN}curl -L -o tacticalagent-v2.9.1-darwin-arm64 'https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io' && chmod +x tacticalagent-v2.9.1-darwin-arm64 && sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install --api https://api.trmm.homeruntech.io —client-id 1 —site-id 1 —agent-type workstation —auth 7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e${RESET}"
    fi
else
    echo -e "${RED}Geçersiz seçim / Invalid selection.${RESET}"
fi

echo -e "${CYAN}==============================================${RESET}"
