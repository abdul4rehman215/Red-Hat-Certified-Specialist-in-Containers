# 🛠️ Troubleshooting Guide — Lab 17: Compose with Dependencies (depends_on + scaling + connectivity)

> This document covers common issues around `depends_on`, scaling, and inter-service communication in Compose.

---

## 1) `depends_on` doesn’t prevent connection errors
### ✅ Symptom
The `webapp` starts but fails to connect to Redis at startup.

### 📌 Why it happens
`depends_on` only guarantees **start order**, not readiness. Redis may still be initializing.

### ✅ Fixes
- Add retry logic in the application (recommended)
- Add Compose healthchecks and wait for healthy (Compose v2 supports healthcheck; `depends_on` with condition varies by version)
- Verify readiness with logs:
```bash
docker-compose logs redis --tail=50
````

---

## 2) Scaling fails with “port is already allocated”

### ✅ Symptom

Scaling `webapp` fails when using:

* `ports: "8080:80"`

### 📌 Why it happens

Multiple replicas cannot bind the same host port.

### ✅ Fixes

* Remove host port mapping for the scaled service (used in this lab)
* Use a reverse proxy/load balancer in front (nginx/traefik)
* Assign unique host ports per instance (manual mapping)

Verify port usage:

```bash id="b7m2qp"
ss -tulnp | grep 8080 || true
```

---

## 3) Containers are running but you can’t access the service

### ✅ Symptom

`docker-compose ps` shows Up, but curl fails.

### ✅ Fix

1. Verify correct port mapping exists (Task 1 / Flask phase):

```bash
docker-compose ps
```

2. Check logs:

```bash id="p0f4cz"
docker-compose logs --tail=50 webapp
```

3. Ensure you’re curling the right port:

* Nginx phase: `http://localhost:8080`
* Flask phase: `http://localhost:5000`

---

## 4) Redis hostname not resolving inside webapp

### ✅ Symptom

App errors like:

* “Name or service not known”
* DNS resolution failures

### 📌 Likely Causes

* Wrong hostname (service name mismatch)
* Containers not on same network (rare with compose default network)
* Compose project network not created correctly

### ✅ Fix

1. Confirm the service name is `redis` in compose YAML.
2. Exec into webapp and test DNS:

```bash id="q0f8dn"
docker-compose exec webapp sh -c "getent hosts redis || ping -c 1 redis || true"
```

---

## 5) Redis service is up but not responding

### ✅ Symptom

`redis-cli ping` fails.

### ✅ Fix

Check Redis logs:

```bash id="t6m2v8"
docker-compose logs --tail=80 redis
```

Restart stack:

```bash id="h5g6m2"
docker-compose down
docker-compose up -d
```

---

## 6) Flask container builds but fails at runtime (module not found)

### ✅ Symptom

Logs show missing `flask` or `redis` module.

### 📌 Likely Cause

Dockerfile build step failed or cached incorrectly.

### ✅ Fix

Rebuild without cache:

```bash id="k0o4wr"
docker-compose build --no-cache
docker-compose up -d
```

Check logs:

```bash id="r7h2z3"
docker-compose logs --tail=80 webapp
```

---

## 7) Counter does not increment

### ✅ Symptom

`curl http://localhost:5000` always returns `1` or errors.

### ✅ Fix

1. Confirm redis is reachable:

```bash id="m8r1qs"
docker-compose exec redis redis-cli ping
```

2. Confirm webapp can talk to redis:

```bash id="z4p2yq"
docker-compose exec webapp python -c "import redis; r=redis.Redis(host='redis', port=6379); print(r.ping())"
```

3. Check webapp logs for errors:

```bash id="b0j4x1"
docker-compose logs --tail=80 webapp
```

---

## 8) Cleanup doesn’t remove built images

### ✅ Symptom

`docker-compose down` removes containers/network, but built image remains.

### ✅ Explanation

Compose doesn’t remove images unless explicitly requested.

### ✅ Fix

List and remove:

```bash id="c7m1m4"
docker images | head -20
docker rmi compose-dependencies-lab-webapp:latest
```

---

## ✅ Quick Verification Checklist

* Services running:

  * `docker-compose ps`
* Logs healthy:

  * `docker-compose logs --tail=50`
* Redis responds:

  * `docker-compose exec redis redis-cli ping` → `PONG`
* Webapp connectivity:

  * Flask counter increments on repeated curls
* Scaling works:

  * `docker-compose up -d --scale webapp=3`
* Cleanup:

  * `docker-compose down`
