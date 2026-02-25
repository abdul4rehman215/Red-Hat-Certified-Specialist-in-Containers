# 🧪 Lab 10: Persisting Data with Volumes (Podman)

## 📌 Lab Summary
This lab demonstrates **persistent storage** techniques for containers using:
- **Named volumes** (managed by Podman, survive container removal)
- **Bind mounts** (map host directories directly into containers)

You will see how container data can persist across the container lifecycle and how host-side changes instantly reflect inside the container when using bind mounts.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Create and manage **named volumes** using Podman
- Inspect volume metadata and mount points
- Mount volumes into containers and persist application data
- Use **bind mounts** to share host directories with containers
- Verify persistence and real-time updates across container restarts/removals

---

## ✅ Prerequisites
- Basic Linux command line understanding
- Podman installed (3.0+ recommended)
- Linux-based environment (or WSL2 on Windows)
- Rootless Podman configured (optional but recommended)

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu (cloud lab environment) |
| Podman | Installed and operational |
| Images Used | `docker.io/library/nginx` |
| Storage Type | Rootless volume path observed under user home |

> Note (realistic rootless behavior): volume mountpoints can appear under:
> `/home/<user>/.local/share/containers/storage/volumes/...` rather than `/var/lib/...`

---

## 🗂️ Repository Structure (Lab Format)
```text
lab10-persisting-data-with-volumes/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Creating Named Volumes

* Created a named volume `myapp_data`
* Listed volumes to verify creation
* Inspected the volume to identify:

  * driver
  * mountpoint path
  * creation time

### ✅ Task 2: Mounting Volumes in Containers

* Ran an Nginx container (`webapp`) with the named volume mounted to:

  * `/var/www/html`
* Wrote content into the mounted directory inside the container
* Removed the container and recreated a new container using the same volume
* Verified that the data persisted across container removal/recreation

### ✅ Task 3: Using Bind Mounts with Host Directories

* Created a host directory `~/host_data`
* Created a host `index.html`
* Ran an Nginx container (`bind_example`) with a bind mount:

  * `~/host_data` → `/usr/share/nginx/html:Z`
* Verified container reads the host file
* Updated the host file and confirmed changes instantly reflect inside the container

---

## ✅ Verification & Validation

* Named volume created and listed:

  * `podman volume create myapp_data`
  * `podman volume ls`
* Volume mountpoint confirmed:

  * `podman volume inspect myapp_data`
* Data persistence verified:

  * `Hello, Volume!` remained after container removal and recreation
* Bind mount verified:

  * container reads host `index.html`
  * after host file update, container shows updated content immediately

---

## 🧠 What I Learned

* Named volumes are the cleanest approach for container-managed persistence
* Volume data survives container removal because it lives outside the container filesystem
* Bind mounts are useful for development workflows because changes reflect instantly
* Rootless Podman stores volumes under user home directories (common in lab/cloud environments)
* SELinux labeling flags like `:Z` are required on SELinux-enabled systems to avoid permission errors

---

## 🌍 Why This Matters

Most real-world apps are **stateful** (web content, logs, databases). Without volumes:

* data disappears when a container is removed
  With proper storage:
* services become resilient across container lifecycle events (restarts, rebuilds, upgrades)

---

## 🧩 Real-World Applications

* Running databases (PostgreSQL/MySQL) with persistent storage
* Storing web content/configs outside containers
* Development workflows (bind mounts with live editing)
* Migration and backups using volume mountpoints and volume drivers (NFS, etc.)

---

## ✅ Result

* Created and inspected named volumes
* Persisted data across container deletion/recreation using a named volume
* Used bind mounts to share host directories and confirm real-time changes inside containers

---

## ✅ Conclusion

This lab demonstrated two essential persistence strategies in container environments: named volumes for durable, Podman-managed storage and bind mounts for direct host-directory sharing. These concepts are critical for building reliable containerized applications where data must survive container lifecycle operations.
