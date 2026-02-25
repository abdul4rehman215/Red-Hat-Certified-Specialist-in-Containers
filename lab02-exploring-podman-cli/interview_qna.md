# 🧠 Interview Q&A — Lab 02: Exploring Podman CLI

---

## 1) What is Podman used for?
Podman is used to **pull images**, **run containers**, and **manage container lifecycle** (start/stop/restart/remove). It can also inspect containers and images for troubleshooting and operational visibility.

---

## 2) What is the difference between `podman ps` and `podman ps -a`?
- `podman ps` shows **only running containers**
- `podman ps -a` shows **all containers**, including stopped/exited ones

---

## 3) Why did `podman ps` show an empty list after running the Alpine container interactively?
Because the container exited when you typed `exit`. Since `podman ps` shows only running containers, it was expected to display nothing.

---

## 4) What does `podman run -it --name my_alpine alpine sh` do?
It creates and runs a container from the `alpine` image:
- `-i` keeps input open
- `-t` allocates a terminal
- `--name my_alpine` assigns a human-readable container name
- `sh` launches a shell inside the container

---

## 5) What does `podman start` do?
It starts an **existing container** that is currently stopped/exited, without creating a new container.

---

## 6) Why did we run `podman start my_alpine` before `podman stop my_alpine`?
Because after exiting the interactive shell, the container was already in an **Exited** state. To demonstrate stopping a running container, it must first be started.

---

## 7) What does exit code `137` typically indicate (seen as Exited (137))?
Exit code `137` often indicates the container was terminated by a signal like **SIGKILL** (e.g., forced stop). This can happen during stop operations depending on timing and signal escalation.

---

## 8) What does `podman restart` do?
It stops and then starts a container in one command. It’s useful for refreshing container state or applying certain runtime changes.

---

## 9) What is the correct order to safely remove a running container?
1) Stop it: `podman stop <name>`
2) Remove it: `podman rm <name>`

This avoids removal failures and keeps operations predictable.

---

## 10) What is the purpose of running Nginx in detached mode with `-d`?
Detached mode runs the container **in the background**, which is typical for services like web servers.

---

## 11) What does `podman inspect` provide?
It provides detailed JSON metadata such as:
- container ID and name
- image name and command
- runtime state (running, PID, exit code)
- network settings (IP address, gateway)
- environment variables and configuration

---

## 12) Why is `podman inspect` useful in troubleshooting?
It helps diagnose misconfigurations and runtime issues by exposing:
- what command is running
- what environment variables are set
- what networks/IPs are assigned
- whether the container is running and what PID it uses

---

## 13) What does `--name` help with compared to using container IDs?
It makes containers easier to reference in commands. Names are more readable than long container IDs.

---

## 14) Why did we clean up the Nginx container after inspecting it?
To keep the environment clean, avoid resource waste, and prevent leftover containers from affecting later labs.

---

## 15) In OpenShift/Kubernetes contexts, why is container lifecycle knowledge important?
Because containerized apps rely on correct lifecycle handling:
- starting/stopping services
- restarting on failure
- monitoring runtime state
- inspecting configuration for debugging
These are foundational for container orchestration workflows.
