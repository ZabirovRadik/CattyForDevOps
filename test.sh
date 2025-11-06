#!/bin/bash
set -e
cd /opt/CattyForDevOps
echo "🧪 Running Catty tests..."


# Устанавливаем Playwright браузеры
playwright install --with-deps chromium

# Запускаем unit + API тесты
pytest -v tests/test_unit.py
pytest -v tests/test_api.py

# Запускаем UI тесты
pytest -s -v --browser chromium tests/test_ui.py

echo "🎉 All Catty tests passed!"
deactivate