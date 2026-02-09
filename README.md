# 🦞 OpenClaw + Traefik (Đã Có Sẵn)

## 📁 Files

```
openclaw-only/
├── Dockerfile
├── docker-compose.yml
└── .env
```

---

## 🚀 Cài Đặt

### Bước 1: Cấu hình .env

```bash
nano .env
```

Điền API key:
```env
DOMAIN_NAME=edutechnd.org
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxx
```

### Bước 2: Build và chạy

```bash
docker compose build
docker compose up -d
```

### Bước 3: Kết nối WhatsApp

```bash
docker compose run -it --rm openclaw-cli channels login
```

---

## 🌐 Truy Cập

```
https://openclaw.edutechnd.org
```

---

## 📋 Commands

```bash
# Xem logs
docker compose logs -f openclaw-gateway

# Restart
docker compose restart

# Stop
docker compose down

# Chạy CLI
docker compose run --rm openclaw-cli <command>
```
# OPENCLAW
