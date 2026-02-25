# 🧠 Interview Q&A — Lab 01: Introduction to Containers (Podman)

---

## 1) What is a container?
A container is a lightweight, standalone runtime package that includes an application and everything it needs (dependencies, libraries, configuration) while sharing the host OS kernel.

---

## 2) How are containers different from virtual machines (VMs)?
- **VMs** virtualize hardware and run a full guest OS, which adds overhead.
- **Containers** share the host kernel and isolate user-space processes, making them faster and more resource-efficient.

---

## 3) What does “container isolation” mean?
Isolation means a container runs in its own separated environment (processes, filesystem view, network namespace, etc.) so it doesn’t interfere with the host or other containers.

---

## 4) What is Podman?
Podman is a container engine that can build, run, and manage containers and images. It is commonly used as a daemonless alternative to Docker-style workflows.

---

## 5) What does `podman pull` do?
`podman pull` downloads an image from a container registry (like Docker Hub) into the local image store so it can be run locally.

---

## 6) What does `podman run` do?
`podman run` creates and starts a new container from an image. If the image is not already available locally, Podman will attempt to pull it automatically (depending on configuration).

---

## 7) Why did the `hello-world` container show “Hello from Docker!” even though we used Podman?
The message comes from the **hello-world image content**. The image was originally designed for Docker workflows, but it runs the same in Podman because containers follow standard image formats.

---

## 8) What does `podman ps -a` show?
It lists **all containers**, including:
- running containers
- stopped/exited containers
This is useful for verifying that a container ran and checking its last state.

---

## 9) Why does `hello-world` show status “Exited (0)”?
The container performs a simple task (prints a message) and then exits normally.
- Exit code `0` indicates success.

---

## 10) How did you confirm the Alpine container was isolated?
Inside the Alpine container, running:
- `cat /etc/os-release`
showed Alpine Linux details, which differed from the host OS. This indicates the container has its own user-space environment.

---

## 11) What is the purpose of running `podman run -it alpine sh`?
- `-i` keeps STDIN open (interactive)
- `-t` allocates a pseudo-TTY
This combination allows interactive shell access inside the container.

---

## 12) What does `podman --version` verify?
It confirms Podman is installed and shows the installed version, which helps validate installation and troubleshoot version-specific issues.

---

## 13) What is rootless container execution, and why is it useful?
Rootless containers run under a normal user account instead of root. Benefits include:
- reduced privilege risk
- improved security posture
- safer multi-user environments

---

## 14) What does `podman system migrate` do?
It migrates Podman’s runtime configuration (especially useful when switching or updating rootless configuration and runtime settings).

---

## 15) Why are containers important for OpenShift / Kubernetes?
Containers are the foundation of cloud-native platforms:
- OpenShift/Kubernetes schedule and orchestrate containers
- containers provide repeatable deployments and scalability
- consistent runtime behavior across environments
