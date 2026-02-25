# 🛠️ Troubleshooting Guide — Lab 40: Secure Flask Microservice (Flask + PostgreSQL)

> This guide covers common issues when building and deploying a Flask + PostgreSQL stack using Podman and podman-compose, including security scanning and recovery testing.

---

## 1) Flask container starts, but `/data` fails (DB connection error)

### ✅ Symptoms
- `curl http://localhost:5000/data` returns an error (500) or the container logs show connection failures.

### 🔎 Likely Causes
- Wrong DB host/service name
- Wrong DB credentials
- DB container not ready yet
- App expects `DB_PASS`, but only `DB_PASS_FILE` was provided

### ✅ Fix
- Confirm the DB service name matches what the app uses:
  - app uses `host="db"` (via `DB_HOST=db`)
- Confirm environment variables in the running container:
```bash id="a9m1p2"
podman inspect flask-microservice-lab_web_1 --format '{{.Config.Env}}'
````

* Ensure `DB_PASS` is set (because `app.py` reads `DB_PASS`):

```yaml id="j1k9p0"
environment:
  - DB_PASS=mysecretpassword
```

* Verify DB container is running:

```bash id="x3p7w1"
podman ps
podman logs flask-microservice-lab_db_1 | tail -n 30
```

---

## 2) DB container fails to start (password / init errors)

### ✅ Symptoms

* DB container exits immediately
* Logs show initialization failures

### 🔎 Likely Causes

* Missing `POSTGRES_PASSWORD` or incorrect password file
* Secret not mounted or name mismatch
* Persistent volume contains old DB state (old password)

### ✅ Fix

* Verify secret exists and is mounted:

```bash id="g8w2t6"
podman secret ls
podman exec -it flask-microservice-lab_db_1 ls -l /run/secrets
```

* If old data is causing issues, remove the volume and recreate (destructive):

```bash id="p2z9k1"
podman-compose down
podman volume ls
podman volume rm flask-microservice-lab_pgdata
podman-compose up -d
```

---

## 3) Port conflicts (5000 or 5432 already in use)

### ✅ Symptoms

* Compose fails to start with bind errors
* You see “address already in use”

### 🔎 Diagnosis

```bash id="q7m1v4"
sudo ss -tulnp | egrep '(:5000|:5432)'
```

### ✅ Fix

* Stop the conflicting service/container, or change host ports in compose:

```yaml id="m6n4x2"
ports:
  - "5001:5000"
```

---

## 4) `podman-compose up` fails (compose not installed / PATH issues)

### ✅ Symptoms

* `podman-compose: command not found`

### 🔎 Cause

`podman-compose` may be installed in `~/.local/bin` and not in PATH.

### ✅ Fix

```bash id="v1c8p3"
pip3 install --user podman-compose
export PATH=$PATH:$HOME/.local/bin
podman-compose --version
```

---

## 5) Build fails during `pip install` inside the image

### ✅ Symptoms

* `podman build` fails at `RUN pip install ...`

### 🔎 Likely Causes

* Network/DNS issues
* Temporary PyPI availability
* Dependency version conflicts

### ✅ Fix

* Retry build
* Ensure internet connectivity works
* If needed, rebuild without cache:

```bash id="t9b2d1"
podman build --no-cache -t flask-app .
```

---

## 6) `podman scan` fails or produces no output

### ✅ Symptoms

* Scan command errors or doesn’t run in the environment

### 🔎 Likely Causes

* Scanning backend not available/configured
* Podman version limitations
* Missing scanner integration

### ✅ Fix

* Confirm Podman version:

```bash id="x1k7n2"
podman --version
```

* If scan is unsupported in your runtime, fallback is using an external scanner (Trivy, Grype) in CI/CD.

---

## 7) Trust policy blocks pulls after `default reject`

### ✅ Symptoms

After:

```bash
podman trust set -t reject default
```

future pulls may fail unless explicitly trusted.

### 🔎 Cause

Default policy now rejects untrusted images.

### ✅ Fix

* Add explicit trust exceptions for required registries/images
* Or revert trust policy based on lab environment needs
* Validate trust config with:

```bash id="v7p2m9"
podman trust show
```

---

## 8) Flask logs warn: “development server”

### ✅ Symptoms

Flask outputs:

```text id="d1k5x8"
WARNING: This is a development server. Do not use it in a production deployment.
```

### 🔎 Cause

`flask run` uses the dev server.

### ✅ Fix (production best practice)

Use `gunicorn`:

* Add `gunicorn` to requirements
* Change CMD to run gunicorn
  Example:

```dockerfile
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
```

---

## 9) Recovery test: `/data` fails right after DB restart

### ✅ Symptoms

Immediately after restarting db:

* `/data` fails temporarily

### 🔎 Cause

DB needs a few seconds to become ready; Flask app attempts connection immediately.

### ✅ Fix

* Add a DB healthcheck + retry logic in app container
* Or just retry after a short delay during manual testing:

```bash id="m2v8p1"
sleep 3
curl http://localhost:5000/data
```

---

## ✅ Quick Verification Checklist

* Containers running:

```bash id="v8k2p7"
podman ps
```

* Flask endpoints:

```bash
curl http://localhost:5000
curl http://localhost:5000/data
```

* Logs:

```bash
podman logs flask-microservice-lab_web_1 | tail -n 50
podman logs flask-microservice-lab_db_1 | tail -n 50
```

* Cleanup:

```bash
podman-compose down
podman secret rm db_password
podman rmi flask-app
```

