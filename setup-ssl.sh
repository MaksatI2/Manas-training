#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN="manastraining.kg"
EMAIL="zer0icemax@gmail.com"
SSL_DIR="./nginx/ssl"

echo -e "${GREEN}🔐 Настройка SSL сертификата для $DOMAIN${NC}"

mkdir -p $SSL_DIR
mkdir -p ./nginx/logs
mkdir -p ./nginx/html/.well-known/acme-challenge

if ! command -v certbot &> /dev/null; then
    echo -e "${YELLOW}📦 Установка Certbot...${NC}"
    sudo apt update
    sudo apt install -y certbot
fi

if [ -f "$SSL_DIR/fullchain.pem" ] && [ -f "$SSL_DIR/privkey.pem" ]; then
    echo -e "${GREEN}✅ SSL сертификат уже существует${NC}"

    if openssl x509 -checkend 2592000 -noout -in "$SSL_DIR/fullchain.pem" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Сертификат действителен еще минимум 30 дней${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠️ Сертификат истекает в ближайшие 30 дней, обновляем...${NC}"
    fi
fi

echo -e "${YELLOW}🔒 Создание временного самоподписанного сертификата...${NC}"
openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
    -keyout "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/fullchain.pem" \
    -subj "/C=KG/ST=Bishkek/L=Bishkek/O=ManasTraining/CN=$DOMAIN"

echo -e "${YELLOW}🚀 Запуск nginx для валидации домена...${NC}"
docker-compose up -d nginx

sleep 10

echo -e "${YELLOW}🌐 Получение SSL сертификата от Let's Encrypt...${NC}"
sudo certbot certonly \
    --webroot \
    --webroot-path=./nginx/html \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    --domains $DOMAIN,www.$DOMAIN \
    --keep-until-expiring \
    --non-interactive

if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo -e "${YELLOW}📋 Копирование сертификатов...${NC}"
    sudo cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$SSL_DIR/"
    sudo cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$SSL_DIR/"
    sudo chown $(whoami):$(whoami) "$SSL_DIR/fullchain.pem" "$SSL_DIR/privkey.pem"
    sudo chmod 644 "$SSL_DIR/fullchain.pem"
    sudo chmod 600 "$SSL_DIR/privkey.pem"

    echo -e "${GREEN}✅ SSL сертификат успешно установлен!${NC}"
else
    echo -e "${RED}❌ Ошибка получения сертификата от Let's Encrypt${NC}"
    echo -e "${YELLOW}🔒 Используем самоподписанный сертификат${NC}"
fi

echo -e "${YELLOW}🔄 Перезапуск nginx с новыми сертификатами...${NC}"
docker-compose restart nginx

echo -e "${YELLOW}⏰ Настройка автоматического обновления сертификата...${NC}"
CRON_JOB="0 3 * * 1 /usr/bin/certbot renew --quiet --post-hook 'cd $(pwd) && docker-compose restart nginx'"

if ! crontab -l 2>/dev/null | grep -q "certbot renew"; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | sudo crontab -
    echo -e "${GREEN}✅ Автоматическое обновление сертификата настроено${NC}"
else
    echo -e "${GREEN}✅ Автоматическое обновление сертификата уже настроено${NC}"
fi

echo -e "${GREEN}🎉 SSL настройка завершена!${NC}"