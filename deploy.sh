#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Начинаем деплой приложения...${NC}"

if [ -z "$POSTGRES_PASSWORD" ]; then
    echo -e "${RED}❌ Не установлена переменная POSTGRES_PASSWORD${NC}"
    exit 1
fi

if [ -z "$MAIL_USERNAME" ]; then
    echo -e "${RED}❌ Не установлена переменная MAIL_USERNAME${NC}"
    exit 1
fi

if [ -z "$MAIL_PASSWORD" ]; then
    echo -e "${RED}❌ Не установлена переменная MAIL_PASSWORD${NC}"
    exit 1
fi

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

echo -e "${YELLOW}🏥 Проверка здоровья приложения...${NC}"
if curl -f http://localhost:8089/actuator/health >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Приложение запущено и работает корректно!${NC}"
    echo -e "${GREEN}🌐 Приложение доступно по адресу: http://localhost:8089${NC}"
else
    echo -e "${RED}❌ Приложение не отвечает на health check${NC}"
    echo -e "${YELLOW}📋 Логи для диагностики:${NC}"
    docker-compose logs app
    exit 1
fi

echo -e "${GREEN}🎉 Деплой завершен успешно!${NC}"