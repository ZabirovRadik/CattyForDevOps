#!/bin/bash
set -e
cd /opt/CattyForDevOps
echo "🧪 Running Catty tests..."

# Создаём и активируем виртуальное окружение
if [ ! -d "/home/ubuntu/DevOps1/venv" ]; then	
   python3 -m venv /home/ubuntu/DevOps1/venv
fi

source /home/ubuntu/DevOps1/venv/bin/activate
export PYTHONPATH="/opt/CattyForDevOps:$PYTHONPATH"

# Устанавливаем зависимости
pip install --upgrade pip
pip install -r requirements.txt

# Устанавливаем Playwright браузеры
playwright install --with-deps chromium

# Запускаем unit + API тесты
pytest -v tests/test_unit.py
pytest -v tests/test_api.py

# Запускаем UI тесты
pytest -s -v --browser chromium tests/test_ui.py

echo "🎉 All Catty tests passed!"
deactivate