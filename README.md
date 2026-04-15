# Notes App — Infrastructure & Deployment Guide

## 📦 Структура репозитория

```
.
├── backend/                  # Backend (API)
├── frontend/                 # Frontend (UI)
├── k8s/                      # Kubernetes manifests
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── ingress.yaml
├── .github/workflows/        # CI/CD pipeline
│   └── cicd.yml
└── README.md
```

### Основные компоненты

* **backend/** — серверная часть приложения
* **frontend/** — клиентская часть
* **k8s/** — манифесты Kubernetes
* **.github/workflows/** — автоматизация CI/CD

---

## ☸️ Развёртывание инфраструктуры

### Требования

* Kubernetes кластер
* `kubectl` настроен (`KUBECONFIG`)
* Namespace `notes`

### Создание namespace

```bash
kubectl create namespace notes
```

### Применение манифестов

```bash
kubectl apply -f k8s/
```

### Проверка

```bash
kubectl get pods -n notes
kubectl get svc -n notes
```

---

## 🚀 Развёртывание приложения

Деплой автоматизирован через GitHub Actions.

### CI/CD pipeline

Триггер:

* push в ветку `prod`
* изменения в:

  * `backend/**`
  * `frontend/**`

### Логика работы

1. Определяются изменения (backend/frontend)
2. Собираются Docker-образы
3. Образы пушатся в GHCR:

   ```
   ghcr.io/<repo>/backend:<commit-sha>
   ghcr.io/<repo>/frontend:<commit-sha>
   ```
4. Выполняется деплой в Kubernetes:

   ```bash
   kubectl set image deployment/<app>
   ```

---

## 🔁 Обновление приложения

### Автоматическое (рекомендуется)

```bash
git push origin prod
```

### Ручное (debug / fallback)

```bash
kubectl rollout restart deployment/frontend -n notes
kubectl rollout restart deployment/backend -n notes
```

---

## ⚙️ Правила внесения изменений в инфраструктуру

1. Все изменения делаются через Git

2. Прямые изменения в кластере запрещены (кроме debug)

3. Используется declarative подход:

   ```bash
   kubectl apply -f k8s/
   ```

4. Перед применением:

   * проверить YAML
   * убедиться в корректности ресурсов

5. Изменения в:

   * `k8s/` → влияют на инфраструктуру
   * `workflows/` → влияют на CI/CD

---

## 🔄 Релизный цикл

### Основной процесс

1. Разработка в feature-ветках
2. Merge в `prod`
3. Автоматический запуск CI/CD
4. Деплой в Kubernetes

---

## 🏷️ Версионирование

Используется **commit SHA как immutable версия**

Пример:

```
backend: 7ce5e3f8e87cdd307820aff602101e7744e91f46
frontend: 7ce5e3f8e87cdd307820aff602101e7744e91f46
```

### Принципы

* ❌ не использовать `latest`
* ❌ не полагаться на `prod` тег
* ✅ всегда использовать SHA
* ✅ каждая версия воспроизводима

---

## 🔐 Доступы и безопасность

* Доступ к кластеру через `KUBECONFIG` (GitHub Secret)
* Образы хранятся в GHCR
* Используется `imagePullSecrets`

---

## 🧪 Отладка

### Проверка rollout

```bash
kubectl rollout status deployment/frontend -n notes
```

### Логи

```bash
kubectl logs -n notes <pod>
```

### Описание pod

```bash
kubectl describe pod <pod> -n notes
```

---

## 📌 Best Practices

* Использовать SHA-теги
* Не редактировать ресурсы вручную
* Проверять изменения через CI
* Делать атомарные изменения (frontend/backend отдельно)

---

## 👨‍💻 Контрибьютинг

* Все изменения через Pull Request
* Минимум — код ревью перед merge

---
