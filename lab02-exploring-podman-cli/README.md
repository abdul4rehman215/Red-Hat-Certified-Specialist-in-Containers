# 🧪 Lab 02: Exploring Podman CLI

## 📌 Lab Summary
This lab focuses on **Podman CLI fundamentals** and daily container operations. It covers how to:
- List running and stopped containers
- Run containers interactively and in detached mode
- Start/stop/restart containers
- Remove containers safely
- Inspect container metadata using JSON output

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Use core Podman commands effectively (`ps`, `run`, `start`, `stop`, `restart`, `rm`, `inspect`)
- Manage the full container lifecycle (create → run → stop → restart → delete)
- Inspect container configuration details and runtime state using `podman inspect`

---

## ✅ Prerequisites
- Linux system with Podman installed (Ubuntu/Fedora/RHEL/CentOS)
- Basic Linux command line familiarity
- Internet access to pull images from container registries

---

## 🧰 Lab Environment
> Environment details as recorded in lab output.

| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman Version | 4.9.3 |
| Images Used | `alpine`, `hello-world`, `nginx` |
| Container Names Used | `my_alpine`, `nginx_container` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab02-exploring-podman-cli/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Listing Containers

* Listed running containers using `podman ps`
* Listed all containers (including exited/stopped) using `podman ps -a`

### ✅ Task 2: Running a Container

* Ran an interactive Alpine container with a custom name (`my_alpine`)
* Exited the shell and confirmed expected behavior (container exits when shell exits)

### ✅ Task 3: Stopping a Container

* Demonstrated realistic lifecycle:

  * Started `my_alpine` first (since it was exited)
  * Stopped it using `podman stop`
* Verified container state in `podman ps -a`

### ✅ Task 4: Restarting a Container

* Restarted `my_alpine` using `podman restart`
* Verified container status returned to **Up** in `podman ps`

### ✅ Task 5: Removing a Container

* Stopped container before removal (safe practice)
* Removed container using `podman rm`
* Verified removal using `podman ps -a`

### ✅ Task 6: Inspecting Container Details

* Ran an `nginx` container in detached mode (`-d`)
* Inspected full metadata using `podman inspect` (JSON output)
* Cleaned up by stopping and removing the container

---

## ✅ Verification & Validation

* Podman installation verified:

  * `podman --version` returned `podman version 4.9.3`
* Container listing verified:

  * `podman ps` showed running-only containers
  * `podman ps -a` showed both running and exited containers
* Lifecycle operations verified:

  * `podman start`, `podman stop`, `podman restart`, and `podman rm` behaved as expected
* Inspection verified:

  * `podman inspect nginx_container` displayed JSON with:

    * container ID, image name, runtime status, PID
    * network settings and container environment variables

---

## 🧠 What I Learned

* How to quickly identify container state using `podman ps` vs `podman ps -a`
* How interactive containers behave (exit when the shell exits)
* How to safely remove containers after stopping them
* How `podman inspect` helps with debugging by exposing:

  * container configuration, environment variables
  * network settings (IP address, gateway)
  * runtime state (Running, PID, start time)

---

## 🌍 Why This Matters

Podman CLI lifecycle management is a foundation skill for:

* Building and testing containers locally
* Troubleshooting container behavior and configuration
* Preparing for container orchestration workflows (Kubernetes/OpenShift)
* Supporting DevOps and platform engineering tasks in production environments

---

## 🧩 Real-World Applications

* Quick validation of deployed containers in a node/host environment
* Debugging runtime issues using inspect output
* Managing local development environments (start/stop workflows)
* Cleaning up containers to maintain predictable environments

---

## ✅ Result

* Successfully managed container lifecycle operations:

  * run → start → stop → restart → remove
* Verified container states via `podman ps` and `podman ps -a`
* Inspected `nginx` container metadata and cleaned up resources

---

## ✅ Conclusion

This lab provided hands-on experience using essential Podman CLI commands. These container lifecycle and inspection skills are directly applicable to OpenShift/Kubernetes environments and are required for effective container debugging and administration.
