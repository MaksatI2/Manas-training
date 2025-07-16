#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔧 Проверка и установка Docker...${NC}"

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker уже установлен${NC}"
    docker --version
else
    echo -e "${YELLOW}📦 Установка Docker...${NC}"

    sudo apt-get update

    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    sudo usermod -aG docker $USER

    echo -e "${GREEN}✅ Docker установлен успешно${NC}"
fi

if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅ Docker Compose уже установлен${NC}"
    docker-compose --version
else
    echo -e "${YELLOW}📦 Установка Docker Compose...${NC}"

    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    echo -e "${GREEN}✅ Docker Compose установлен успешно${NC}"
fi

echo -e "${YELLOW}🚀 Запуск Docker сервиса...${NC}"
sudo systemctl start docker
sudo systemctl enable docker

echo -e "${GREEN}✅ Docker готов к использованию${NC}"