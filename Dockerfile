FROM python:3.11
# Установка системных зависимостей для MySQL
RUN apt-get update && apt-get install -y \
    curl \
    default-libmysqlclient-dev \
    pkg-config \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/CattyForDevOps

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt


COPY . .

ENV PYTHONPATH="/opt/CattyForDevOps"

EXPOSE 8181

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8181"]