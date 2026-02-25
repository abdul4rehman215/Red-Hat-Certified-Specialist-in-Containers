# 🧪 Lab 40: Case Study — Build and Deploy a Secure Flask Microservice

## 🧾 Lab Summary
This capstone-style lab packaged a **secure Flask microservice** backed by **PostgreSQL** into a containerized stack using **Podman** and **Podman Compose**. I built a Flask API with two routes:

- `/` → health/status response
- `/data` → connects to PostgreSQL and returns `SELECT version();`

Then I:
- built a container image for the Flask app using a **Containerfile**
- deployed a multi-container stack (Flask + PostgreSQL) with **persistent storage**
- used **Podman secrets** to handle database credentials
- applied security practices including **image scanning** and **trust/signing policy configuration**
- tested logs, recovery (DB stop/start), and validated the service remained functional

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Containerize a Flask application using Podman
- Create and manage a PostgreSQL container with persistent storage
- Deploy a multi-container application stack using Podman Compose
- Implement security best practices including image scanning and signing
- Test application recovery and log management

---

## ✅ Prerequisites
- Podman + podman-compose installed
- Python + Flask basics
- PostgreSQL basics
- Internet access to pull images

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Podman | `3.4.4` |
| podman-compose | `1.0.6` |
| Python | `3.6` (venv used for local dev) |
| App | Flask microservice |
| DB | PostgreSQL 13 |
| Security | `podman scan`, trust policy + signing workflow |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab40-secure-flask-microservice/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── app.py
├── requirements.txt
├── Containerfile
├── init.sql
├── db_password.txt
└── podman-compose.yml
````

> 🔐 **Security note for a real GitHub repo**
>
> * `db_password.txt` contains a real secret from the lab flow.
> * In a public repo, this should be **excluded** via `.gitignore` or replaced with a sample like `db_password.example.txt`.
> * For this lab portfolio, it’s captured to match the executed output.

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Create Flask Application

* Created a local Python virtual environment
* Installed dependencies (`flask`, `psycopg2-binary`)
* Built Flask app:

  * reads DB config from env vars (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`)
  * `/data` connects to DB and runs `SELECT version();`
* Generated `requirements.txt` via `pip freeze`

---

### ✅ Task 2: Containerize Flask App

* Wrote a `Containerfile` based on `python:3.9-slim`
* Installed dependencies inside the image using `requirements.txt`
* Exposed port `5000`
* Built image:

  * `podman build -t flask-app .`

---

### ✅ Task 3: Configure PostgreSQL + Secrets

* Created an `init.sql` schema script (prepared for initialization)
* Created DB password secret:

  * `db_password.txt`
  * `podman secret create db_password db_password.txt`

> Note: `init.sql` was prepared but not mounted into `/docker-entrypoint-initdb.d/` in the compose stack, so it is not auto-applied in this lab run.

---

### ✅ Task 4: Deploy Stack with Podman Compose

* Created `podman-compose.yml` to run:

  * `web` (Flask app)
  * `db` (Postgres 13)
* Configured:

  * persistent volume `pgdata`
  * shared bridge network `app-network`
  * secrets mount into both services

**Practical adjustment used in the lab run:**

* App code reads `DB_PASS` (not `DB_PASS_FILE`)
* Compose still mounts the secret and sets `DB_PASS_FILE`, but also passes `DB_PASS` so the app can connect successfully while still demonstrating secret usage.

---

### ✅ Task 5: Security Practices

* Scanned images:

  * `podman scan flask-app`
  * `podman scan postgres:13`
* Set trust policy and performed a signed push:

  * set default trust to reject
  * set docker.io trust key
  * pushed `localhost/flask-app:latest`

---

### ✅ Task 6: Testing, Logs, and Recovery

* Verified service endpoints:

  * `curl http://localhost:5000`
  * `curl http://localhost:5000/data`
* Viewed live logs from the Flask container
* Performed recovery test:

  * stopped DB container
  * started DB container
  * confirmed `/data` works again

---

## ✅ Verification & Results

* Flask endpoint `/` returns:

  * `{"message":"Flask Microservice Running","status":"OK"}`
* Flask endpoint `/data` returns PostgreSQL version string
* Containers confirmed running via `podman ps`
* Logs show Flask server requests for `/` and `/data`
* Recovery test succeeded (DB restart did not break `/data`)
* Security scan results recorded for both images
* Trust policy commands executed and push stored signatures

---

## 🧠 What I Learned

* How to package Python Flask apps into container images with reproducible dependency installs
* How to deploy multi-container stacks with Podman Compose, networks, and persistent storage
* How to use secrets in Podman workflows and pass DB config safely
* How to scan images for known vulnerabilities and interpret outputs
* How to validate microservice recovery using stop/start of dependent services
* How to use container logs for troubleshooting and operational verification

---

## 🔐 Security Relevance

This lab demonstrates microservice security basics:

* vulnerability awareness (`podman scan`)
* supply-chain controls (trust policy + signature flow)
* secret handling patterns for DB credentials
* recovery testing (resilience)
* log collection and validation

---

## ✅ Cleanup

* Brought down compose stack
* Removed secret
* Removed image
* Deactivated venv

✅ Lab completed successfully on a cloud lab environment.

