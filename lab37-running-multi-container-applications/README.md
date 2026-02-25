# 🧪 Lab 37: Running Multi-Container Applications

## 🧾 Lab Summary
This lab focused on building and operating a **multi-container application stack** using Podman. I deployed a 3-service stack using **podman-compose** (Python web service, Redis cache, PostgreSQL database), configured **volumes** and a custom **bridge network**, then introduced **secrets management** for the database password using a Podman external secret and `POSTGRES_PASSWORD_FILE`.

To align with container orchestration workflows, I generated a **Kubernetes YAML** manifest from the running containers using `podman kube generate` and then deployed the same stack using `podman play kube`. Finally, I cleaned up pods, containers, volumes, and secrets.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Define and deploy multi-container applications using `podman-compose`
- Configure volumes, networks, and secrets for multi-container applications
- Deploy applications using Kubernetes YAML with `podman play kube`

---

## ✅ Prerequisites
- Podman installed (v3.0+)
- `podman-compose` installed
- Basic Docker/Podman concepts
- Basic YAML familiarity

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Podman | `3.4.4` |
| podman-compose | `1.0.6` |
| Stack | Python web + Redis + Postgres |
| Orchestration | `podman kube generate`, `podman play kube` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab37-running-multi-container-applications/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── docker-compose.yml
├── k8s-deployment.yaml
└── app/
```

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Attempted `systemctl start podman` (failed because Podman is daemonless and no unit exists in this environment)
* Verified versions: `podman` and `podman-compose`

---

### ✅ Task 1: Deploy Multi-Container Stack with `podman-compose`

* Created project directory + `app/` folder (required for bind mount `./app:/app`)
* Wrote `docker-compose.yml` defining:

  * `web` (python http server on port 8000)
  * `redis` (port 6379 + named volume)
  * `db` (postgres + named volume)
  * custom network `app-network` (bridge)
* Deployed stack:

  * `podman-compose up -d`
* Verified:

  * all containers running via `podman ps`
  * web response via `curl http://localhost:8000`

---

### ✅ Task 2: Add Secrets Management (Postgres password via secret file)

* Created secret:

  * `echo "supersecret" | podman secret create db_password -`
* Updated compose to mount secret into `db` service:

  * `secrets: [db_password]`
  * `POSTGRES_PASSWORD_FILE=/run/secrets/db_password`
  * `external: true`
* Redeployed stack:

  * `podman-compose down`
  * `podman-compose up -d`

---

### ✅ Task 3: Kubernetes YAML + `podman play kube`

* Generated Kubernetes YAML from running containers:

  * Used actual container names (`multi-container-lab_web_1`, etc.)
  * Output file: `k8s-deployment.yaml`
* Avoided port conflicts by stopping compose first:

  * `podman-compose down`
* Deployed Kubernetes YAML:

  * `podman play kube k8s-deployment.yaml`
* Verified:

  * pod running: `podman pod ps`
  * containers running: `podman ps`

---

### ✅ Cleanup

* Stopped compose stack and removed containers
* Removed pod created by play kube
* Removed leftover containers
* Pruned volumes
* Removed secret (`db_password`)

---

## ✅ Verification & Validation

* `podman-compose up -d` created:

  * network `multi-container-lab_app-network`
  * volumes `multi-container-lab_redis-data`, `multi-container-lab_postgres-data`
  * containers for web/redis/db
* `podman ps` confirmed all containers up
* `curl -I http://localhost:8000` returned `HTTP/1.0 200 OK`
* Secret-based DB config deployed successfully (compose re-run showed `--secret db_password`)
* `podman kube generate` created `k8s-deployment.yaml`
* `podman play kube` created:

  * a Pod
  * containers inside it
  * services
* `podman pod ps` confirmed pod running

---

## 🧠 What I Learned

* `podman-compose` simplifies local multi-container orchestration with networks + volumes
* Secrets can be injected using Podman’s secret store and referenced as external secrets in compose
* Real-world deployments require thinking about port conflicts (compose vs play kube)
* `podman kube generate` bridges local containers into Kubernetes YAML
* `podman play kube` enables Kubernetes-style workflows locally without a full cluster

---

## 💡 Why This Matters

Multi-container patterns are the norm in production (web + cache + database). This lab demonstrates:

* local orchestration fundamentals
* secret handling patterns for databases
* a path toward Kubernetes/OpenShift deployments

---

## ✅ Result

* Deployed a working multi-container stack using `podman-compose`
* Added secrets handling for PostgreSQL credentials using `POSTGRES_PASSWORD_FILE`
* Generated Kubernetes YAML from running containers
* Successfully deployed that YAML using `podman play kube`
* Cleaned up containers, pods, volumes, and secrets

✅ Lab completed successfully on a cloud lab environment.
