# 🧪 Lab 3: Running Containers with Podman

## 📌 Lab Summary
This lab focused on running and managing containers using **Podman**, including:
- Running containers in **detached mode**
- Publishing container ports to the host using **port mapping**
- Mounting host directories into containers using **bind mounts**
- Assigning and managing containers using **custom names**
- Basic validation using `podman ps`, `podman port`, `curl`, and `podman inspect`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Run containers in detached mode
- Map container ports to host ports
- Mount host directories into containers
- Assign custom names to containers

---

## ✅ Prerequisites
- Podman installed on your system (version 3.0+ recommended)
- Basic familiarity with command-line operations
- A Linux-based system (recommended) or Podman configured on Windows/macOS

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | 4.9.3 |
| Base Image | `docker.io/library/nginx:alpine` |
| Tools Used | `podman`, `curl`, `ss`, `chcon` (optional/SELinux-related) |

---

## 🗂️ Repository Structure (Lab Folder)
```text
lab03-running-containers-with-podman/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    └── nginx-content/
        └── index.html
````

---

## 🧩 Tasks Performed (Overview — No Commands Here)

### ✅ Task 1: Run a Container in Detached Mode

* Started an Nginx container in the background using detached mode
* Verified it was running and reviewed logs for basic troubleshooting

### ✅ Task 2: Map Container Ports to Host Ports

* Stopped running containers to avoid conflicts
* Started Nginx with host-to-container port mapping
* Verified port mapping and tested access using curl

### ✅ Task 3: Mount Host Directory into a Container (Bind Mount)

* Created a host directory and `index.html`
* Mounted it into the container’s Nginx web root
* Confirmed the container served the host file over HTTP
* Observed SELinux-related commands may not apply on Ubuntu (expected)

### ✅ Task 4: Assign Custom Names to Containers

* Stopped prior containers
* Started a new container with a human-friendly name (`my-nginx`)
* Verified status using container name and performed stop/cleanup by name

---

## ✅ Verification

* `podman ps` confirmed containers were running
* `podman port <id>` confirmed host ↔ container port mapping
* `curl http://localhost:<port>` validated service reachability
* `podman inspect my-nginx | grep -i status` confirmed runtime status
* `ss -tulnp` helped confirm ports in use on the host

---

## 🧠 What I Learned

* Detached mode (`-d`) is the standard way to run background services
* Port mapping (`-p host:container`) enables access from outside the container namespace
* Bind mounts (`-v host:container`) are a fast way to serve or persist local content
* Custom names (`--name`) simplify container management vs using IDs
* SELinux mount labeling (`:Z`) is important on SELinux-enabled systems, but may be unnecessary on Ubuntu

---

## 🌍 Real-World Relevance

These are core container operations used daily in:

* Local dev/test environments before Kubernetes/OpenShift deployment
* Debugging and validating containerized apps quickly
* Preparing apps for exposure through Services/Routes/Ingress later
* Managing state/configuration through mounts and networking

---

## ✅ Result

* Successfully ran Nginx containers in detached mode
* Exposed Nginx using host port mapping and validated over HTTP
* Served custom host content using a bind mount
* Managed containers by custom name and cleaned up resources

---

## ✅ Conclusion

This lab built foundational Podman skills for running containers, exposing them via ports, mounting host content, and managing containers by name—key steps before moving into pods, orchestration, and OpenShift workflows.
