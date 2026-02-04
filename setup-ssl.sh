#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOMAIN="manastraining.kg"
EMAIL="zer0icemax@gmail.com"
SSL_DIR="./nginx/ssl"
CERTBOT_DIR="./letsencrypt"
FORCE_RENEW=false

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    FORCE_RENEW=true
    echo -e "${YELLOW}🔄 Принудительное обновление сертификата${NC}"
fi

if [ "$1" == "--check" ] || [ "$1" == "-c" ]; then
    echo -e "${GREEN}🔍 Проверка статуса SSL сертификата${NC}"
    if [ -f "$SSL_DIR/fullchain.pem" ] && [ -f "$SSL_DIR/privkey.pem" ]; then
        echo -e "${GREEN}✅ Сертификаты найдены${NC}"
        echo -e "Информация о сертификате:"
        openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -subject -issuer -dates
        
        ISSUER=$(openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -issuer)
        if echo "$ISSUER" | grep -q "ManasTraining"; then
            echo -e "${YELLOW}⚠️ Обнаружен самоподписанный сертификат${NC}"
            echo -e "${YELLOW}Запустите: ./setup-ssl.sh --force для получения настоящего сертификата${NC}"
        elif openssl x509 -checkend 2592000 -noout -in "$SSL_DIR/fullchain.pem" > /dev/null 2>&1; then
            EXPIRY=$(openssl x509 -enddate -noout -in "$SSL_DIR/fullchain.pem" | cut -d= -f2)
            echo -e "${GREEN}✅ Сертификат действителен до: $EXPIRY${NC}"
        else
            echo -e "${RED}❌ Сертификат истекает в ближайшие 30 дней!${NC}"
            echo -e "${YELLOW}Запустите: ./setup-ssl.sh --force для обновления${NC}"
        fi
    else
        echo -e "${RED}❌ Сертификаты не найдены${NC}"
    fi
    exit 0
fi

echo -e "${GREEN}🔐 Настройка SSL сертификата для $DOMAIN${NC}"

mkdir -p "$SSL_DIR"
mkdir -p "./nginx/logs"
mkdir -p "./nginx/html/.well-known/acme-challenge"

echo -e "${YELLOW}🐳 Используем Docker для Certbot${NC}"
USE_DOCKER_CERTBOT=true

check_valid_letsencrypt_cert() {
    if [ "$FORCE_RENEW" = "true" ]; then
        return 1
    fi
    
    if [ -f "$SSL_DIR/fullchain.pem" ] && [ -f "$SSL_DIR/privkey.pem" ]; then
        ISSUER=$(openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -issuer)
        if echo "$ISSUER" | grep -q "ManasTraining"; then
            echo -e "${YELLOW}⚠️ Обнаружен самоподписанный сертификат, получаем настоящий...${NC}"
            return 1
        fi
        
        if openssl x509 -checkend 2592000 -noout -in "$SSL_DIR/fullchain.pem" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Валидный Let's Encrypt сертификат уже установлен${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️ Сертификат истекает скоро, обновляем...${NC}"
            return 1
        fi
    fi
    return 1
}

create_temp_certificate() {
    echo -e "${YELLOW}🔒 Создание временного самоподписанного сертификата...${NC}"
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
        -keyout "$SSL_DIR/privkey.pem" \
        -out "$SSL_DIR/fullchain.pem" \
        -subj "/C=KG/ST=Bishkek/L=Bishkek/O=ManasTraining/CN=$DOMAIN"
}

run_certbot_docker() {
    echo -e "${YELLOW}🐳 Использование Certbot через Docker...${NC}"
    mkdir -p "$CERTBOT_DIR"

    if [ "$FORCE_RENEW" = "true" ] && [ -d "$CERTBOT_DIR/live/$DOMAIN" ]; then
        echo -e "${YELLOW}🗑️ Удаление старых сертификатов для принудительного обновления...${NC}"
        rm -rf "$CERTBOT_DIR/live/$DOMAIN"
        rm -rf "$CERTBOT_DIR/archive/$DOMAIN"
        rm -f "$CERTBOT_DIR/renewal/$DOMAIN.conf"
    fi

    if docker run --rm \
        -v "$(pwd)/nginx/html:/var/www/html" \
        -v "$(pwd)/$CERTBOT_DIR:/etc/letsencrypt" \
        -v "$(pwd)/$CERTBOT_DIR/log:/var/log/letsencrypt" \
        certbot/certbot certonly \
        --webroot \
        --webroot-path=/var/www/html \
        --email "$EMAIL" \
        --agree-tos \
        --no-eff-email \
        --domains "$DOMAIN,www.$DOMAIN" \
        --non-interactive \
        $([ "$FORCE_RENEW" = "true" ] && echo "--force-renewal" || echo "--keep-until-expiring"); then
        return 0
    else
        return 1
    fi
}

