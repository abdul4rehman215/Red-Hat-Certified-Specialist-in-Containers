# 🧪 Lab 17: Compose with Dependencies (depends_on + scaling + service connectivity)

## 📌 Lab Summary
This lab demonstrates how to orchestrate multi-service apps with **Compose**, focusing on:
- `depends_on` for service startup ordering
- scaling service replicas
- validating inter-service connectivity using a practical **Flask + Redis** example

The lab was executed using `docker-compose` style commands as provided in the lab text. The same Compose concepts apply to Podman Compose as well, but the commands below reflect what was executed.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Use `depends_on` to start services in dependency order
- Scale a service to multiple replicas and verify they run independently
- Build a simple Flask app that connects to Redis over the Compose network
- Validate service-to-service connectivity with functional tests and health checks

---

## ✅ Prerequisites
- Docker + Docker Compose installed (as per lab text)
- Basic Docker/Compose concepts and terminal usage
- Internet access to pull base images
- Basic YAML familiarity

> Note: `depends_on` controls *start order* but does **not** guarantee the dependency is "ready" to accept connections.

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu (cloud lab environment) |
| Compose CLI | `docker-compose` |
| Services Used | `redis`, `nginx`, later `flask(webapp)` |
| Ports Used | `6379` (Redis), `8080` (Nginx), `5000` (Flask) |
| Working Directory | `~/compose-dependencies-lab` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab17-compose-with-dependencies/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── docker-compose.depends.yml
    ├── docker-compose.scale.yml
    ├── docker-compose.flask.yml
    ├── app.py
    └── Dockerfile
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Using `depends_on`

* Created `docker-compose.depends.yml` with:

  * `redis` service (published 6379)
  * `webapp` service (nginx:alpine, published 8080)
  * `webapp` depends on `redis`
* Started services with `docker-compose up -d`
* Verified both services were running with `docker-compose ps`
* Verified Nginx was reachable on port 8080 (HTTP 200)

### ✅ Task 2: Scaling Service Replicas

* Updated compose configuration for scaling (`docker-compose.scale.yml`)
* Scaled `webapp` to 3 replicas:

  * `docker-compose up -d --scale webapp=3`
* Verified multiple replicas are running with `docker-compose ps`
* Verified each replica has a different hostname (realistic check)

> Real-world note applied during lab: publishing the same host port for multiple replicas causes conflicts.
> To keep scaling successful, the published port for webapp replicas was removed in the scaling variant.

### ✅ Task 3: Test Inter-Service Connectivity (Flask + Redis)

* Created a Flask app (`app.py`) that increments a Redis counter (`hits`)
* Created a `Dockerfile` to build the Flask image
* Updated compose config (`docker-compose.flask.yml`) to:

  * run `redis`
  * build `webapp` from local Dockerfile
  * publish Flask on `5000:5000`
  * set `REDIS_HOST=redis`
  * use `depends_on: redis`
* Started stack and validated:

  * `curl http://localhost:5000` increments counter on every request
* Additional connectivity checks:

  * `redis-cli ping` inside redis container → `PONG`
  * python redis ping inside webapp container → `True`

### 🧹 Cleanup

* Removed containers and network:

  * `docker-compose down`
* Removed locally built image (optional):

  * `docker rmi compose-dependencies-lab-webapp:latest`

---

## ✅ Verification & Validation

* `docker-compose ps` showed expected containers per stage
* Nginx returned HTTP 200 on port 8080 during Task 1
* Scaling created 3 running `webapp` replicas during Task 2
* Flask counter incremented correctly (1 → 2 → 3) proving Redis connectivity
* `docker-compose logs` confirmed Flask was serving and receiving requests
* `redis-cli ping` returned `PONG`

---

## 🧠 What I Learned

* `depends_on` ensures start ordering, but readiness still needs checks (logs/healthchecks)
* Scaling services requires avoiding conflicting host port mappings
* Compose service names become internal DNS names (e.g., `redis` reachable as hostname `redis`)
* A small app-level functional test (counter increment) is a strong way to validate connectivity

---

## 🌍 Why This Matters

Most production apps are multi-service:

* web + cache/db
* worker queues + databases
* microservices with internal discovery

Compose teaches the fundamentals of:

* dependency ordering
* service discovery
* repeatable environment setup
  which maps directly to Kubernetes/OpenShift patterns.

---

## ✅ Result

* Orchestrated multi-service stacks using Compose
* Validated dependency behavior and scaling
* Proved inter-service connectivity with a working Flask + Redis counter app

---

## ✅ Conclusion

This lab provided a practical workflow for composing multi-container apps: using `depends_on`, scaling replicas safely, and validating service-to-service communication using realistic tests and logs.
