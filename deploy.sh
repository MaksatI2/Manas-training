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

echo -e "${YELLOW}🔍 Проверка здоровья приложения...${NC}"

HEALTH_URL="http://localhost:8089/actuator/health"
code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" || echo "000")

if [ "$code" = "200" ] || [ "$code" = "302" ]; then
  echo -e "${GREEN}✅ Приложение отвечает (HTTP $code)${NC}"
  echo -e "${YELLOW}ℹ️ Health endpoint: $HEALTH_URL${NC}"
else
  echo -e "${RED}❌ Приложение не отвечает как ожидается (HTTP $code).${NC}"
  echo -e "${YELLOW}🔎 Ответ health (первые 30 строк):${NC}"
  curl -sS -i "$HEALTH_URL" | head -n 30 || true

  echo -e "${RED}📝 Полные логи приложения:${NC}"
  docker-compose logs app

  exit 1
fi

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
