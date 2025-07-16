#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN="manastraining.kg"
SSL_DIR="nginx/ssl"

echo -e "${GREEN}🔐 Настройка SSL для домена $DOMAIN...${NC}"

mkdir -p $SSL_DIR

if ! command -v certbot &> /dev/null; then
    echo -e "${YELLOW}📦 Установка certbot...${NC}"
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

echo -e "${YELLOW}🔧 Создание временного самоподписанного сертификата...${NC}"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $SSL_DIR/key.pem \
    -out $SSL_DIR/cert.pem \
    -subj "/C=KG/ST=Bishkek/L=Bishkek/O=Manas Training/CN=$DOMAIN"

sudo chown -R $USER:$USER $SSL_DIR
chmod 600 $SSL_DIR/key.pem
chmod 644 $SSL_DIR/cert.pem

echo -e "${GREEN}✅ Временный SSL сертификат создан${NC}"
echo -e "${YELLOW}⚠️  Примечание: Это самоподписанный сертификат для разработки${NC}"
echo -e "${YELLOW}   Для продакшена получите сертификат Let's Encrypt:${NC}"
echo -e "${YELLOW}   sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN${NC}"

echo -e "${GREEN}🚀 SSL настроен успешно!${NC}"