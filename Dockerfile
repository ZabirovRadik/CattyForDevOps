FROM python:3.10-slim

WORKDIR /opt/CattyForDevOps

COPY . .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt


ENV PYTHONPATH="/opt/CattyForDevOps"

RUN python --version
RUN pip list

EXPOSE 8181

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8181"]