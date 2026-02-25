# 🧠 Interview Q&A — Lab 3: Running Containers with Podman

---

## 1) What does running a container in “detached mode” mean?
Detached mode runs the container in the background so your terminal is free while the container continues running.

---

## 2) Which flag enables detached mode in Podman?
`-d`

Example:
```bash
podman run -d docker.io/library/nginx:alpine
````

---

## 3) How do you verify a container is currently running?

Use:

```bash
podman ps
```

It lists only running containers.

---

## 4) What is the quickest way to check why a container failed to start?

View container logs:

```bash
podman logs <container_id_or_name>
```

---

## 5) What does port mapping do in containers?

It maps a host port to a container port, allowing external access to the service running inside the container.

---

## 6) What is the Podman syntax for port mapping?

```bash
-p <host_port>:<container_port>
```

Example:

```bash
podman run -d -p 8080:80 nginx:alpine
```

---

## 7) How did you verify port mapping was configured correctly?

Using:

```bash
podman port <container_id>
```

It returned:

* `80/tcp -> 0.0.0.0:8080`

---

## 8) Why did you use `curl http://localhost:8080`?

To confirm the Nginx service inside the container was reachable via the published host port.

---

## 9) What is a bind mount in container terms?

A bind mount maps a host directory into the container filesystem so the container can read/write files directly from the host path.

---

## 10) What is the syntax for mounting a host directory into a container with Podman?

```bash
-v <host_path>:<container_path>
```

Example:

```bash
podman run -d -v ~/nginx-content:/usr/share/nginx/html nginx:alpine
```

---

## 11) Why did you use `:Z` in the volume mount?

`:Z` applies SELinux relabeling so containers can access the mounted directory on SELinux-enabled systems (common on RHEL-based hosts).

---

## 12) Why did `chcon` error on Ubuntu in this lab?

Ubuntu typically does not run SELinux labeling in the same way (AppArmor is common), so SELinux relabeling commands can fail or be unnecessary.

---

## 13) What is the benefit of assigning a custom container name?

It makes management easier, so you can reference containers by a friendly name instead of long IDs.

---

## 14) How do you assign a custom container name?

Using:

```bash
--name <name>
```

Example:

```bash
podman run -d --name my-nginx nginx:alpine
```

---

## 15) What is a safe cleanup command to remove all containers in a lab environment?

```bash
podman rm -f $(podman ps -aq)
```

It force-removes all containers (running or stopped), which is useful after lab completion.
