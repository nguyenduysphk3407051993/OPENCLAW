# 🦞 OpenClaw Docker Setup

Dự án này đã được cấu hình để chạy OpenClaw trên Docker với cấu trúc thư mục gọn gàng và bảo mật.

## 📁 Cấu Trúc Thư Mục

```
.
├── docker/                 # File Dockerfile và script khởi động
│   ├── Dockerfile
│   └── entrypoint.sh
├── config/                 # File cấu hình OpenClaw
│   └── openclaw.json
├── data/                   # Dữ liệu bền vững (workspace)
│   └── workspace/
├── skills/                 # Các skills của bạn (được mount vào container)
├── .env                    # Biến môi trường
├── docker-compose.yml      # File cấu hình Docker Compose
└── README.md
```

## 🚀 Cài Đặt & Sử Dụng

### Bước 1: Kiểm tra cấu hình

1.  Kiểm tra file `.env`: đảm bảo các API key và domain đã chính xác.
2.  Kiểm tra `config/openclaw.json` (đã được cấu hình sẵn để khớp với Docker).

### Bước 2: Khởi chạy

Mở terminal tại thư mục gốc và chạy:

```bash
docker compose up -d --build
```
Lệnh này sẽ build lại image từ `docker/Dockerfile` và khởi động container.

### Bước 3: Kiểm tra trạng thái

Xem logs của gateway:

```bash
docker compose logs -f openclaw-gateway
```

### Bước 4: Sử dụng CLI

Để chạy các lệnh OpenClaw CLI (ví dụ login, cài đặt skills):

```bash
# Vào shell của container CLI
docker compose run --rm openclaw-cli /bin/sh

# Hoặc chạy lệnh trực tiếp, ví dụ:
docker compose run --rm openclaw-cli models auth login
```

## 🛠 Troubleshooting

Nếu gặp lỗi permission với thư mục `data/workspace` hoặc `config/`:
Container chạy với user `openclaw` (UID 1000). Đảm bảo user hiện tại của bạn có quyền ghi vào các thư mục này, hoặc set quyền:

```bash
chown -R 1000:1000 data config
```
