#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "=== NEW DEPLOY ==="

echo "Проверка jar:"
ls -lh target/app.jar

echo "Остановка контейнера"
docker compose down

echo "Запуск с новым jar"
docker compose up -d

echo "Ждём запуск spring..."
sleep 18

docker logs --tail 120 manas-app

echo "=== DONE ==="