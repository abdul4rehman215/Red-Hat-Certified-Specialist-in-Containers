# 🧪 Lab 12: Backup and Restore Data (MySQL Dumps + Volumes)

## 📌 Lab Summary
This lab demonstrates a practical backup and restore workflow for **stateful containers** using MySQL:
- Create a MySQL database container
- Insert sample data
- Generate a database dump (`mysqldump`) from inside the container
- Store the dump on a **persistent Podman volume**
- Restore the dump into a new MySQL container
- Verify restored data

This models real-world operational needs: backups, disaster recovery testing, and data integrity maintenance for containerized databases.

> 🔒 Security Note (repo-safe): Credentials shown in the training environment are not production-safe.  
> Use strong passwords and secrets management in real deployments.  
> *(This lab output includes passwords as executed in the training VM.)*

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Implement backup strategies for stateful containers
- Perform database dumps inside containers
- Store dumps on persistent volumes for durability
- Restore data from SQL dump files into a fresh database container
- Validate restored data using SQL queries

---

## ✅ Prerequisites
- Podman installed (3.0+)
- Basic container understanding
- Linux VM/system access
- Internet access for pulling `mysql:8.0` and `alpine`

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman Version | 4.9.3 |
| Database | MySQL 8.0 |
| Images Used | `docker.io/library/mysql:8.0`, `alpine` |
| Backup Storage | Podman named volume (`backup-vol`) |
| Working Directory | `~/backup-lab` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab12-backup-and-restore-data/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Perform Database Dumps Inside Container

* Created and started a MySQL container (`mysql-db`) with:

  * root password + initial database + user credentials
* Waited for MySQL readiness using logs
* Inserted sample data into `testdb`:

  * created `employees` table
  * inserted two rows
* Created a SQL dump using `mysqldump`:

  * `testdb_dump.sql`

### ✅ Task 2: Store Dumps on Persistent Volumes

* Created a Podman volume `backup-vol`
* Mounted the volume in a temporary Alpine container to create a directory structure:

  * `/backup/mysql/`
* Copied `testdb_dump.sql` into the volume using `podman cp` + a temp container with the volume mounted
* Verified the dump exists inside the volume

### ✅ Task 3: Restore Data from Dumps

* Started a new MySQL container (`mysql-restore`)
* Copied the dump back from the volume into the host workspace (via temp container + `podman cp`)
* Restored the dump into `mysql-restore` using input redirection:

  * `podman exec -i mysql-restore mysql ... < testdb_dump.sql`
* Verified restore success by querying:

  * `SELECT * FROM testdb.employees;`

### 🧹 Cleanup

* Stopped and removed MySQL containers (`mysql-db`, `mysql-restore`)
* Removed the backup volume (`backup-vol`)
* Deleted local dump file (`testdb_dump.sql`)

---

## ✅ Verification & Validation

* MySQL readiness confirmed from logs:

  * `ready for connections`
* Dump file created and validated:

  * `ls -l testdb_dump.sql`
  * `head -n 5 testdb_dump.sql`
* Dump stored in volume and verified:

  * `podman run --rm -v backup-vol:/backup alpine ls -l /backup/mysql`
* Restore verified with SQL output showing original rows:

  * `John Doe`, `Jane Smith`

---

## 🧠 What I Learned

* How to generate reliable SQL dumps from within a running DB container
* How to store backups durably using Podman volumes (survives container removal)
* How to restore from a dump into a new container to validate backup integrity
* Why database readiness checks (logs) prevent “connect too early” failures
* Practical use of `podman create` + `podman cp` for volume-based file transfer

---

## 🌍 Why This Matters

Backups are critical for any stateful system. In containerized environments, a proper backup/restore workflow enables:

* disaster recovery testing
* migration between hosts
* safe upgrades and rollbacks
* compliance and audit readiness

---

## ✅ Result

* Successfully created a MySQL dump from a running container
* Stored the dump in a persistent Podman volume
* Restored the dump into a fresh MySQL container
* Verified the restored data accurately matches the original database contents

---

## ✅ Conclusion

This lab demonstrated end-to-end backup and restore operations for a containerized MySQL database using `mysqldump`, Podman volumes, and container-to-host file transfer. These are foundational operational skills for managing stateful workloads in OpenShift/Kubernetes-aligned environments.
