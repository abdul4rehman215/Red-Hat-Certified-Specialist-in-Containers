# 🧪 Lab 33: Running Containers Locally with Podman

## 🧾 Lab Summary
This lab focused on day-to-day container operations using Podman. I ran containers in both **foreground** and **detached** modes, published a web service using **port mapping**, created and mounted a **named volume** for persistent storage, and tested **runtime user overrides**. I also practiced operational inspection using `podman inspect`, `podman logs`, and `podman stats`, then cleaned up containers and volumes.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Run containers in both foreground and detached modes
- Configure port mapping between host and container
- Manage persistent storage using volumes
- Override user settings at runtime
- Inspect running containers and their configurations

---

## ✅ Prerequisites
- Podman installed (v3.0+ recommended)
- Basic Linux command line knowledge
- Internet access to pull container images

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Images Used | `nginx:latest`, `alpine:latest` |
| Main Topics | run modes, ports, volumes, user overrides, inspection |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab33-running-containers-locally-with-podman/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Setup

* Confirmed package manager differences on CentOS 7:

  * `dnf` not present → used `yum`
* Verified Podman version
* Pulled `nginx:latest` before running demos (reduced runtime delay)

---

### ✅ Task 1: Foreground vs Detached Containers

* Ran Nginx in the foreground (attached terminal):

  * observed startup logs in real time
  * stopped with `Ctrl+C` and observed graceful shutdown signals
* Ran Nginx in detached mode (`-d`) and confirmed it stayed running using `podman ps`

---

### ✅ Task 2: Port Mapping and Volume Binding

* Published container port 80 to host port 8080:

  * `-p 8080:80`
* Verified Nginx is reachable via:

  * `curl -I http://localhost:8080`
  * `curl http://localhost:8080 | head`
* Created a named volume (`mydata`) and attached it to an Alpine container:

  * verified mount point exists (`/data`)

---

### ✅ Task 3: User Overrides + Inspection

* Ran Alpine as UID 1000 to demonstrate unknown user output
* Ran Alpine as `nobody` to demonstrate known user output
* Inspected containers using:

  * `podman inspect webapp` (configuration + state)
  * `podman logs webapp` (service logs)
  * `podman stats --no-stream` (resource usage snapshot)

---

### ✅ Task 4: Cleanup

* Stopped all running containers
* Removed all containers
* Removed the named volume created for this lab

---

## ✅ Verification & Validation

* Foreground run produced Nginx startup logs and graceful shutdown logs after `Ctrl+C`
* Detached container appeared in `podman ps`
* Port mapping validated with HTTP 200 response and page content
* Volume created successfully and mounted at `/data`
* User override validated:

  * UID 1000 → `whoami: unknown uid 1000`
  * `nobody` → `nobody`
* Inspection outputs validated:

  * `podman inspect` showed container state as running
  * `podman logs` showed Nginx worker process startup lines
  * `podman stats` showed CPU/memory usage

---

## 🧠 What I Learned

* Foreground mode is helpful for debugging and watching logs live
* Detached mode is standard for running services in the background
* Port publishing (`-p`) is required for host access to container services
* Named volumes persist data and are managed by Podman
* `--user` overrides help test permissions and least privilege behavior
* `inspect`, `logs`, and `stats` are essential operational tools for container troubleshooting

---

## 💡 Why This Matters

These are the core operational skills required to run and troubleshoot containers locally before deploying to orchestration platforms like OpenShift/Kubernetes.

---

## 🌍 Real-World Applications

* Running local dev/test environments using Nginx containers
* Publishing services safely with host-to-container port mappings
* Persisting data for stateful apps with volumes
* Running containers with restricted users to reduce risk
* Performing quick health checks using logs, inspect, and stats

---

## ✅ Result

* Successfully ran Nginx in foreground and detached modes
* Published Nginx via host port mapping and verified connectivity
* Created and mounted a named volume inside a container
* Demonstrated runtime user override behaviors
* Inspected and monitored running containers
* Cleaned up containers and volumes after completion

✅ Lab completed successfully on a cloud lab environment.