if check_valid_letsencrypt_cert; then
    echo -e "${GREEN}✅ SSL уже настроен корректно${NC}"
    exit 0
fi

if [ ! -f "$SSL_DIR/fullchain.pem" ] || [ "$FORCE_RENEW" = "true" ]; then
    create_temp_certificate
fi

echo -e "${YELLOW}🚀 Запуск nginx для валидации домена...${NC}"
docker-compose up -d nginx

echo -e "${YELLOW}⏳ Ожидание запуска nginx...${NC}"
sleep 10

echo -e "${YELLOW}🔍 Проверка доступности веб-сервера...${NC}"
if ! curl -f http://localhost/.well-known/acme-challenge/ > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ Веб-сервер может быть недоступен для валидации${NC}"
fi

echo -e "${YELLOW}🌐 Получение SSL сертификата от Let's Encrypt...${NC}"

if run_certbot_docker; then
    if [ -f "$CERTBOT_DIR/live/$DOMAIN/fullchain.pem" ]; then
        echo -e "${YELLOW}📋 Копирование сертификатов...${NC}"
        cp "$CERTBOT_DIR/live/$DOMAIN/fullchain.pem" "$SSL_DIR/"
        cp "$CERTBOT_DIR/live/$DOMAIN/privkey.pem" "$SSL_DIR/"
        chmod 644 "$SSL_DIR/fullchain.pem"
        chmod 600 "$SSL_DIR/privkey.pem"
        echo -e "${GREEN}✅ SSL сертификат успешно установлен!${NC}"
        
        ISSUER=$(openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -issuer)
        if echo "$ISSUER" | grep -q "Let's Encrypt"; then
            echo -e "${GREEN}✅ Подтверждено: сертификат выдан Let's Encrypt${NC}"
        else
            echo -e "${YELLOW}⚠️ Предупреждение: сертификат может быть не от Let's Encrypt${NC}"
        fi
    else
        echo -e "${RED}❌ Ошибка: сертификаты не найдены после выполнения Certbot${NC}"
        echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
        echo -e "${YELLOW}💡 Проверьте:${NC}"
        echo -e "   1. DNS записи для $DOMAIN и www.$DOMAIN указывают на этот сервер"
        echo -e "   2. Порты 80 и 443 открыты и доступны из интернета"
        echo -e "   3. Nginx корректно настроен для webroot валидации"
    fi
else
    echo -e "${RED}❌ Ошибка выполнения Certbot${NC}"
    echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
    echo -e "${YELLOW}📋 Проверьте логи Certbot:${NC}"
    ls -la "$CERTBOT_DIR/log/" 2>/dev/null || true
fi

echo -e "${YELLOW}🔄 Перезапуск nginx с новыми сертификатами...${NC}"
docker-compose restart nginx

echo -e "${GREEN}🎉 SSL настройка завершена!${NC}"

echo -e "${YELLOW}🔍 Финальная проверка сертификата...${NC}"
if [ -f "$SSL_DIR/fullchain.pem" ]; then
    ISSUER=$(openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -issuer)
    echo -e "Издатель: $ISSUER"
    
    if echo "$ISSUER" | grep -q "ManasTraining"; then
        echo -e "${YELLOW}⚠️ ВНИМАНИЕ: Используется самоподписанный сертификат!${NC}"
        echo -e "${YELLOW}Для получения настоящего сертификата выполните:${NC}"
        echo -e "${YELLOW}./setup-ssl.sh --force${NC}"
    fi
fi