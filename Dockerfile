FROM python:3.14.5-slim
COPY . /app
WORKDIR /app
RUN pip install flask boto3 prometheus_client
EXPOSE 8000
CMD ["python", "app.py"]
