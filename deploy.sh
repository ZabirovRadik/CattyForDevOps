#!/bin/bash
set -e

APP_DIR="/opt/CattyForDevOps"
SERVICE_NAME="catty.service"

echo "🚀 Деплой Catty приложения..."

# Создаём директорию для приложения
sudo mkdir -p $APP_DIR
sudo rm -rf $APP_DIR/*
sudo cp -r "/home/ubuntu/DevOPs/DevOps1/CattyForDevOps" "/opt"
sudo chown -R ubuntu:ubuntu $APP_DIR
cd $APP_DIR

# Создаём виртуальное окружение для продакшена
if [ ! -d "/home/ubuntu/DevOPs/DevOps1/venv" ]; then	
   python3 -m venv /home/ubuntu/DevOPs/DevOps1/venv
fi
source /home/ubuntu/DevOPs/DevOps1/venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
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