#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Load env vars from .env if present
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

echo -e "${YELLOW}📝 Логи приложения (последние 50 строк):${NC}"
docker-compose logs --tail=50 app

echo -e "${YELLOW}🔍 Проверка здоровья приложения (изнутри контейнера)...${NC}"

HEALTH_URL="http://localhost:8089/actuator/health"

APP_CID=$(docker-compose ps -q app)

if [ -z "$APP_CID" ]; then
  echo -e "${RED}❌ Контейнер app не найден (docker-compose ps -q app пусто)${NC}"
  docker-compose ps
  exit 1
fi

code=$(docker exec "$APP_CID" sh -lc "apk add --no-cache curl >/dev/null 2>&1 || true; curl -s -o /dev/null -w '%{http_code}' $HEALTH_URL" || echo "000")

if [ "$code" = "200" ] || [ "$code" = "302" ]; then
  echo -e "${GREEN}✅ Приложение отвечает (HTTP $code)${NC}"
else
  echo -e "${RED}❌ Приложение не отвечает как ожидается (HTTP $code).${NC}"
  echo -e "${YELLOW}🔎 Ответ health (первые 30 строк) из контейнера:${NC}"
  docker exec "$APP_CID" sh -lc "apk add --no-cache curl >/dev/null 2>&1 || true; curl -sS -i $HEALTH_URL | head -n 30" || true

  echo -e "${RED}📝 Полные логи приложения:${NC}"
  docker-compose logs app
  exit 1
fi


echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
