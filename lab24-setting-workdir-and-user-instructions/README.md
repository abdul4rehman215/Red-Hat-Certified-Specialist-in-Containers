# 🧪 Lab 24: Setting `WORKDIR` and `USER` Instructions

## 🧾 Lab Summary
This lab demonstrates how to set a consistent working directory inside a container using `WORKDIR`, and how to improve container security by creating and running as a **non-root user** using `USER`. I verified the working directory behavior, created a dedicated application user (`appuser`), confirmed runtime execution under that user, and tested restricted operations to validate least-privilege behavior.

---

## 🎯 Objectives
- Learn how to set the working directory (`WORKDIR`) in a Containerfile
- Create and switch to a non-root user (`USER`) for improved container security
- Verify container execution as a non-root user
- Understand the security implications of running containers as non-root

---

## ✅ Prerequisites
- Basic container concepts
- Podman or Docker installed (Podman recommended)
- Text editor (Nano/Vim/VS Code)
- Linux/Unix-based environment (or WSL2 for Windows)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `registry.access.redhat.com/ubi9/ubi-minimal` |
| Focus Area | Container security hardening (non-root execution) |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab24-setting-workdir-and-user-instructions/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman installation and version
* Created a dedicated working directory for the lab

---

### ✅ Task 1: Using `WORKDIR` in a Containerfile

* Created a `Containerfile` using a UBI minimal base image
* Added `WORKDIR /app`
* Verified working directory and default user context by writing:

  * `pwd` and `whoami` into `/tmp/workdir.log`
* Built the image as `workdir-demo` and validated the log output

**Key concept:** `WORKDIR` sets the default directory for subsequent instructions and container runtime.

---

### ✅ Task 2: Creating and Switching to a Non-Root User

* Installed `shadow-utils` to enable `useradd` in the minimal image
* Created a non-root user `appuser` with UID `1001`
* Ensured `/app` is owned by the non-root user
* Switched default runtime user using `USER appuser`
* Verified:

  * container runs as `appuser`
  * `/app` ownership reflects `appuser:appuser`

**Security note:** Running as non-root reduces impact if a container process is compromised.

---

### ✅ Task 3: Security Validation

#### Subtask 3.1 — Test Privileged Operations

* Attempted to write into a restricted host kernel path:

  * `/sys/kernel/profiling`
* Confirmed this operation fails with **Permission denied** under `appuser`

#### Subtask 3.2 — Verify User Context in Running Processes

* Started a container in detached mode (`sleep 300`)
* Used `podman exec` to run `ps -ef`
* Confirmed all processes are owned by **appuser**

---

### ✅ Task 4: Security Implications Analysis

* Compared behavior of root vs non-root execution:

  * `workdir-demo` explicitly ran with root user
  * `nonroot-demo` ran as `appuser`
* Confirmed least privilege differences via `whoami`

**Key finding:** root containers have far greater power; non-root containers are limited by file/system permissions.

---

## ✅ Verification & Validation

* Verified `WORKDIR`:

  * `/tmp/workdir.log` contained:

    * `/app`
    * `root`
* Verified `USER`:

  * `/tmp/user.log` contained:

    * `appuser`
    * ownership of `/app` as `appuser:appuser`
* Verified privilege restriction:

  * touching `/sys/kernel/profiling` returned **Permission denied**
* Verified runtime processes:

  * `ps -ef` showed UID ownership as `appuser`

---

## 🧠 What I Learned

* `WORKDIR` reduces path mistakes and standardizes application execution directories
* Minimal images may require installing tools (`shadow-utils`) before creating users
* Switching to `USER appuser` is a strong default security control for containers
* Least-privilege behavior can be validated by attempting restricted operations
* Process ownership checks (`ps -ef`) confirm runtime identity and reduce assumptions

---

## 🔐 Why This Matters (Security Relevance)

Running containers as root increases risk:

* If an attacker gains code execution, a root process has more ability to modify files, configs, and potentially interact with mounted host paths.
  Running as non-root helps:
* limit filesystem damage
* reduce privilege escalation opportunities
* align with secure-by-default container best practices

---

## 🌍 Real-World Applications

* Hardening containerized microservices for production
* Building safer base images for CI/CD pipelines
* Meeting compliance requirements where root containers are restricted
* Applying least privilege principles in OpenShift and Kubernetes environments

---

## ✅ Result

* Built a demo image using `WORKDIR /app`
* Created and switched to a non-root user `appuser`
* Validated restricted operations fail as expected
* Confirmed processes run under `appuser` during container execution
* Cleaned up images and lab directory successfully

✅ Lab completed successfully on a cloud lab environment.
