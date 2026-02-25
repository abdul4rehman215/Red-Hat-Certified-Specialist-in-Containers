#!/bin/bash

# Lab 11 - Running Stateful Containers (MySQL + PostgreSQL)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
podman --version
mkdir -p ~/stateful-lab && cd ~/stateful-lab

# --------------------------------------------
# Task 1: MySQL with Persistent Storage
# --------------------------------------------
mkdir -p mysql-data
ls -ld mysql-data

podman run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=redhat123 \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=user123 \
  -v $(pwd)/mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  docker.io/library/mysql:8.0

podman ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Wait for readiness (log check)
podman logs mysql-db | tail -n 8

# Connect to MySQL (interactive)
podman exec -it mysql-db mysql -u testuser -puser123 testdb

# Inside MySQL shell (manual commands):
# CREATE TABLE lab_data (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255));
# INSERT INTO lab_data (message) VALUES ('Persistent test data');
# SELECT * FROM lab_data;
# exit;

# --------------------------------------------
# Task 2: Verify Persistence (MySQL)
# --------------------------------------------
podman stop mysql-db
podman rm mysql-db

podman run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=redhat123 \
  -v $(pwd)/mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  docker.io/library/mysql:8.0

podman ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Verify data still exists (non-interactive)
podman exec -it mysql-db mysql -u testuser -puser123 testdb -e "SELECT * FROM lab_data;"

# --------------------------------------------
# Task 3: PostgreSQL (Optional)
# --------------------------------------------
mkdir -p pg-data
ls -ld pg-data

podman run -d \
  --name postgres-db \
  -e POSTGRES_PASSWORD=redhat123 \
  -e POSTGRES_USER=testuser \
  -e POSTGRES_DB=testdb \
  -v $(pwd)/pg-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  docker.io/library/postgres:13

# Wait for readiness
podman logs postgres-db | tail -n 6

# Create table + insert data (one-line SQL)
podman exec -it postgres-db psql -U testuser -d testdb -c "CREATE TABLE lab_data (id SERIAL PRIMARY KEY, message TEXT); INSERT INTO lab_data (message) VALUES ('Postgres persistent data');"

# Verify
podman exec -it postgres-db psql -U testuser -d testdb -c "SELECT * FROM lab_data;"

# --------------------------------------------
# Troubleshooting Checks
# --------------------------------------------
sudo chown -R 1001:1001 mysql-data/
ss -tulnp | grep 3306
podman logs mysql-db | tail -n 12
