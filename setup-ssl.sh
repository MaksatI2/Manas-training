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
        
        if openssl x509 -checkend 2592000 -noout -in "$SSL_DIR/fullchain.pem" > /dev/null 2>&1; then
            DAYS_LEFT=$(( ($(date -j -f "%b %d %T %Y %Z" "$(openssl x509 -enddate -noout -in "$SSL_DIR/fullchain.pem" | cut -d= -f2)" "+%s") - $(date +%s)) / 86400 ))
            echo -e "${GREEN}✅ Сертификат действителен. Осталось дней: ~$DAYS_LEFT${NC}"
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

if [ -n "$CI" ] || [ -n "$GITLAB_CI" ]; then
    echo -e "${YELLOW}🔧 Обнаружена CI среда, используем Docker для Certbot${NC}"
    USE_DOCKER_CERTBOT=true
else
    USE_DOCKER_CERTBOT=false
fi

install_certbot_local() {
    if ! command -v certbot &> /dev/null; then
        echo -e "${YELLOW}📦 Установка Certbot...${NC}"
        apt-get update && apt-get install -y certbot
    fi
}

run_certbot_docker() {
    echo -e "${YELLOW}🐳 Использование Certbot через Docker...${NC}"
    mkdir -p "$CERTBOT_DIR"

    docker run --rm \
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
        --keep-until-expiring
}

check_certificate() {
    if [ "$FORCE_RENEW" = "true" ]; then
        echo -e "${YELLOW}🔄 Принудительное обновление - пропускаем проверку${NC}"
        return 1
    fi
    
    if [ -f "$SSL_DIR/fullchain.pem" ] && [ -f "$SSL_DIR/privkey.pem" ]; then
        echo -e "${GREEN}✅ SSL сертификат уже существует${NC}"

        if openssl x509 -checkend 2592000 -noout -in "$SSL_DIR/fullchain.pem" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Сертификат действителен еще минимум 30 дней${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️ Сертификат истекает в ближайшие 30 дней, обновляем...${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️ Сертификаты не найдены${NC}"
        return 1
    fi
}

create_temp_certificate() {
    echo -e "${YELLOW}🔒 Создание временного самоподписанного сертификата...${NC}"
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
        -keyout "$SSL_DIR/privkey.pem" \
        -out "$SSL_DIR/fullchain.pem" \
        -subj "/C=KG/ST=Bishkek/L=Bishkek/O=ManasTraining/CN=$DOMAIN"
}

if check_certificate; then
    exit 0
fi


create_temp_certificate

echo -e "${YELLOW}🚀 Запуск nginx для валидации домена...${NC}"
docker-compose up -d nginx

sleep 15

echo -e "${YELLOW}🌐 Получение SSL сертификата от Let's Encrypt...${NC}"

if [ "$USE_DOCKER_CERTBOT" = "true" ]; then
    if run_certbot_docker; then
        if [ -f "$CERTBOT_DIR/live/$DOMAIN/fullchain.pem" ]; then
            echo -e "${YELLOW}📋 Копирование сертификатов...${NC}"
            cp "$CERTBOT_DIR/live/$DOMAIN/fullchain.pem" "$SSL_DIR/"
            cp "$CERTBOT_DIR/live/$DOMAIN/privkey.pem" "$SSL_DIR/"
            chmod 644 "$SSL_DIR/fullchain.pem"
            chmod 600 "$SSL_DIR/privkey.pem"
            echo -e "${GREEN}✅ SSL сертификат успешно установлен!${NC}"
        else
            echo -e "${RED}❌ Ошибка получения сертификата от Let's Encrypt${NC}"
            echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
        fi
    else
        echo -e "${RED}❌ Ошибка выполнения Certbot в Docker${NC}"
        echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
    fi
else
    install_certbot_local

    if certbot certonly \
        --webroot \
        --webroot-path=./nginx/html \
        --email "$EMAIL" \
        --agree-tos \
        --no-eff-email \
        --domains "$DOMAIN,www.$DOMAIN" \
        --non-interactive \
        --keep-until-expiring; then

        if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
            echo -e "${YELLOW}📋 Копирование сертификатов...${NC}"
            cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$SSL_DIR/"
            cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$SSL_DIR/"
            chmod 644 "$SSL_DIR/fullchain.pem"
            chmod 600 "$SSL_DIR/privkey.pem"
            echo -e "${GREEN}✅ SSL сертификат успешно установлен!${NC}"
        else
            echo -e "${RED}❌ Ошибка: сертификаты не найдены после успешного выполнения Certbot${NC}"
            echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
        fi
    else
        echo -e "${RED}❌ Ошибка выполнения Certbot${NC}"
        echo -e "${YELLOW}🔒 Оставляем самоподписанный сертификат${NC}"
    fi
fi

echo -e "${YELLOW}🔄 Перезапуск nginx с новыми сертификатами...${NC}"
docker-compose restart nginx

if [ "$USE_DOCKER_CERTBOT" = "false" ]; then
    echo -e "${YELLOW}⏰ Настройка автоматического обновления сертификата...${NC}"
    CRON_JOB="0 3 */1 * * /usr/bin/certbot renew --quiet --post-hook 'cd $(pwd) && docker-compose restart nginx'"

    if ! crontab -l 2>/dev/null | grep -q "certbot renew"; then
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo -e "${GREEN}✅ Автоматическое обновление сертификата настроено${NC}"
    else
        echo -e "${GREEN}✅ Автоматическое обновление сертификата уже настроено${NC}"
    fi
fi

echo -e "${GREEN}🎉 SSL настройка завершена!${NC}"