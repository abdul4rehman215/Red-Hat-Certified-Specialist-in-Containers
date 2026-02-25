# 🧪 Lab 28: `EXPOSE` and Port Binding

## 🧾 Lab Summary
This lab demonstrates how container ports are **documented** using `EXPOSE` and how they are **published** to the host using Podman port mapping. I built a small Flask web app image that listens on port `8080`, ran containers with different `-p` mappings, validated access with `curl`, and troubleshot a realistic port conflict scenario (port already in use). I also tested Podman’s automatic port publishing with `-P`.

---

## 🎯 Objectives
- Understand how to document and expose ports in container images
- Learn to map container ports to host ports
- Test network connectivity between containers and host systems
- Troubleshoot common port binding issues

---

## ✅ Prerequisites
- Podman installed (v3.0+ recommended)
- Basic Linux command-line familiarity
- Text editor (vim/nano/gedit)
- Network connectivity
- `curl` or `telnet` for testing

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| App | Python + Flask (listening on `0.0.0.0:8080`) |
| Base Image | `python:3.9-slim` |
| Networking Tools | `curl`, `ss` (via `iproute`), `lsof` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab28-expose-and-port-binding/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── app.py
├── requirements.txt
└── Containerfile
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman version
* Created a working directory for the lab

---

### ✅ Task 1: Using `EXPOSE` in a Containerfile

* Created a Flask web app (`app.py`) that listens on port **8080**
* Created `requirements.txt` with `flask`
* Created a `Containerfile`:

  * sets `WORKDIR /app`
  * copies app files
  * installs dependencies
  * documents port with `EXPOSE 8080`
  * starts app with `CMD ["python", "app.py"]`

**Key concept:** `EXPOSE` documents the intended listening port but does not publish it.

---

### ✅ Task 2: Run Container with Port Mappings

* Built the image: `exposed-app`
* Ran the container with explicit mapping:

  * `-p 8080:8080`
* Verified the container is running and shows port mapping via `podman ps`

---

### ✅ Task 3: Test Connectivity from Host

* Checked host port binding:

  * `ss -tulnp | grep 8080`
  * handled a realistic tool-missing case (`ss` not found) and confirmed `iproute` is installed
* Tested application access:

  * `curl http://localhost:8080`
* Stopped the original container and tested a different host mapping:

  * `-p 9090:8080`
  * confirmed access via `curl http://localhost:9090`

---

### ✅ Task 4: Troubleshoot Port Conflicts

* Simulated a real port conflict on host port `8080` by starting a temporary local listener:

  * `python3 -m http.server 8080 &`
* Attempted to run another container mapping host port 8080:

  * reproduced `address already in use`
* Found conflicting process with:

  * `sudo lsof -i :8080`
* Resolved by killing the conflicting PID
* Tested Podman auto-publish:

  * `podman run -d -P ...`
  * verified with `podman port webapp4`

---

## ✅ Verification & Validation

* Confirmed Flask app responded correctly:

  * `Hello from the exposed container port!`
* Confirmed port mapping visible in:

  * `podman ps`
  * `ss -tulnp`
* Confirmed alternate port mapping works:

  * host `9090` → container `8080`
* Confirmed conflict and resolution workflow:

  * reproduced “address already in use”
  * identified PID with `lsof`
  * resolved and validated `-P` random port mapping

---

## 🧠 What I Learned

* `EXPOSE` is documentation; publishing requires runtime flags like `-p` or `-P`
* Port publishing syntax:

  * `-p hostPort:containerPort`
* Rootless Podman uses a helper process (`rootlessport`) for port forwarding
* Port conflicts can be diagnosed with:

  * `ss` / `netstat` (if available)
  * `lsof -i :PORT`
* `-P` is useful for testing by auto-assigning a host port for exposed ports

---

## 💡 Why This Matters

Port publishing is a core requirement for running:

* web apps
* APIs
* internal services
* microservices in development environments

Understanding the difference between **documenting** ports and **publishing** ports prevents common runtime issues, especially in CI/CD and local testing workflows.

---

## 🌍 Real-World Applications

* Running containerized web services locally with safe port mappings
* Debugging port conflicts on shared environments
* Validating service reachability before Kubernetes/OpenShift deployment
* Using `-P` for rapid testing without hardcoding host ports

---

## ✅ Result

* Built and ran a Flask container app listening on port `8080`
* Published ports using `-p` and validated with `curl`
* Tested alternate port mapping (`9090:8080`)
* Simulated and resolved a port conflict on `8080`
* Used `-P` to auto-publish ports and verified assigned mapping

✅ Lab completed successfully on a cloud lab environment.
