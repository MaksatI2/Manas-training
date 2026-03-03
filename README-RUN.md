# README по запуску проекта (Manas Training Service)

Этот файл только про запуск: локально, через Docker, и стандартный деплой-процесс.

## 1) Варианты запуска

Есть 2 основных сценария:

1. **Локальная разработка**
   - поднимаем только PostgreSQL в Docker,
   - приложение запускаем из IDE/через Maven.

2. **Полный Docker-стек**
   - PostgreSQL + приложение + Nginx + Jitsi контейнеры,
   - максимально близко к production.

---

## 2) Пререквизиты

Установить:
- Java 17
- Docker + Docker Compose
- (опционально) Maven, если не используешь `./mvnw`

Проверка:

```bash
java -version
docker --version
docker compose version
```

---

## 3) Запуск для локальной разработки (рекомендуется для coding)

### Шаг 1. Поднять только PostgreSQL

```bash
docker compose -f docker-compose.dev.yml up -d
```

БД будет доступна на `localhost:8888`.

Параметры dev-БД:
- DB: `postgres`
- user: `postgres`
- password: `qwerty`

### Шаг 2. Запустить приложение

Из IDE: запусти `ManasTrainingServiceApplication`.

Или через Maven:

```bash
./mvnw spring-boot:run
```

Приложение работает на:
- `http://localhost:8089`

### Шаг 3. Остановить dev-БД

```bash
docker compose -f docker-compose.dev.yml down
```

Если нужно удалить volume с данными:

```bash
docker compose -f docker-compose.dev.yml down -v
```

---

## 4) Полный запуск через Docker Compose

Файл: `docker-compose.yml`

В этом режиме поднимаются:
- `nginx`
- `postgres`
- `app`
- `prosody`
- `jicofo`
- `jvb`
- `jitsi-web`

### Важно про jar

Сервис `app` монтирует `./target/app.jar`.

Перед запуском полного стека обязательно:

```bash
./mvnw clean package
cp target/*.jar target/app.jar
```

### Шаг 1. (опционально) Создать `.env`

Можно положить в корень проекта файл `.env`:

```env
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=qwerty

SPRING_PROFILES_ACTIVE=docker
DOMAIN=manastraining.kg
APP_BASE_URL=https://manastraining.kg

MAIL_USERNAME=your_mail@gmail.com
MAIL_PASSWORD=your_app_password

JICOFO_COMPONENT_SECRET=jicofo-secret
JVB_AUTH_PASSWORD=jvb-password
JICOFO_AUTH_PASSWORD=focus-password
```

### Шаг 2. Поднять стек

```bash
docker compose up -d
```

### Шаг 3. Проверить статус

```bash
docker compose ps
docker logs --tail 120 manas-app
```

### Шаг 4. Остановить стек

```bash
docker compose down
```

Полный сброс с удалением volumes:

```bash
docker compose down -v
```

---

## 5) Стандартный цикл обновления (деплой)

В проекте есть `deploy.sh`, который:
1. Проверяет `target/app.jar`.
2. Делает `docker compose down`.
3. Делает `docker compose up -d`.
4. Показывает логи `manas-app`.

Порядок:

```bash
./mvnw clean package
cp target/*.jar target/app.jar
./deploy.sh
```

---

## 6) SSL (опционально для production)

Скрипт `setup-ssl.sh`:
- получает/обновляет сертификаты,
- кладет их в `nginx/ssl`,
- перезапускает `nginx`.

Примеры:

```bash
./setup-ssl.sh
./setup-ssl.sh --check
./setup-ssl.sh --force
```

---

## 7) Быстрый troubleshooting

### Приложение не стартует в compose
- Проверь, что есть файл `target/app.jar`.
- Проверь логи: `docker logs manas-app`.

### Ошибка подключения к БД
- Для dev-режима БД должна быть на `localhost:8888`.
- Проверь контейнер: `docker ps | grep postgres`.

### Порт занят
- Приложение: `8089`
- Postgres(dev): `8888`
- Nginx: `80/443`
- JVB: `10000/udp`, `4443`

### Проверка health

```bash
curl -f http://localhost:8089/actuator/health
```

---

## 8) Команды-шпаргалка

```bash
# dev postgres only
docker compose -f docker-compose.dev.yml up -d

# run app locally
./mvnw spring-boot:run

# build
./mvnw clean package

# full stack
cp target/*.jar target/app.jar
docker compose up -d

# stop full stack
docker compose down
```