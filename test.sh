set -e
echo "🧪 Running Catty tests..."

MAIN_DIR="/home/ubuntu/DevOPs/DevOps1/CattyForDevOps"
VENV_PATH="$MAIN_DIR/../venv"

if [ ! -d "$VENV_PATH" ]; then	
             python3 -m venv $VENV_PATH
fi

# Устанавливаем Playwright браузеры
playwright install --with-deps chromium

# Запускаем приложение в фоне
echo "🚀 Starting application..."
$VENV_PATH/bin/uvicorn app.main:app --host 0.0.0.0 --port 8181 &
APP_PID=$!
sleep 5

if ! ps -p $APP_PID > /dev/null; then
    echo "❌ Failed to start application"
    exit 1
fi


if ! curl -s http://localhost:8181 > /dev/null; then
    echo "❌ Application not responding on port 8181"
    kill $APP_PID
    exit 1
fi

# Запускаем тесты
pytest -v tests/test_unit.py
pytest -v tests/test_api.py
pytest -s -v --browser chromium tests/test_ui.py

# Останавливаем приложение
echo "🛑 Stopping application..."
kill $APP_PID
wait $APP_PID 2>/dev/null

echo "🎉 All Catty tests passed!"