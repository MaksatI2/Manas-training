#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo -e "${GREEN}🚀 Начинаем деплой приложения на новом сервере...${NC}"

echo -e "${YELLOW}🛑 Остановка старых контейнеров (если есть)...${NC}"
docker-compose down --remove-orphans 2>/dev/null || true

echo -e "${YELLOW}🗑️ Удаление старых образов приложения...${NC}"
docker rmi $(docker images -q manas-training-service_app) 2>/dev/null || true

echo -e "${YELLOW}📁 Создание необходимых директорий...${NC}"
mkdir -p logs uploads nginx/ssl nginx/logs nginx/html/.well-known/acme-challenge

echo -e "${YELLOW}🔐 Проверка SSL сертификатов...${NC}"
chmod +x setup-ssl.sh
if [ -f "nginx/ssl/fullchain.pem" ]; then
    echo -e "${GREEN}ℹ️ Проверка срока действия сертификата...${NC}"
    ./setup-ssl.sh --check
    echo -e "${YELLOW}📝 SSL сертификаты будут обновлены при необходимости${NC}"
else
    echo -e "${YELLOW}🆕 Сертификаты не найдены, создаем новые...${NC}"
fi
./setup-ssl.sh

echo -e "${YELLOW}🔨 Сборка и запуск контейнеров...${NC}"
docker-compose up -d --build

echo -e "${YELLOW}⏳ Ожидание готовности сервисов...${NC}"
sleep 30

echo -e "${YELLOW}🔍 Проверка статуса контейнеров...${NC}"
docker-compose ps

echo -e "${YELLOW}📝 Последние логи приложения:${NC}"
docker-compose logs --tail=50 app

echo -e "${YELLOW}🔍 Проверка nginx конфигурации...${NC}"
docker-compose exec nginx nginx -t

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
echo -e "${GREEN}🌐 Приложение доступно по адресу: https://manastraining.kg${NC}"

echo -e "${YELLOW}🔍 Проверка доступности приложения...${NC}"
sleep 10

if curl -f -k http://localhost:8089/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Приложение работает корректно${NC}"
else
    echo -e "${RED}❌ Приложение не отвечает. Проверьте логи:${NC}"
    docker-compose logs app
fi

if curl -f -k https://manastraining.kg > /dev/null 2>&1; then
    echo -e "${GREEN}✅ HTTPS работает корректно${NC}"
else
    echo -e "${YELLOW}⚠️ HTTPS может быть недоступен. Проверьте nginx логи:${NC}"
    docker-compose logs nginx
fi

echo -e "${YELLOW}📋 Полезные команды:${NC}"
echo -e "Просмотр логов: docker-compose logs -f [service_name]"
echo -e "Перезапуск сервиса: docker-compose restart [service_name]"
echo -e "Обновление SSL: ./setup-ssl.sh"
echo -e "Проверка nginx: docker-compose exec nginx nginx -t"