# Notes App — Development Environment

## 📌 Назначение ветки

Ветка `dev` используется для разработки, локального тестирования с помощью Docker и отладки приложения.

## 🧱 Структура проекта

```bash
.
├── backend/              # Backend (Node.js + Express + Prisma)
├── frontend/             # Frontend (React + TypeScript)
├── monitoring/           # Конфигурация мониторинга (Prometheus, Grafana)
├── docker-compose.yml    # Локальная инфраструктура
├── requirements.txt      # Python (Whisper / STT)
└── .github/workflows/    # CI/CD
```

---

## ⚙️ Технологический стек

### Backend

* Node.js (Express)
* TypeScript
* Prisma ORM
* MySQL

### Frontend

* React
* TypeScript
* CSS

### Дополнительно

* Python (Speech-to-Text / Whisper)
* Prometheus (метрики)
* Grafana (визуализация)
* Elasticsearch (логирование / поиск)

---

## 🚀 Запуск проекта (основной способ)

### 1. Требования

* Docker
* Docker Compose

---

### 2. Запуск

```bash
docker compose up --build
```

---

### 3. Доступ к сервисам

| Сервис      | URL                   |
| ----------- | --------------------- |
| Frontend    | http://localhost:3000 |
| Backend API | http://localhost:5000 |
| Prometheus  | http://localhost:9090 |
| Grafana     | http://localhost:3001 |

---

### 4. База данных

* Host: `localhost:3306`
* DB: `notes_db`
* User: `notes_user`
* Password: `notes_password`

Изменения через переменные окружения внутри `docker-compose.yml`.
---

## 🔁 Как это работает

При запуске:

1. Поднимается MySQL
2. Backend:

   * ждёт БД
   * выполняет `prisma migrate deploy`
   * запускается
3. Frontend подключается к backend
4. Поднимается мониторинг:

   * Prometheus
   * Grafana

---

## 🧪 Разработка

### Горячая перезагрузка backend

```bash
backend/src → проброшен как volume
```

👉 изменения применяются без пересборки контейнера

---

### Пересборка

```bash
docker compose up --build
```

---

### Остановка

```bash
docker compose down
```

---

## 📊 Мониторинг

### Prometheus

* собирает метрики backend
* конфиг: `monitoring/prometheus.yml`

---

### Grafana

* доступ: `admin / admin`
* преднастроенные дашборды

---

## 🔍 Логи

```bash
docker-compose logs -f backend
docker-compose logs -f frontend
```

---

## 🔄 Workflow разработки

```text
feature → dev → prod
```

### Процесс:

1. Создание feature-ветки
2. Разработка
3. PR → `dev`
4. Тестирование
5. Merge → `prod` (запуск деплоя)

---

## 🏷️ Версионирование

Используется:

* `commit SHA` как версия образа

Пример:

```bash
ghcr.io/<repo>/frontend:<sha>
```
* быстрый цикл разработки
* observability "из коробки"

---
