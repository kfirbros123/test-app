FROM python:3.15.0b2-slim-trixie
COPY . /app
WORKDIR /app
RUN pip install flask boto3 prometheus_client
EXPOSE 8000
CMD ["python", "app.py"]
