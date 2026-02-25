
# 🛠️ Troubleshooting Guide — Lab 12: Backup and Restore Data (MySQL)

> This document covers common issues when creating dumps, storing them on volumes, and restoring them into a new database container.

---

## 1) MySQL container is running but connection fails
### ✅ Symptom
- MySQL client fails to connect
- Errors appear if you try to connect immediately after starting container

### 📌 Likely Cause
MySQL is still initializing.

### ✅ Fix
Check logs and wait for readiness:
```bash
podman logs mysql-db | tail -n 20
````

Look for:

* `ready for connections`

Then connect again.

---

## 2) `mysqldump` creates an empty or incomplete file

### ✅ Symptom

* `testdb_dump.sql` exists but is very small or missing tables/data

### 📌 Likely Cause

* Wrong database name
* Authentication failure
* Dump command error not noticed

### ✅ Fix

1. Confirm database exists:

```bash id="j4x2w0"
podman exec -it mysql-db mysql -u root -predhat -e "SHOW DATABASES;"
```

2. Dump again:

```bash id="9z2g6f"
podman exec mysql-db /usr/bin/mysqldump -u root -predhat testdb > testdb_dump.sql
ls -l testdb_dump.sql
```

---

## 3) Dump file is created but restore fails with SQL errors

### ✅ Symptom

Restore command returns errors (schema conflicts, missing DB, etc.)

### 📌 Likely Cause

* Restoring into wrong database
* Target database not created
* Trying to restore same schema into an already-populated DB

### ✅ Fix

Ensure target DB exists (created by env vars or manually):

```bash id="2x1fny"
podman exec -it mysql-restore mysql -u root -predhat -e "SHOW DATABASES;"
```

Restore into correct DB:

```bash id="e8s3xu"
podman exec -i mysql-restore mysql -u root -predhat testdb < testdb_dump.sql
```

---

## 4) Restore appears to do nothing (no output)

### ✅ Symptom

No output after running restore command.

### 📌 Likely Cause

This is normal—successful imports often produce no output unless errors occur.

### ✅ Fix

Verify by querying:

```bash id="y2n2c0"
podman exec -it mysql-restore mysql -u root -predhat -e "SELECT * FROM testdb.employees;"
```

---

## 5) Confusion about `>` and `<` redirection in podman commands

### ✅ Symptom

Users expect `>` or `<` to happen inside container.

### 📌 Key Concept

Redirection is handled by the **host shell**, not the container.

* `podman exec ... > file.sql` writes stdout to host file
* `podman exec -i ... < file.sql` feeds host file into container stdin

### ✅ Fix

Use exactly:

```bash id="q9w1rq"
podman exec mysql-db /usr/bin/mysqldump -u root -predhat testdb > testdb_dump.sql
podman exec -i mysql-restore mysql -u root -predhat testdb < testdb_dump.sql
```

---

## 6) Dump not found inside volume after copy

### ✅ Symptom

`ls /backup/mysql` inside a volume-mounted container shows empty.

### 📌 Likely Cause

* Directory not created in volume
* Copy target path wrong
* Temp container removed before copy completed (rare)

### ✅ Fix

1. Create directory structure:

```bash id="r0t5ke"
podman run -it --rm -v backup-vol:/backup alpine sh
# mkdir -p /backup/mysql
# exit
```

2. Copy using a temp container:

```bash id="o61q1a"
podman create --name temp -v backup-vol:/backup alpine
podman cp testdb_dump.sql temp:/backup/mysql/
podman rm temp
```

3. Verify:

```bash id="7d3n6w"
podman run --rm -v backup-vol:/backup alpine ls -l /backup/mysql
```

---

## 7) Confusion copying from volume back to host

### ✅ Symptom

Trying to copy from a short-lived container to `/tmp` and expecting it on host.

### 📌 Likely Cause

Copying inside a `--rm` container writes only inside that container filesystem and is deleted when container exits.

### ✅ Fix (correct approach)

Use `podman cp` from a volume-mounted temp container:

```bash id="b4w8o9"
podman create --name temp -v backup-vol:/backup alpine
podman cp temp:/backup/mysql/testdb_dump.sql ./testdb_dump.sql
podman rm temp
```

---

## 8) Volume permission issues (SELinux environments)

### ✅ Symptom

Access denied when writing into mounted volume.

### 📌 Likely Cause

SELinux labels required on some systems.

### ✅ Fix

Use `:Z` (private relabel) when mounting:

```bash id="5e7p4k"
podman create --name temp -v backup-vol:/backup:Z alpine
```

---

## ✅ Quick Verification Checklist

* Dump created:

  * `ls -l testdb_dump.sql`
  * `head -n 5 testdb_dump.sql`
* Dump stored in volume:

  * `podman run --rm -v backup-vol:/backup alpine ls -l /backup/mysql`
* Restore completed:

  * `podman exec -i mysql-restore mysql ... < testdb_dump.sql`
* Data verified:

  * `podman exec mysql-restore mysql ... -e "SELECT * FROM testdb.employees;"`
