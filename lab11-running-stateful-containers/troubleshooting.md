# 🛠️ Troubleshooting Guide — Lab 11: Running Stateful Containers (MySQL + PostgreSQL)

> This document covers common issues when running database containers with persistent storage (bind mounts), verifying readiness, handling permissions, and resolving port conflicts.

---

## 1) MySQL container starts but connection fails
### ✅ Symptom
- `podman exec -it mysql-db mysql ...` fails
- or MySQL client returns connection errors

### 📌 Likely Cause
MySQL is still initializing on first run (common). Database may take 10–30 seconds or more depending on resources.

### ✅ Fix
Check logs for readiness:
```bash
podman logs mysql-db | tail -n 20
````

Look for:

* `ready for connections`

Then retry connection.

---

## 2) MySQL container exits immediately after starting

### ✅ Symptom

* `podman ps` shows container stopped
* `podman ps -a` shows Exited state

### 📌 Likely Cause

* Volume mount permission issue
* Missing/invalid env vars on first initialization
* Data directory corruption (rare in labs)

### ✅ Fix

1. Check logs:

```bash id="uh0eiy"
podman logs mysql-db | tail -n 100
```

2. Verify mounted directory exists:

```bash id="9m1s8n"
ls -ld mysql-data
```

3. Fix ownership if needed:

```bash id="v4h8nc"
sudo chown -R 1001:1001 mysql-data/
```

Then recreate container.

---

## 3) Permission denied on mounted database directory

### ✅ Symptom

Logs show:

* permission denied
* cannot write to /var/lib/mysql
* init fails

### 📌 Likely Cause

The MySQL process inside the container runs with a UID/GID that cannot write to the host-mounted directory.

### ✅ Fix

Change ownership:

```bash id="8h0lq5"
sudo chown -R 1001:1001 mysql-data/
```

Confirm permissions:

```bash id="b0t3j8"
ls -ld mysql-data
```

---

## 4) Port conflict on 3306 (MySQL) or 5432 (PostgreSQL)

### ✅ Symptom

Container fails to start and Podman reports port binding errors.

### 📌 Likely Cause

Another service/container is already using the port.

### ✅ Fix

Check who is listening:

```bash id="j1gm0h"
ss -tulnp | grep 3306
ss -tulnp | grep 5432
```

Stop/remove conflicting container:

```bash id="1c4xmm"
podman ps
podman stop <container_name>
podman rm <container_name>
```

Or map to a different host port:

```bash id="f6b4pe"
podman run -d -p 3307:3306 docker.io/library/mysql:8.0
```

---

## 5) Recreated MySQL container but user/database missing

### ✅ Symptom

After recreation, `testuser` or `testdb` does not exist.

### 📌 Likely Cause

* The data directory was empty (fresh init) and the recreation command omitted creation env vars
* Or volume mount path changed (pointing to a different directory)

### ✅ Fix

1. Ensure you are mounting the same directory:

```bash id="p0x9r2"
pwd
ls -ld mysql-data
```

2. For a fresh init, include full init variables:

```bash id="4nq8aq"
podman run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=redhat123 \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=user123 \
  -v $(pwd)/mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  docker.io/library/mysql:8.0
```

---

## 6) PostgreSQL container starts but psql commands fail

### ✅ Symptom

`psql` returns authentication or connection errors.

### 📌 Likely Cause

* Postgres still initializing
* Wrong user/db settings
* Password not set correctly

### ✅ Fix

Check readiness:

```bash id="gdzpkr"
podman logs postgres-db | tail -n 30
```

Look for:

* `database system is ready to accept connections`

Then retry psql command.

---

## 7) SQL command fails due to quoting/newlines

### ✅ Symptom

Shell breaks SQL command into multiple lines and `psql -c` fails.

### 📌 Likely Cause

Multiline SQL not properly quoted.

### ✅ Fix

Use a single-line SQL string:

```bash id="pv1t6a"
podman exec -it postgres-db psql -U testuser -d testdb -c "CREATE TABLE lab_data (id SERIAL PRIMARY KEY, message TEXT); INSERT INTO lab_data (message) VALUES ('Postgres persistent data');"
```

---

## ✅ Quick Verification Checklist

* Containers running:

  * `podman ps -a`
* MySQL ready:

  * `podman logs mysql-db | tail -n 20`
* Persistent data exists:

  * `podman exec -it mysql-db mysql ... -e "SELECT * FROM lab_data;"`
* Ports available:

  * `ss -tulnp | grep 3306` / `5432`
* Postgres ready:

  * `podman logs postgres-db | tail -n 30`
* Postgres data exists:

  * `podman exec -it postgres-db psql ... -c "SELECT * FROM lab_data;"`
