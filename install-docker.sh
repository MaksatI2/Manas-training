#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SUDO_PASSWORD="manastraining14072025_kg"

echo -e "${GREEN}🔧 Проверка и установка Docker...${NC}"

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker уже установлен${NC}"
    docker --version
else
    echo -e "${YELLOW}📦 Установка Docker...${NC}"

    echo "$SUDO_PASSWORD" | sudo -S apt-get update

    echo "$SUDO_PASSWORD" | sudo -S apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    echo "$SUDO_PASSWORD" | sudo -S mkdir -p /usr/share/keyrings

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        echo "$SUDO_PASSWORD" | sudo -S gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | \
        echo "$SUDO_PASSWORD" | sudo -S tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "$SUDO_PASSWORD" | sudo -S apt-get update

    echo "$SUDO_PASSWORD" | sudo -S apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io

    echo "$SUDO_PASSWORD" | sudo -S usermod -aG docker $USER

    echo -e "${GREEN}✅ Docker установлен успешно${NC}"
fi

if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅ Docker Compose уже установлен${NC}"
    docker-compose --version
else
    echo -e "${YELLOW}📦 Установка Docker Compose...${NC}"

    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

    echo "$SUDO_PASSWORD" | sudo -S curl -L \
        "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose

    echo "$SUDO_PASSWORD" | sudo -S chmod +x /usr/local/bin/docker-compose

    echo -e "${GREEN}✅ Docker Compose установлен успешно${NC}"
fi

echo -e "${YELLOW}🚀 Запуск Docker сервиса...${NC}"
echo "$SUDO_PASSWORD" | sudo -S systemctl start docker
echo "$SUDO_PASSWORD" | sudo -S systemctl enable docker

echo -e "${YELLOW}📋 Проверка статуса Docker...${NC}"
echo "$SUDO_PASSWORD" | sudo -S systemctl status docker --no-pager

echo -e "${GREEN}✅ Docker готов к использованию${NC}"

echo -e "${YELLOW}📄 Информация о версиях:${NC}"
docker --version
docker-compose --version