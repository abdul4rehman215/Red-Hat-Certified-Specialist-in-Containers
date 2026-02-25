# 🛠️ Troubleshooting Guide — Lab 16: Compose Basics (Podman Compose)

> This document covers common issues when installing podman-compose, starting services, handling port conflicts, and cleaning up networks/volumes.

---

## 1) `podman-compose: command not found`
### ✅ Symptom
Running `podman-compose --version` returns:
- command not found

### 📌 Likely Cause
Podman Compose is not installed, or it’s installed under `~/.local/bin` which is not in PATH.

### ✅ Fix
1) Install:
```bash
pip3 install --user podman-compose
````

2. Add to PATH for current session:

```bash id="b1q7eg"
export PATH=$PATH:/home/toor/.local/bin
```

3. Verify:

```bash id="8e3t1h"
podman-compose --version
```

---

## 2) YAML indentation errors / compose parsing fails

### ✅ Symptom

podman-compose fails with YAML parse errors.

### 📌 Likely Cause

Incorrect indentation (YAML is whitespace-sensitive).

### ✅ Fix

Validate file:

```bash id="r2t0u2"
cat podman-compose.yml
```

Ensure correct structure:

```yaml
version: "3.8"
services:
  web:
    image: docker.io/nginx:alpine
```

---

## 3) Port conflicts on 8080

### ✅ Symptom

`podman-compose up -d` fails because 8080 is already bound.

### ✅ Fix

1. Check if port is used:

```bash id="r8z7j7"
ss -tulnp | grep 8080 || true
```

2. Stop/remove conflicting container:

```bash id="o6p1wb"
podman ps -a
podman stop <container_name>
podman rm <container_name>
```

3. Or change host port in YAML:

```yaml
ports:
  - "8081:80"
```

---

## 4) Web service returns default Nginx page instead of your custom HTML

### ✅ Symptom

You see default Nginx welcome page.

### 📌 Likely Cause

Bind mount path wrong or file missing.

### ✅ Fix

1. Confirm `html/index.html` exists:

```bash id="v9o4ne"
ls -l html
cat html/index.html
```

2. Confirm volume mapping is correct:

```bash id="k4k5qz"
podman inspect compose-lab_web_1 | grep -A 10 Mounts
```

---

## 5) PostgreSQL container exits or restarts

### ✅ Symptom

`compose-lab_db_1` not running.

### 📌 Likely Cause

* insufficient disk
* permission issues on named volume (rare)
* bad env vars

### ✅ Fix

1. Check logs:

```bash id="w5k2l3"
podman logs compose-lab_db_1 | tail -n 80
```

2. Verify container status:

```bash id="m4m7gr"
podman ps -a
```

---

## 6) `podman-compose down` doesn’t remove everything

### ✅ Symptom

Containers are removed, but volume remains.

### ✅ Explanation

Named volumes commonly persist to prevent accidental data loss.

### ✅ Fix

List volumes:

```bash id="t7o5or"
podman volume ls | grep compose-lab || true
```

Remove volume if you want a full cleanup:

```bash id="p7k3x6"
podman volume rm compose-lab_db_data
```

---

## 7) Network removal errors

### ✅ Symptom

Network cannot be removed because containers still attached.

### ✅ Fix

Ensure all containers are stopped/removed first:

```bash id="b0m2u1"
podman ps -a
podman rm -f compose-lab_web_1 compose-lab_db_1
podman network rm compose-lab_default
```

---

## ✅ Quick Verification Checklist

* podman-compose installed:

  * `podman-compose --version`
* services running:

  * `podman ps`
* web reachable:

  * `curl http://localhost:8080`
* db reachable:

  * `podman exec -it compose-lab_db_1 psql -U postgres`
* cleanup verified:

  * `podman ps -a`
  * `podman volume ls | grep compose-lab || true`
