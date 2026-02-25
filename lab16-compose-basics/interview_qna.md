# 🧠 Interview Q&A — Lab 16: Compose Basics (Podman Compose)

---

## 1) What is Podman Compose used for?
Podman Compose is used to define and run **multi-container applications** using a YAML file (Compose format), similar to Docker Compose.

---

## 2) What file defines the multi-container application in this lab?
- `podman-compose.yml`

It defines services, ports, volumes, and environment variables.

---

## 3) Why did you install podman-compose using `pip --user`?
Because it was not installed by default in the lab environment. `pip --user` installs it without needing system-wide package installation.

---

## 4) Why did you add `~/.local/bin` to PATH?
Because `pip --user` installed `podman-compose` into:
- `/home/toor/.local/bin`
which was not initially in PATH.

---

## 5) What are “services” in a compose file?
Services are the containerized components of the application. Each service becomes one (or more) running containers.

---

## 6) Which services did you define in this lab?
- `web`: Nginx (serving HTML)
- `db`: PostgreSQL 13 (database service)

---

## 7) How did you expose the web service to the host?
Using port publishing in YAML:
```yaml
ports:
  - "8080:80"
````

This binds host port 8080 to container port 80.

---

## 8) What does the `volumes` section do for the web service?

It bind-mounts the host folder `./html` into the container path:

* `/usr/share/nginx/html`
  So content on the host is served by Nginx inside the container.

---

## 9) Why was the `html` folder already present when you ran `mkdir html`?

Because the compose run referenced `./html`, and Podman/compose created or mounted the directory path during startup. So attempting to create it again showed “File exists”.

---

## 10) What environment variable did you configure for PostgreSQL?

* `POSTGRES_PASSWORD=example`
  This initializes the database password for the default `postgres` user.

---

## 11) What did `podman-compose up -d` do automatically?

It created:

* a project network: `compose-lab_default`
* a named volume: `compose-lab_db_data`
  then pulled images and started containers.

---

## 12) How did you verify the containers were running?

Using:

* `podman ps`
  which listed:
* `compose-lab_web_1`
* `compose-lab_db_1`

---

## 13) How did you test the web service?

By writing `html/index.html` and requesting:

* `curl http://localhost:8080`
  It returned:
* `<h1>Hello from Podman Compose!</h1>`

---

## 14) How did you verify PostgreSQL service health?

By opening `psql` inside the container and running:

* `SELECT version();`
  which returned PostgreSQL version output.

---

## 15) Why did `podman-compose down` remove containers but leave the volume?

This is common behavior—compose stops and removes containers and networks, but **named volumes** may remain to prevent accidental data loss. They can be removed manually if desired.
