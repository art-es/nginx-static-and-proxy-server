# Сборка BE приложения 
FROM golang:1.18 AS backend-builder

WORKDIR /src

COPY main.go /src

RUN go build -o test-backend main.go

# Основной контейнер
FROM nginx:1.23.0

RUN apt update && apt install -y \
# Команда чтобы смотреть процессы (оционально)
    procps \
# Команда чтобы смотреть какие процессы на каких портах сидят
    lsof \ 
# Редактор файлов
    vim \ 
# HTTP клиент
    curl \
# Команда для запуска параллельных процессов с graceful shutdown
    supervisor

# Конфиг для supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Конфиг для nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Статические файлы FE приложения
COPY static /static
# Собранное BE приложение
COPY --from=backend-builder /src/test-backend /test-backend

# Just For Debug
# CMD ["nginx", "-g", "daemon off;"]

CMD ["supervisord"]
