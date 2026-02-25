# 🧠 Interview Q&A — Lab 12: Backup and Restore Data (MySQL)

---

## 1) Why do containerized databases need a backup strategy?
Databases are stateful. If the container fails, is rebuilt, or the host is lost, data can be lost without backups. Backups enable recovery and disaster recovery testing.

---

## 2) What is `mysqldump` used for?
`mysqldump` exports a MySQL database into a SQL file containing schema and data. This dump can be used to restore the database later.

---

## 3) How did you create the MySQL container in this lab?
Using `podman run` with initialization variables:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`

---

## 4) Why did you check logs before connecting to MySQL?
MySQL needs time to initialize. Logs show when the server is:
- `ready for connections`
This prevents connection failures from trying too early.

---

## 5) What sample data did you add before taking the backup?
In database `testdb`, I created:
- a table `employees`
- inserted two rows: `John Doe`, `Jane Smith`

---

## 6) How did you create the dump file from inside the container?
By executing mysqldump inside the container and redirecting output on the host:
```bash
podman exec mysql-db /usr/bin/mysqldump -u root -predhat testdb > testdb_dump.sql
````

---

## 7) Why is redirecting to `testdb_dump.sql` done on the host side?

Because `>` is handled by the host shell. The container writes dump output to STDOUT, and the host redirects it into a file.

---

## 8) What is a Podman named volume and why use it for backups?

A named volume is Podman-managed persistent storage. Storing dumps in a volume means the backup survives container removal and is easier to manage as durable storage.

---

## 9) How did you store the dump inside a volume?

By mounting the volume into a temporary container and copying the file into it using `podman cp`:

* create temp container with volume mounted
* `podman cp testdb_dump.sql temp:/backup/mysql/`

---

## 10) Why did you use a temporary container for volume access?

Volumes are attached to containers. A temporary container provides a safe way to access/move files into and out of the volume without modifying the database container itself.

---

## 11) Why doesn’t `podman run --rm -v backup-vol:/backup alpine cp ... /tmp/` persist the file on the host?

Because `/tmp` is inside that short-lived container. Once it exits, its filesystem is deleted. That’s why `podman cp` from a volume-mounted container is the reliable approach.

---

## 12) How did you restore the dump into the new MySQL container?

Using input redirection into the mysql client running inside the container:

```bash
podman exec -i mysql-restore mysql -u root -predhat testdb < testdb_dump.sql
```

---

## 13) How did you verify restoration succeeded?

By querying the restored container:

```bash
podman exec -it mysql-restore mysql -u root -predhat -e "SELECT * FROM testdb.employees;"
```

The output showed both rows.

---

## 14) What are two common restore failure causes?

* restoring before MySQL is ready (fix: check logs)
* wrong credentials or wrong database name in the restore command

---

## 15) What is a best practice for real-world backup storage?

Store dumps outside the local host when possible:

* external storage (object storage, NFS, backup systems)
* encrypted backups
* restricted access permissions
* regular automated backup schedules and restore tests
