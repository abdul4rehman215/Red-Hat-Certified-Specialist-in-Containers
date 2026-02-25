# 🛠️ Troubleshooting Guide — Lab 38: Handling Container Dependencies

> This guide covers issues commonly seen when using `depends_on`, healthchecks, and entrypoint retry logic in multi-container stacks.

---

## 1) `podman-compose up` starts web before db is actually ready

### ✅ Symptom
`web` starts, but `db` is still initializing. In stricter stacks, the app/web might fail due to early connection attempts.

### 🔎 Cause
Startup order is not the same as readiness. Some compose implementations may not fully enforce `condition: service_healthy`.

### ✅ Fix
- Use a proper DB healthcheck (`pg_isready`) and verify it:
  ```bash id="n4q1x8"
  podman inspect --format='{{.State.Health.Status}}' container-dependencies-lab_db_1
  ```

* Add app-side retry logic (entrypoint loop), not just compose ordering.

---

## 2) DB healthcheck stays `starting` or becomes `unhealthy`

### ✅ Symptom

```bash
podman inspect --format='{{.State.Health.Status}}' <db-container>
```

returns `starting` for a long time or `unhealthy`.

### 🔎 Possible Causes

* Postgres is still initializing volume/data directory
* Wrong healthcheck command
* Low timeout/retries for slower environments

### ✅ Fixes

* Increase retries/interval:

  ```yaml id="y4w8b2"
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U postgres"]
    interval: 10s
    timeout: 5s
    retries: 10
  ```
* Check logs:

  ```bash id="r8t1m2"
  podman logs container-dependencies-lab_db_1
  ```

---

## 3) App exits immediately with “nc: not found”

### ✅ Symptom

Entrypoint prints errors like:

```text
./entrypoint.sh: nc: not found
```

### 🔎 Cause

Minimal images often do not include `nc`.

### ✅ Fix

Install netcat in the image (as done in this lab):

```dockerfile id="t0m7a1"
RUN apk add --no-cache netcat-openbsd
```

---

## 4) App keeps retrying and never connects to DB

### ✅ Symptom

Logs show:

```text
Waiting for database... Attempt 1/5
Waiting for database... Attempt 2/5
...
Failed to connect to database after 5 attempts
```

### 🔎 Possible Causes

* DB container name/service name mismatch (`db` must match compose service name)
* DB container not running or unhealthy
* Network issues / wrong network
* Wrong port

### ✅ Fixes

* Confirm DB container is running:

  ```bash id="p8z1e4"
  podman ps
  ```
* Confirm service name is `db` and port `5432` is correct
* Check DB logs:

  ```bash id="q3k2v9"
  podman logs container-dependencies-lab_db_1
  ```
* Inspect network:

  ```bash
  podman network ls
  ```

---

## 5) Python app fails with `ModuleNotFoundError: psycopg2`

### ✅ Symptom

App prints:

```text
ModuleNotFoundError: No module named 'psycopg2'
```

### 🔎 Cause

`psycopg2` is not installed by default in `python:alpine`.

### ✅ Fix

Install `psycopg2-binary`:

```dockerfile id="g5r7p2"
RUN pip install --no-cache-dir psycopg2-binary
```

---

## 6) Python app connects but authentication fails

### ✅ Symptom

Connection error like:

```text
FATAL: password authentication failed for user "postgres"
```

### 🔎 Possible Causes

* Wrong password passed into container
* Env var name mismatch (`POSTGRES_PASSWORD`)
* DB initialized with a different password previously (volume persisted)

### ✅ Fixes

* Confirm env var is present in app container:

  ```bash id="j2z8k4"
  podman inspect container-dependencies-lab_app_1 --format '{{.Config.Env}}'
  ```
* If volume persisted old credentials, reset by removing volumes (careful):

  ```bash
  podman volume ls
  podman volume rm <volume_name>
  ```
* Recreate stack after cleanup:

  ```bash
  podman-compose down
  podman-compose up --build
  ```

---

## 7) Port 8080 already in use

### ✅ Symptom

Compose fails with bind error on `8080`.

### 🔎 Cause

Another process/container is already using host port 8080.

### ✅ Fix

* Identify conflict:

  ```bash
  ss -tulnp | grep 8080
  ```
* Use a different host port:

  ```yaml
  ports:
    - "8081:80"
  ```
* Or stop conflicting container:

  ```bash
  podman ps
  podman stop <container>
  ```

---

## 8) Healthcheck script always fails (curl to Postgres)

### ✅ Symptom

If used as a real readiness check, `healthcheck.sh` fails consistently.

### 🔎 Cause

PostgreSQL listens on **TCP** 5432, not HTTP — `curl http://db:5432` is not a valid readiness probe for Postgres.

### ✅ Fix (recommended)

Use one of:

* `pg_isready` (best for Postgres)
* `nc -z db 5432` (TCP check)
* a real DB connection test (psycopg2)

Example:

```sh id="d0q8w2"
nc -z db 5432
```

---

## ✅ Quick Verification Checklist

* DB health:

  ```bash
  podman inspect --format='{{.State.Health.Status}}' container-dependencies-lab_db_1
  ```
* App logs (retry + success):

  ```bash
  podman logs container-dependencies-lab_app_1
  ```
* Compose build/run:

  ```bash
  podman-compose up --build
  ```
* Cleanup:

  ```bash
  podman-compose down
  podman system prune -f
  ```
