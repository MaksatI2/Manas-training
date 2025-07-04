#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Начинаем деплой приложения...${NC}"

echo -e "${YELLOW}🛑 Остановка старых контейнеров...${NC}"
docker-compose down --remove-orphans

echo -e "${YELLOW}🗑️ Удаление старого образа приложения...${NC}"
docker rmi $(docker images -q manas-training-service_app) 2>/dev/null || true

echo -e "${YELLOW}📁 Создание директорий...${NC}"
mkdir -p logs uploads

echo -e "${YELLOW}🔨 Сборка и запуск контейнеров...${NC}"
docker-compose up -d --build

echo -e "${YELLOW}⏳ Ожидание готовности сервисов...${NC}"
sleep 30

echo -e "${YELLOW}🔍 Проверка статуса контейнеров...${NC}"
docker-compose ps

echo -e "${YELLOW}📝 Последние логи приложения:${NC}"
docker-compose logs --tail=50 app


echo -e "${GREEN} Деплой завершен успешно!${NC}"
echo -e "${GREEN}🌐 Приложение доступно по адресу: http://mtc.edu.kg${NC}"