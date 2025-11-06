#!/bin/bash
set -e
cd /opt/CattyForDevOps
echo "🧪 Running Catty tests..."

# Устанавливаем Playwright браузеры
playwright install --with-deps chromium

# Запускаем приложение в фоне
echo "🚀 Starting application..."
python app.py &
APP_PID=$!
sleep 5

if ! ps -p $APP_PID > /dev/null; then
    echo "❌ Failed to start application"
    exit 1
fi

if ! curl -s http://localhost:8282 > /dev/null; then
    echo "❌ Application not responding on port 8282"
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