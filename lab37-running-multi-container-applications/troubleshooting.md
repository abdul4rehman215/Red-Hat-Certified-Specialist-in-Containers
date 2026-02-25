# 🛠️ Troubleshooting Guide — Lab 37: Running Multi-Container Applications

> This file covers common issues when deploying multi-container stacks with `podman-compose`, adding secrets, and switching to Kubernetes YAML via `podman play kube`.

---

## 1) `systemctl start podman` fails (unit not found)

### ✅ Symptom
```text
Failed to start podman.service: Unit podman.service not found.
````

### 🔎 Cause

Podman is typically **daemonless** (no persistent service required). Many environments do not provide a `podman.service` unit.

### ✅ Fix

Skip this step and just verify Podman works:

```bash id="x8h8m2"
podman --version
podman info
```

---

## 2) `podman-compose` is missing

### ✅ Symptom

```text
podman-compose: command not found
```

### 🔎 Cause

`podman-compose` is not installed or not in PATH.

### ✅ Fix

Install via pip3 and ensure `~/.local/bin` is in PATH (CentOS 7 often needs this):

```bash id="q3g0o1"
sudo yum install -y python3-pip
pip3 install --user podman-compose
export PATH=$PATH:$HOME/.local/bin
podman-compose --version
```

---

## 3) Bind mount path does not exist (`./app:/app`)

### ✅ Symptom

Compose container fails or mount behaves unexpectedly.

### 🔎 Cause

The host directory referenced in the bind mount doesn’t exist.

### ✅ Fix

Create the directory before `podman-compose up`:

```bash id="d6c7c4"
mkdir -p app
```

---

## 4) Containers start, but web service not reachable on port 8000

### ✅ Symptom

`curl http://localhost:8000` fails/timeouts.

### 🔎 Possible Causes

* Port already in use on host
* Web container not running
* Wrong port mapping
* Network restrictions

### ✅ Fixes

* Confirm containers:

  ```bash
  podman ps
  ```
* Check ports:

  ```bash
  podman port multi-container-lab_web_1
  ```
* Check logs:

  ```bash
  podman logs multi-container-lab_web_1
  ```
* Check host port usage:

  ```bash
  ss -tulnp | grep 8000
  ```

---

## 5) Postgres fails due to missing password

### ✅ Symptom

`postgres` container exits or logs show password config error.

### 🔎 Cause

PostgreSQL requires password configuration via:

* `POSTGRES_PASSWORD`, or
* `POSTGRES_PASSWORD_FILE`

### ✅ Fix

If using secrets, ensure:

* secret exists
* compose references it correctly
* env points to `/run/secrets/...`

Example:

```yaml id="p6y6z5"
db:
  image: docker.io/postgres:13-alpine
  secrets:
    - db_password
  environment:
    POSTGRES_PASSWORD_FILE: /run/secrets/db_password
secrets:
  db_password:
    external: true
```

---

## 6) Compose fails because secret is `external` and not created

### ✅ Symptom

Compose errors about missing secret.

### 🔎 Cause

`external: true` means Podman must already have the secret.

### ✅ Fix

Create it first:

```bash id="g8w8z2"
echo "supersecret" | podman secret create db_password -
podman secret ls
```

---

## 7) Port conflicts during `podman play kube`

### ✅ Symptom

`podman play kube k8s-deployment.yaml` fails because host ports are in use (8000/6379).

### 🔎 Cause

The compose stack is still running and already bound to those host ports.

### ✅ Fix

Stop compose before play kube:

```bash id="d1b2q3"
podman-compose down
podman play kube k8s-deployment.yaml
```

---

## 8) `podman kube generate` fails due to wrong identifiers

### ✅ Symptom

Generate command fails when using service names like `web redis db`.

### 🔎 Cause

`podman kube generate` expects **container names or IDs**, not compose service keys.

### ✅ Fix

Use actual container names created by podman-compose:

```bash id="g0h2k2"
podman kube generate --service -f k8s-deployment.yaml \
  multi-container-lab_web_1 multi-container-lab_redis_1 multi-container-lab_db_1
```

---

## 9) Volumes persist unwanted state between runs

### ✅ Symptom

Postgres/Redis starts with old data, or resets don’t behave as expected.

### 🔎 Cause

Named volumes persist across container recreation.

### ✅ Fixes

* Remove volumes specifically:

  ```bash
  podman volume ls
  podman volume rm multi-container-lab_redis-data multi-container-lab_postgres-data
  ```
* Or prune unused volumes (destructive):

  ```bash
  podman volume prune
  ```

---

## 10) Cleanup doesn’t remove everything (pods vs containers)

### ✅ Symptom

After `podman-compose down`, you still see resources running.

### 🔎 Cause

`podman-compose down` removes compose containers, but `podman play kube` creates pods/containers managed separately.

### ✅ Fix

Remove pods as well:

```bash id="a6x0o5"
podman pod rm -a -f
podman rm -a -f
```

---

## ✅ Quick Verification Checklist

* Compose stack running:

  ```bash
  podman-compose up -d
  podman ps
  ```
* Web responds:

  ```bash
  curl -I http://localhost:8000
  ```
* Secret exists:

  ```bash
  podman secret ls
  ```
* Generate K8s YAML:

  ```bash
  podman kube generate --service -f k8s-deployment.yaml <container-names>
  ```
* Play kube:

  ```bash
  podman-compose down
  podman play kube k8s-deployment.yaml
  podman pod ps
  podman ps
  ```
* Cleanup:

  ```bash
  podman-compose down
  podman pod rm -a -f
  podman rm -a -f
  podman volume prune
  podman secret rm db_password
  ```

