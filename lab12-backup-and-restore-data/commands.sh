#!/bin/bash

# Lab 12 - Backup and Restore Data (MySQL)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
podman --version
mkdir -p ~/backup-lab && cd ~/backup-lab

# --------------------------------------------
# Task 1: Create MySQL Container + Sample Data
# --------------------------------------------
podman run -d --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=redhat \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=testpass \
  docker.io/library/mysql:8.0

podman ps -f name=mysql-db

# Wait for readiness before connecting
podman logs mysql-db | tail -n 6

# Connect (interactive)
podman exec -it mysql-db mysql -u root -predhat

# Inside MySQL shell (manual commands):
# USE testdb;
# CREATE TABLE employees (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
# INSERT INTO employees (name) VALUES ('John Doe'), ('Jane Smith');
# SELECT * FROM employees;
# exit;

# --------------------------------------------
# Task 1.3: Create Database Dump
# --------------------------------------------
podman exec mysql-db /usr/bin/mysqldump -u root -predhat testdb > testdb_dump.sql
ls -l testdb_dump.sql
head -n 5 testdb_dump.sql

# --------------------------------------------
# Task 2: Store Dumps on a Podman Volume
# --------------------------------------------
podman volume create backup-vol

# Create directory structure in the volume
podman run -it --rm -v backup-vol:/backup alpine sh
# Inside container:
# mkdir -p /backup/mysql
# exit

# Copy dump into the volume (via temp container with volume mounted)
podman create --name temp -v backup-vol:/backup alpine
podman cp testdb_dump.sql temp:/backup/mysql/
podman rm temp

# Verify dump exists in volume
podman run --rm -v backup-vol:/backup alpine ls -l /backup/mysql

# --------------------------------------------
# Task 3: Restore Data from Dump
# --------------------------------------------
podman run -d --name mysql-restore \
  -e MYSQL_ROOT_PASSWORD=redhat \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=testpass \
  docker.io/library/mysql:8.0

# Copy dump back from the volume to host (via temp container + podman cp)
podman run --rm -v backup-vol:/backup alpine cp /backup/mysql/testdb_dump.sql /tmp/
podman create --name temp -v backup-vol:/backup alpine
podman cp temp:/backup/mysql/testdb_dump.sql ./testdb_dump.sql
podman rm temp
ls -l testdb_dump.sql

# Wait for readiness before restore
podman logs mysql-restore | tail -n 6

# Restore (stdin redirection into mysql client in container)
podman exec -i mysql-restore mysql -u root -predhat testdb < testdb_dump.sql

# Verify restoration
podman exec -it mysql-restore mysql -u root -predhat -e "SELECT * FROM testdb.employees;"

# --------------------------------------------
# Troubleshooting Checks
# --------------------------------------------
podman logs mysql-db | tail -n 10

# --------------------------------------------
# Cleanup
# --------------------------------------------
podman stop mysql-db mysql-restore
podman rm mysql-db mysql-restore
podman volume rm backup-vol
rm -f testdb_dump.sql
