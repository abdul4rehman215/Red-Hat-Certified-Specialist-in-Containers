# 🧪 Lab 11: Running Stateful Containers (MySQL + PostgreSQL)

## 📌 Lab Summary
This lab demonstrates how to run **stateful database containers** with persistent storage using Podman. It covers:
- Running **MySQL 8.0** with a host-mounted data directory
- Creating a table + inserting data
- Removing and recreating the container while keeping the same volume mount
- Verifying that data **persists across container lifecycles**
- (Optional) Doing the same concept with **PostgreSQL 13**

> 🔒 Security Note (repo-safe): Passwords shown in the original lab were used only in the training environment.  
> For this GitHub documentation, credentials are **sanitized** as placeholders like `<MYSQL_ROOT_PASSWORD>`.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Implement persistent storage for stateful containers using volume mounts
- Run MySQL and PostgreSQL containers with host directory persistence
- Verify data persistence after container stop/remove/recreate
- Troubleshoot common issues (startup time, permissions, port conflicts)

---

## ✅ Prerequisites
- Podman installed (recommended for OpenShift alignment)
- Basic command line proficiency
- 2GB+ free disk space
- Internet access to pull images (`mysql:8.0`, `postgres:13`)

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman Version | 4.9.3 |
| Containers | `mysql-db`, `postgres-db` |
| Images | `docker.io/library/mysql:8.0`, `docker.io/library/postgres:13` |
| Persistence Method | Bind mounts to host directories (`mysql-data/`, `pg-data/`) |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab11-running-stateful-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Run MySQL with Persistent Storage

* Created a working directory: `~/stateful-lab`
* Created a host directory: `mysql-data/`
* Started `mysql:8.0` with environment variables for initialization and mounted storage:

  * Host: `$(pwd)/mysql-data` → Container: `/var/lib/mysql`
* Verified container status and readiness
* Connected to MySQL and created a table + inserted persistent data

### ✅ Task 2: Verify MySQL Data Persistence

* Stopped and removed `mysql-db`
* Recreated `mysql-db` using the **same mounted directory**
* Verified the table and inserted record still exist

### ✅ Task 3: (Optional) PostgreSQL Persistent Storage

* Created a host directory: `pg-data/`
* Started `postgres:13` with a mounted storage directory:

  * Host: `$(pwd)/pg-data` → Container: `/var/lib/postgresql/data`
* Created a table + inserted data
* Verified stored data using SELECT

### ✅ Troubleshooting & Validation Checks

* Checked container logs for “ready for connections”
* Resolved potential permission issues by adjusting host directory ownership
* Verified port bindings (e.g., 3306) using `ss`

---

## ✅ Verification & Validation

* MySQL container started and reached ready state:

  * validated via `podman logs mysql-db`
* Database operations verified:

  * CREATE TABLE / INSERT / SELECT returned expected results
* Persistence confirmed:

  * After stop/remove/recreate, the same data remained accessible
* PostgreSQL optional path validated:

  * `psql` commands created and retrieved persisted data

---

## 🧠 What I Learned

* Stateful workloads require persistent storage; without `-v`, data is lost on container removal
* Host bind mounts are a simple way to persist DB data in lab environments
* MySQL/Postgres initialization may take time; logs help confirm readiness
* In rootless environments, port forwarding may be handled by helper processes (e.g., `rootlessport`)
* Permissions and ownership of host directories are critical for database containers

---

## 🌍 Why This Matters

Databases are the most common **stateful workloads** in containerized environments. Understanding persistence patterns is essential for:

* containerized application development
* OpenShift/Kubernetes stateful deployments
* backups and disaster recovery planning
* secure storage practices and access controls

---

## ✅ Result

* Successfully ran MySQL and PostgreSQL as stateful containers using persistent storage
* Verified data survival across container lifecycle operations
* Practiced essential troubleshooting methods for DB containers

---

## ✅ Conclusion

This lab demonstrated how persistent storage enables reliable stateful container deployments. By mounting host directories into MySQL and PostgreSQL containers, I verified that database data remains intact even after container removal and recreation—an essential foundation for stateful workloads in OpenShift/Kubernetes environments.
