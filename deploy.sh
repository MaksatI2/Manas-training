#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Начинаем деплой приложения на новом сервере...${NC}"

echo -e "${YELLOW}🛑 Остановка старых контейнеров (если есть)...${NC}"
sudo docker-compose down --remove-orphans 2>/dev/null || true

echo -e "${YELLOW}🗑️ Удаление старых образов приложения...${NC}"
sudo docker rmi $(sudo docker images -q manas-training-service_app) 2>/dev/null || true

echo -e "${YELLOW}📁 Создание необходимых директорий...${NC}"
mkdir -p logs uploads nginx/ssl nginx/logs

echo -e "${YELLOW}🔐 Настройка SSL сертификатов...${NC}"
chmod +x setup-ssl.sh
./setup-ssl.sh

echo -e "${YELLOW}🔧 Настройка прав доступа...${NC}"
sudo usermod -aG docker $USER

sudo chmod 666 /var/run/docker.sock

echo -e "${YELLOW}🔨 Сборка и запуск контейнеров...${NC}"
docker-compose up -d --build

echo -e "${YELLOW}⏳ Ожидание готовности сервисов...${NC}"
sleep 30

echo -e "${YELLOW}🔍 Проверка статуса контейнеров...${NC}"
docker-compose ps

echo -e "${YELLOW}📝 Последние логи приложения:${NC}"
docker-compose logs --tail=50 app

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
echo -e "${GREEN}🌐 Приложение доступно по адресу: https://manastraining.kg${NC}"

echo -e "${YELLOW}🔍 Проверка доступности приложения...${NC}"
sleep 10
if curl -f http://localhost:8089/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Приложение работает корректно${NC}"
else
    echo -e "${RED}❌ Приложение не отвечает. Проверьте логи:${NC}"
    docker-compose logs app
fi