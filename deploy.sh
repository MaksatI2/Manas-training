#!/usr/bin/env bash
set -euo pipefail

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

echo -e "${YELLOW}🔍 Проверка статуса приложения...${NC}"
docker-compose ps app

echo -e "${YELLOW}📝 Логи приложения (последние 120 строк):${NC}"
docker-compose logs --tail=120 app || true

echo -e "${YELLOW}🔍 Проверка здоровья приложения (изнутри контейнера, IPv4)...${NC}"

APP_CID="$(docker-compose ps -q app || true)"
if [ -z "${APP_CID}" ]; then
  echo -e "${RED}❌ Контейнер app не найден (docker-compose ps -q app пусто)${NC}"
  docker-compose ps
  exit 1
fi

HEALTH_URL="http://127.0.0.1:8089/actuator/health"

ok=0
last_code="000"
i=1
max=30

while [ $i -le $max ]; do
  last_code="$(docker exec "${APP_CID}" sh -lc \
    "apk add --no-cache curl >/dev/null 2>&1 || true; curl -4 -s -o /dev/null -w '%{http_code}' ${HEALTH_URL}" \
    2>/dev/null || echo "000")"

  if [ "${last_code}" = "200" ] || [ "${last_code}" = "302" ]; then
    ok=1
    break
  fi

  echo -e "${YELLOW}⏳ Ждём приложение... попытка ${i}/${max}, HTTP ${last_code}${NC}"
  sleep 2
  i=$((i+1))
done

if [ "${ok}" = "1" ]; then
  echo -e "${GREEN}✅ Приложение отвечает (HTTP ${last_code})${NC}"
  echo -e "${YELLOW}ℹ️ Health URL: ${HEALTH_URL}${NC}"
else
  echo -e "${RED}❌ Приложение не готово (последний HTTP ${last_code}).${NC}"
  echo -e "${YELLOW}🔎 Ответ health (первые 30 строк) из контейнера:${NC}"
  docker exec "${APP_CID}" sh -lc \
    "apk add --no-cache curl >/dev/null 2>&1 || true; curl -4 -sS -i ${HEALTH_URL} | head -n 30" || true

  echo -e "${RED}📝 Полные логи приложения:${NC}"
  docker-compose logs app || true
  exit 1
fi

if docker ps --format '{{.Names}}' | grep -q '^manas-nginx$'; then
  echo -e "${YELLOW}🔁 Reload nginx (на всякий случай)...${NC}"
  docker exec -it manas-nginx nginx -s reload || docker restart manas-nginx
fi

echo -e "${GREEN}✅ Деплой завершен успешно!${NC}"
