# 🧠 Interview Q&A — Lab 11: Running Stateful Containers (MySQL + PostgreSQL)

---

## 1) What is a “stateful container”?
A stateful container is one that needs to keep data over time (e.g., a database). If storage is not persisted outside the container, the data is lost when the container is removed.

---

## 2) Why do databases require persistent storage?
Databases store data on disk. If the container’s writable layer is deleted, the database files disappear. Persistent storage ensures data survives restarts and container replacements.

---

## 3) How did you persist MySQL data in this lab?
By bind-mounting a host directory:
- `$(pwd)/mysql-data:/var/lib/mysql`
This maps MySQL’s data directory to the host so data is stored outside the container.

---

## 4) What do the MySQL environment variables do during first initialization?
- `MYSQL_ROOT_PASSWORD` sets the root password
- `MYSQL_DATABASE` creates an initial database
- `MYSQL_USER` and `MYSQL_PASSWORD` create a user and grant access to the database
These typically apply on first initialization of an empty data directory.

---

## 5) Why did you check `podman logs mysql-db` before connecting?
Because MySQL can take time to initialize. Logs confirm readiness:
- “ready for connections”
This helps avoid connection errors caused by starting too early.

---

## 6) Why is `mysql -puser123` considered insecure?
Because passing a password on the command line can expose it in shell history and process listings. In real environments, use safer methods (prompt, secrets, env vars, files).

---

## 7) How did you verify data was written successfully in MySQL?
By creating a table and inserting a row, then running:
- `SELECT * FROM lab_data;`
The output showed the inserted record.

---

## 8) How did you verify persistence after container removal?
I stopped and removed the container, recreated it using the same host mount, then queried:
- `SELECT * FROM lab_data;`
The record still existed, confirming data persisted.

---

## 9) Why did the recreation command not include MYSQL_USER/MYSQL_DATABASE variables?
Because the data directory already contained an initialized database. Reusing the same storage preserves users/databases, so minimal variables are enough for the container to start.

---

## 10) What is a common cause of database container startup failure with host mounts?
Host directory permissions/ownership mismatches. Database processes inside the container run as specific UID/GID and may fail if they can’t write to the mounted directory.

---

## 11) Why did you run `sudo chown -R 1001:1001 mysql-data/`?
To match ownership to the UID/GID used by the container’s database process (common workaround when permission issues occur).

---

## 12) What is the purpose of checking ports with `ss -tulnp | grep 3306`?
To confirm whether the host port (3306) is already in use. Port conflicts prevent containers from binding required ports.

---

## 13) How did you persist PostgreSQL data?
By bind-mounting a host directory:
- `$(pwd)/pg-data:/var/lib/postgresql/data`

---

## 14) How did you insert and verify PostgreSQL data?
Using `psql` inside the container to run SQL commands:
- create table + insert row
- `SELECT * FROM lab_data;`
The query output showed the inserted row.

---

## 15) If you omit `-v` when running a database container, what happens?
Database data is stored only in the container’s writable layer. When the container is removed, all database data is lost.
