set -e

DEPLOY_DIR="/opt/CattyForDevOps"
MAIN_DIR="/home/ubuntu/DevOPs/DevOps1/CattyForDevOps"
VENV_PATH="$MAIN_DIR/../venv"
SERVICE_NAME=catty.service

if [ ! -d "$VENV_PATH" ]; then	
	python3 -m venv "$VENV_PATH"
fi
source "$VENV_PATH/bin/activate"
pip install --upgrade pip
pip install -r requirements.txt

# Создаём systemd unit для FastAPI (если нет)
sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null <<EOF
[Unit]
Description=Catty Reminders App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=$DEPLOY_DIR
ExecStart=$VENV_PATH/bin/uvicorn app.main:app --host 0.0.0.0 --port 8181
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Перезапускаем сервис
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo "✅ Catty has been successfully deployed and is running on the port 8181!"