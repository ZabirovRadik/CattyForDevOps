FROM python:3.11

WORKDIR /opt/CattyForDevOps

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

ENV PYTHONPATH="/opt/CattyForDevOps"

EXPOSE 8181

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8181"]