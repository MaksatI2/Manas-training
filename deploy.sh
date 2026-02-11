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

echo -e "${YELLOW}🔍 Проверка статуса приложения...${NC}"
docker-compose ps app

echo -e "${YELLOW}📝 Логи приложения (последние 80 строк):${NC}"
docker-compose logs --tail=80 app

echo -e "${YELLOW}🔍 Проверка здоровья приложения (изнутри контейнера, IPv4)...${NC}"

APP_CID=$(docker-compose ps -q app)
if [ -z "$APP_CID" ]; then
  echo -e "${RED}❌ Контейнер app не найден (docker-compose ps -q app пусто)${NC}"
  docker-compose ps
  exit 1
fi

HEALTH_URL="http://127.0.0.1:8089/actuator/health"

ok=0
last_code="000"

=for i in $(seq 1 30); do
  last_code=$(docker exec "$APP_CID" sh -lc "apk add --no-cache curl >/dev/null 2>&1 || true; curl -4 -s -o /dev/null -w '%{http_code}' $HEALTH_URL" 2>/dev/null || echo "000")

  if [ "$last_code" = "200" ] || [ "$last_code" = "302" ]; then
    ok=1
    break
  fi

  echo -e "${YELLOW}⏳ Ждём приложение... попытка $i/30, HTTP $last_code${NC}"
  sleep 2
done

if [ "$ok" = "1" ]; then
  echo -e "${GREEN}✅ Приложение отвечает (HTTP $last_code)${NC}"
  echo -e "${YELLOW}ℹ️ Health URL: $HEALTH_URL${NC}"
else
  echo -e "${RED}❌ Приложение не готово (последний HTTP $last_code).${NC}"
  echo -e "${YELLOW}🔎 Ответ health (первые 30 строк) из контейнера:${NC}"
  docker exec "$APP_CID" sh -lc "apk add --no-cache curl >/dev/null 2>&1 || true; curl -4 -sS -i $HEALTH_URL | head -n 30" || true

  echo -e "${RED}📝 Полные логи приложения:${NC}"
  docker-compose logs app
  exit 1
fi

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
