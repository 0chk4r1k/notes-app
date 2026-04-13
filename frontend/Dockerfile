# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Копируем package.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем весь исходный код
COPY . .

# Собираем production build
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Копируем nginx конфиг
COPY nginx.conf /etc/nginx/nginx.conf

# Копируем собранное приложение
COPY --from=builder /app/build /usr/share/nginx/html

# Открываем порт
EXPOSE 3000

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]
