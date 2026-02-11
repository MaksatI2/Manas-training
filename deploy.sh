#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo -e "${GREEN}🚀 Начинаем деплой приложения...${NC}"

echo -e "${YELLOW}🔨 Пересборка и перезапуск контейнера приложения...${NC}"
docker-compose up -d --build app

echo -e "${YELLOW}⏳ Ожидание готовности приложения...${NC}"
sleep 15

echo -e "${YELLOW}🔍 Проверка статуса приложения...${NC}"
docker-compose ps app

echo -e "${YELLOW}📝 Логи приложения (последние 20 строк):${NC}"
docker-compose logs --tail=20 app

echo -e "${YELLOW}🔍 Проверка здоровья приложения...${NC}"
if curl -f http://localhost:8089/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Приложение работает корректно${NC}"
else
    echo -e "${RED}❌ Приложение не отвечает. Полные логи:${NC}"
    docker-compose logs app
    exit 1
fi

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"