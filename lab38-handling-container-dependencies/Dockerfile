FROM python:3.9-alpine
WORKDIR /app

COPY entrypoint.sh .
COPY app.py .

RUN chmod +x entrypoint.sh && \
    apk add --no-cache netcat-openbsd postgresql-libs && \
    pip install --no-cache-dir psycopg2-binary

ENTRYPOINT ["./entrypoint.sh"]
CMD ["python", "app.py"]
