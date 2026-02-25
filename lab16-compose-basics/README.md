# 🧪 Lab 16: Compose Basics (Podman Compose)

## 📌 Lab Summary
This lab introduces **Podman Compose** for running **multi-container applications** using a Compose YAML file (Docker Compose v3-style syntax). It covers:
- Installing `podman-compose` using `pip`
- Creating a `podman-compose.yml` with two services:
  - `web` (Nginx)
  - `db` (PostgreSQL)
- Starting services with `podman-compose up -d`
- Verifying containers, networking, and data volume creation
- Testing web output (mounted HTML) and connecting to PostgreSQL with `psql`
- Stopping and cleaning up with `podman-compose down`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Define multi-container applications using Podman Compose
- Configure services, ports, environment variables, and volumes in YAML
- Start and stop multi-container apps with `podman-compose up/down`
- Validate web + database services are running and reachable

---

## ✅ Prerequisites
- Podman installed (3.0+; Podman 4.x works fine)
- Python + pip available (for installing `podman-compose`)
- Basic understanding of YAML and container basics
- Linux environment (recommended)

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | 4.9.3 |
| Python | 3.12.3 |
| pip | 24.0 |
| Podman Compose | 1.0.6 (installed via `pip --user`) |
| Project Directory | `~/compose-lab` |
| Services | Nginx (web), PostgreSQL 13 (db) |
| Web Port | `8080:80` |

> Note: `pip --user` installs binaries under `~/.local/bin`, so PATH was updated for the session.

---

## 🗂️ Repository Structure (Lab Format)
```text
lab16-compose-basics/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── podman-compose.yml
    └── html/
        └── index.html
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Setup: Install and Verify Podman Compose

* Verified Podman version
* Attempted `podman-compose --version` (not found)
* Installed Podman Compose via pip:

  * `pip3 install --user podman-compose`
* Added `~/.local/bin` to PATH for current session
* Verified `podman-compose version 1.0.6`

### ✅ Task 1: Create a Basic `podman-compose.yml`

* Created project directory `compose-lab`
* Created `podman-compose.yml` defining:

  * `web` service (nginx:alpine)

    * published port `8080:80`
    * bind mount `./html` → `/usr/share/nginx/html`
  * `db` service (postgres:13)

    * environment variable: `POSTGRES_PASSWORD=example`

### ✅ Task 2: Start Multi-Container Application

* Verified port 8080 availability
* Started services in detached mode:

  * `podman-compose up -d`
* Observed Podman Compose created:

  * a project network: `compose-lab_default`
  * a named volume: `compose-lab_db_data`
* Verified containers running with `podman ps`

### ✅ Task 3: Test Application

* Created `html/index.html` and confirmed it served through Nginx:

  * `curl http://localhost:8080`
* Verified PostgreSQL service:

  * entered `psql` inside container
  * ran `SELECT version();`

### ✅ Task 4: Stop and Clean Up

* Stopped and removed containers + network:

  * `podman-compose down`
* Verified no containers remained
* Confirmed named volume may remain (common behavior)

---

## ✅ Verification & Validation

* `podman-compose up -d` successfully created network and volume
* `podman ps` showed two running containers:

  * `compose-lab_web_1`
  * `compose-lab_db_1`
* Web service returned expected HTML from host-mounted file
* PostgreSQL responded to `SELECT version();`
* `podman-compose down` removed both containers and the network successfully

---

## 🧠 What I Learned

* Podman Compose uses Docker Compose-like YAML syntax to define services
* Podman Compose automatically creates project-scoped networks and volumes
* Bind mounts are useful for serving live content in web containers
* Compose makes multi-service application lifecycle management simple:

  * up, status checks, exec, down
* `pip --user` installs binaries in `~/.local/bin`, requiring PATH updates

---

## 🌍 Why This Matters

Multi-container apps are the default in real deployments:

* web + database patterns are common
* service orchestration begins with compose and scales to Kubernetes/OpenShift
  Understanding compose fundamentals builds a bridge from single containers to full platform orchestration.

---

## ✅ Result

* Installed and configured Podman Compose
* Deployed a working multi-container web + database stack
* Verified both services and cleanly shut down the stack

---

## ✅ Conclusion

This lab provided foundational Podman Compose skills: creating a compose YAML, starting multi-container apps, validating services, and shutting everything down cleanly. These skills are a key stepping stone toward Kubernetes/OpenShift workflows.
