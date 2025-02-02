# Dockerfile for the backend service
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN opentelemetry-bootstrap --action=install

COPY . .
ENV OTEL_RESOURCE_ATTRIBUTES=service.name=observe 
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317"

CMD ["opentelemetry-instrument", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
