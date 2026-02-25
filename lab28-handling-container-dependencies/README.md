# 🧪 Lab 28: Handling Container Dependencies

## 🧾 Lab Summary
This lab focused on building **reliable startup flows** for containerized applications where one service must wait for another (e.g., web/app depends on database). I implemented dependency handling in three layers:

1. **Compose startup ordering** using `depends_on` with `condition: service_healthy`
2. **Health checks** (built-in for PostgreSQL using `pg_isready`) and a simple custom script example
3. **Retry logic in an entrypoint script** that waits for a database port to be reachable before running the main application

To validate dependency handling, I built a small Python app container that connects to PostgreSQL using `psycopg2`, and confirmed it waits until the DB becomes available before connecting successfully.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Implement `depends_on` in Compose files to manage service startup order
- Write simple health check scripts for container services
- Implement retry logic in container entrypoints
- Test service connectivity between dependent containers

---

## ✅ Prerequisites
- Podman installed (Podman preferred)
- podman-compose installed
- Basic YAML knowledge
- Terminal access + editor (nano)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Podman | `3.4.4` |
| podman-compose | `1.0.6` |
| Services | PostgreSQL, Nginx, Python app |
| Dependency Tools | `depends_on`, healthchecks, entrypoint retry |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab28-handling-container-dependencies/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
├── healthcheck.sh
└── app.py
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Setup

* Created a dedicated working folder
* Verified Podman + podman-compose versions

---

### ✅ Task 1: `depends_on` with health checks (PostgreSQL → Nginx)

* Created an initial Compose file with:

  * `db` (postgres:15-alpine)
  * `web` (nginx:alpine)
* Added **db healthcheck** using:

  * `pg_isready -U postgres`
* Configured:

  * `depends_on: condition: service_healthy`
* Started services with `podman-compose up -d`
* Verified DB health status:

  * `podman inspect --format='{{.State.Health.Status}}' ...` → `healthy`

> Real-world note: `depends_on` health conditions can vary across implementations, so verifying actual health status is important.

---

### ✅ Task 2: Health check script example (learning artifact)

* Created `healthcheck.sh` as a simple example script.
* Marked executable.
* Initially added an `app` service that mounted `healthcheck.sh` and used it as a container healthcheck.

> Note (realistic): the example script uses `curl http://db:5432` which is not a true HTTP endpoint for Postgres (5432 is raw TCP). This script is kept as a learning artifact from the lab text, while the practical readiness check is implemented correctly in Task 3 using `nc -z`.

---

### ✅ Task 3: Retry logic in entrypoint (real readiness check)

* Created `entrypoint.sh` with retry loop:

  * tries `nc -z db 5432`
  * prints attempts
  * exits non-zero if DB never becomes reachable
* Built a custom app image with:

  * `netcat-openbsd` for `nc`
  * `psycopg2-binary` for PostgreSQL connection testing

---

### ✅ Task 4: Service connectivity test (Python → PostgreSQL)

* Created `app.py` to connect to Postgres using:

  * host `db`
  * default database `postgres`
  * user `postgres`
  * password via `POSTGRES_PASSWORD`
* Updated compose so:

  * `app` builds from local Dockerfile
  * `app` depends on `db` healthy
  * `POSTGRES_PASSWORD=example` passed to app
* Ran:

  * `podman-compose up --build`
* Verified expected behavior:

  * app waits for DB
  * app connects successfully
  * container exits with code 0

---

## ✅ Verification & Validation

* `db` container health = `healthy`
* `web` started after DB health check passed
* `app` prints retry messages and only connects once DB is reachable:

  * `Waiting for database... Attempt ...`
  * `Database is ready!`
  * `Successfully connected to database!`
* Compose build successfully installed dependencies:

  * `netcat-openbsd`, `postgresql-libs`, `psycopg2-binary`

---

## 🧠 What I Learned

* Startup order alone isn’t enough — readiness must be verified
* Healthchecks provide a reliable readiness mechanism for orchestration
* Entrypoint retry loops are a strong pattern for real services (especially in distributed systems)
* Minimal base images often lack tools (`nc`, Python DB drivers), so dependencies must be installed explicitly
* Testing connectivity between containers validates DNS/service naming and networking

---

## 💡 Why This Matters

Real applications commonly fail due to:

* db not ready yet
* cache not reachable
* services starting too fast and crashing

Handling dependencies properly improves:

* uptime
* reliability
* recovery behavior
* deployment success in Kubernetes/OpenShift pipelines

---

## ✅ Result

* Implemented dependency ordering via `depends_on` and health checks
* Created a healthcheck script example (learning artifact)
* Built retry logic entrypoint that waits for DB readiness
* Verified app-to-db connectivity with a real Python DB connection test
* Cleaned up containers and reclaimed resources

✅ Lab completed successfully on a cloud lab environment.

