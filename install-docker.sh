#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔧 Проверка Docker и Docker Compose...${NC}"

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker найден${NC}"
    docker --version
else
    echo -e "${RED}❌ Docker не найден. Установите Docker вручную${NC}"
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅ Docker Compose найден${NC}"
    docker-compose --version
else
    echo -e "${RED}❌ Docker Compose не найден. Установите Docker Compose вручную${NC}"
    exit 1
fi

echo -e "${YELLOW}🚀 Запуск Docker сервиса...${NC}"
sudo systemctl start docker
sudo systemctl enable docker

echo -e "${YELLOW}📋 Проверка статуса Docker...${NC}"
sudo systemctl status docker --no-pager

if ! groups $USER | grep -q docker; then
    echo -e "${YELLOW}👤 Добавление пользователя в группу docker...${NC}"
    sudo usermod -aG docker $USER
    echo -e "${YELLOW}⚠️  Важно: Перезагрузите сессию или выполните 'newgrp docker' для применения прав группы${NC}"
else
    echo -e "${GREEN}✅ Пользователь уже в группе docker${NC}"
fi

echo -e "${GREEN}✅ Docker готов к использованию${NC}"

echo -e "${YELLOW}📄 Информация о версиях:${NC}"
docker --version
docker-compose --version

echo -e "${GREEN}🎉 Настройка завершена успешно!${NC}"