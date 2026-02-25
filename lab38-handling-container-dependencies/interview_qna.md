# 💬 Interview Q&A — Lab 38: Handling Container Dependencies

---

## 1) What does `depends_on` do in a Compose file?
`depends_on` controls service startup ordering. It ensures one service is started before another. When combined with a health condition (`service_healthy`), it can delay startup until the dependency passes its healthcheck.

---

## 2) Does `depends_on` guarantee the dependent service is ready to accept connections?
Not always. It depends on the compose implementation and whether health conditions are supported. Even with ordering, readiness should still be validated with healthchecks and/or retry logic.

---

## 3) What healthcheck did you use for PostgreSQL in this lab?
PostgreSQL readiness was checked using:
```yaml id="s3k8b2"
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 5s
  timeout: 5s
  retries: 5
````

---

## 4) How did you confirm the database container became healthy?

Using Podman inspection:

```bash id="v4n1x7"
podman inspect --format='{{.State.Health.Status}}' container-dependencies-lab_db_1
```

It returned `healthy`.

---

## 5) Why are healthchecks important in multi-service deployments?

Because “container started” ≠ “service ready.” Healthchecks validate real readiness and reduce startup race conditions, preventing dependent services from failing early.

---

## 6) What is the purpose of retry logic in an entrypoint script?

Retry logic prevents an app from failing immediately if a dependency (like a DB) isn’t reachable yet. It improves resilience and makes deployments more reliable.

---

## 7) What check did the retry logic use to confirm DB reachability?

It used a TCP port probe:

```sh id="y8w3m2"
nc -z db 5432
```

This verifies the DB port is accepting connections.

---

## 8) Why did you install `netcat-openbsd` in the Python Alpine image?

Because `nc` isn’t guaranteed to exist in minimal images. Installing `netcat-openbsd` ensured the entrypoint retry logic works reliably.

---

## 9) What was the purpose of the Python `app.py` script?

It tested real service connectivity by attempting a PostgreSQL connection using `psycopg2`. Success confirmed DNS/service name resolution (`db`) and credential handling.

---

## 10) Why did you install `psycopg2-binary`?

`psycopg2` is not included by default in `python:alpine`. Installing `psycopg2-binary` allowed the Python script to connect to PostgreSQL.

---

## 11) How did you pass the DB password into the app container?

Via environment variables in compose:

```yaml id="k6q9a1"
environment:
  POSTGRES_PASSWORD: example
```

The app reads it using `os.getenv("POSTGRES_PASSWORD")`.

---

## 12) What happens if the DB never becomes reachable in your entrypoint script?

After `max_retries`, it prints a failure message and exits with code `1`, which correctly signals deployment failure:

```sh id="f8k2b0"
echo "Failed to connect to database after $max_retries attempts"
exit 1
```

---

## 13) Why can “healthcheck scripts” sometimes be misleading?

If the check uses the wrong protocol (e.g., HTTP curl against a non-HTTP port), it can report false negatives. Real checks should match the service protocol (TCP probes or `pg_isready` for Postgres).

---

## 14) What is the best-practice combination for dependency handling?

A robust approach usually includes:

* `depends_on` ordering (optional convenience)
* healthchecks for readiness
* entrypoint retry logic for safety
  This provides multiple layers of reliability.

---

## 15) What’s the main operational benefit of this lab pattern?

It prevents fragile deployments where services crash due to startup timing. This is critical in orchestration environments where containers are restarted automatically and timing is unpredictable.
