FROM python:3.9-slim
COPY . /app
WORKDIR /app
RUN pip install flask boto3 prometheus_client
EXPOSE 8000
CMD ["python", "app.py"]
