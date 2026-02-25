# 🧪 Lab 27: Parameterized `ENTRYPOINT` Scripts

## 🧾 Lab Summary
This lab focuses on building **parameterized ENTRYPOINT scripts** that can adapt to different runtime conditions. I created an ENTRYPOINT script that prints startup context, then extended it to handle **argument passing** between `CMD` and `ENTRYPOINT`. After that, I implemented **environment-specific behavior** using an `ENV_MODE` variable (development vs production). Finally, I built a dispatcher-style ENTRYPOINT that behaves like a small CLI for start/stop commands and validates input.

---

## 🎯 Objectives
- Understand the role of `ENTRYPOINT` in container initialization
- Create and test ENTRYPOINT scripts that handle environment-specific logic
- Implement parameter passing between `CMD` and `ENTRYPOINT`
- Distinguish between development and production modes in container execution

---

## ✅ Prerequisites
- Podman or Docker installed (Podman recommended)
- Basic Linux command-line knowledge
- Familiarity with shell scripting
- Text editor (vim/nano/vscode)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `alpine:latest` |
| Shell Used in Script | `/bin/bash` (installed inside image) |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab27-parameterized-entrypoint-scripts/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── entrypoint.sh
````

> Note: This lab uses a real `entrypoint.sh` script that was updated multiple times across tasks (startup info → parameter handling → ENV mode logic → command dispatcher).

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman installation
* Created a dedicated lab directory

---

### ✅ Task 1: Create a Basic ENTRYPOINT Script

* Wrote `entrypoint.sh` that prints:

  * container start message
  * current user (`whoami`)
  * current directory (`pwd`)
* Built an image that installs `bash` (Alpine defaults to `/bin/sh`) and uses the script as ENTRYPOINT
* Ran the container and verified startup output

---

### ✅ Task 2: Implement Parameter Handling (CMD → ENTRYPOINT)

* Updated `entrypoint.sh` to print received arguments:

  * first argument and second argument
* Used `exec "$@"` to execute the command passed from `CMD`
* Updated Dockerfile to include both:

  * `ENTRYPOINT ["/entrypoint.sh"]`
  * `CMD ["echo", "Default command executed"]`
* Tested:

  * default CMD execution
  * runtime override (`ls -l /`)

---

### ✅ Task 3: Environment-Specific Logic (Development vs Production)

* Updated `entrypoint.sh` to check `ENV_MODE`:

  * `development` → prints debug-mode message
  * `production` → prints strict-mode message
  * default → prints no ENV_MODE message
* Updated Dockerfile and rebuilt
* Tested:

  * `ENV_MODE=development`
  * `ENV_MODE=production`
  * no ENV_MODE

---

### ✅ Task 4: Advanced Parameter Handling (Dispatcher Pattern)

* Updated `entrypoint.sh` into a dispatcher using `case "$1"`:

  * `start [config]` → prints config selection
  * `stop` → prints graceful stop message
  * invalid args → prints usage and exits with error
* Rebuilt image and tested:

  * `start production`
  * `stop`
  * invalid input

---

## ✅ Verification & Validation

* ENTRYPOINT executed successfully at startup
* Parameter handling validated:

  * default CMD executed via `exec "$@"`
  * runtime override executed correctly
* ENV_MODE logic validated:

  * development/prod/default outputs matched expected messages
* Dispatcher logic validated:

  * correct output for `start`, `stop`
  * usage message for invalid args

---

## 🧠 What I Learned

* ENTRYPOINT scripts are a common way to control container startup behavior
* `exec "$@"` is a best practice for:

  * correct PID 1 behavior
  * proper signal handling
* CMD can provide default arguments to an ENTRYPOINT
* Environment variables are a clean way to switch behavior without rebuilding images
* Dispatcher-style entrypoints provide CLI-like behavior for operational workflows

---

## 💡 Why This Matters

Parameterized entrypoints are widely used in real container deployments to:

* adapt configuration per environment (dev vs prod)
* enable safe defaults while supporting overrides
* enforce validation and predictable behavior
* integrate with orchestrators (OpenShift/Kubernetes) using env vars and command args

---

## 🌍 Real-World Applications

* Production containers that enable debug logs only in development
* Runtime configuration using env vars injected by Kubernetes
* Startup scripts that run migrations, generate configs, then launch an app
* Containers that behave like CLI tools (`start/stop/status`) for operations

---

## ✅ Result

* Built and tested a parameterized ENTRYPOINT script in multiple patterns:

  1. startup context logging
  2. CMD argument execution via `exec "$@"`
  3. ENV_MODE-based runtime branching
  4. dispatcher-style command handler
* Verified all behaviors through repeated runs and overrides

✅ Lab completed successfully on a cloud lab environment.
