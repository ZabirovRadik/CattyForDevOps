#!/bin/bash
set -e

APP_DIR="/opt/CattyForDevOps"
SERVICE_NAME="catty.service"

echo "🚀 Деплой Catty приложения..."

# Создаём systemd unit для FastAPI (если нет)
sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null <<EOF
[Unit]
Description=Catty Reminders App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=$APP_DIR
ExecStart=/home/ubuntu/DevOPs/DevOps1/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8181
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Перезапускаем сервис
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo "✅ Catty успешно задеплоен и запущен на порту 8181!"