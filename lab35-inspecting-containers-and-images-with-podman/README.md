# 🧪 Lab 35: Inspecting Containers and Images with Podman

## 🧾 Lab Summary
This lab focused on using `podman inspect` to extract both **runtime container details** and **static image metadata**. I inspected running containers to review state, IP addressing, environment variables, mounts, and port mappings. I also validated troubleshooting techniques using exit codes from a failing container and produced a clean, readable state view using `jq` after installing it with `yum` on CentOS 7. Finally, I cleaned up containers and images created for the lab.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Use `podman inspect` to examine container and image metadata
- Extract and analyze environment variables
- Review volume mounts and network port configurations
- Interpret container status and exit codes for troubleshooting

---

## ✅ Prerequisites
- Linux system with Podman installed
- Basic familiarity with terminal commands
- A container to inspect (created during the lab)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Image Used | `nginx:alpine`, `alpine` |
| Tools | `podman inspect`, `jq` (installed), `tr`, `grep` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab35-inspecting-containers-and-images-with-podman/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Setup

* Confirmed CentOS 7 uses `yum` (dnf not present)
* Verified Podman version
* Pulled `nginx:alpine` for consistent test container behavior

---

### ✅ Task 1: Inspect Container and Image Metadata

* Started a running Nginx container with port mapping:

  * `my_nginx` (`8080:80`)
* Inspected the **container** (`podman inspect my_nginx`) to view:

  * runtime state (running, PID, start time)
  * image name
  * root filesystem layers
* Inspected the **image** (`podman inspect nginx:alpine`) to view:

  * digest, architecture, OS
  * default ENV variables and CMD

**Key concept:**

* image inspection = static configuration
* container inspection = runtime state + config + mounts + networking

---

### ✅ Task 2: Extract Environment Variables

* Ran a container with custom env vars:

  * `APP_COLOR=blue`, `APP_MODE=prod`
* Extracted env list using:

  * `podman inspect env_test --format '{{.Config.Env}}'`
* Attempted Go-template `split` (not supported in this Podman build)
* Used a reliable fallback approach:

  * format output → newline normalization → grep

---

### ✅ Task 3: Review Volume Mounts and Port Mappings

* Created a bind mount container:

  * `/tmp` → `/container_tmp`
* Verified mounts using:

  * `podman inspect vol_test --format '{{.Mounts}}'`
* Verified port mapping structure using:

  * `.NetworkSettings.Ports`
* Extracted only host port for `80/tcp`:

  * returned `8080`

---

### ✅ Task 4: Analyze Container Status and Exit Codes

* Ran a failing container:

  * `fail_test` exits with code 3
* Verified exit code using:

  * `podman inspect fail_test --format '{{.State.ExitCode}}'`
* Installed `jq` (not present initially) using yum
* Printed full `.State` JSON in a readable format:

  * `podman inspect my_nginx --format '{{json .State}}' | jq`

---

## ✅ Verification & Validation

* Confirmed running container state:

  * `.State.Running=true`
  * PID present
* Confirmed container IP address output:

  * `10.88.0.12`
* Confirmed environment injection visible in `.Config.Env`
* Confirmed Go-template limitation and validated working fallback extraction method
* Confirmed mount details show bind mount `/tmp → /container_tmp`
* Confirmed port mapping shows `0.0.0.0:8080 -> 80/tcp`
* Confirmed failing container exit code = `3`
* Confirmed formatted state JSON output via `jq`

---

## 🧠 What I Learned

* `podman inspect` is one of the most powerful troubleshooting commands
* Image metadata (digest, Env, Cmd) helps confirm what’s baked into an image
* Container metadata (State, NetworkSettings, Mounts, Config.Env) shows how it runs at runtime
* Podman Go-template functions vary by version/build → always keep simple fallback methods (grep/tr)
* Exit codes quickly confirm failure conditions and support automation checks
* Tools like `jq` make JSON inspection usable in real operational workflows

---

## 💡 Why This Matters

In real systems, container issues often come down to:

* wrong environment variables
* missing mounts/permissions
* incorrect port publishing
* unexpected exit codes

Inspection is the fastest way to validate runtime configuration and diagnose what’s wrong.

---

## ✅ Result

* Inspected container and image metadata successfully
* Extracted environment variables including custom values
* Verified mounts and port mappings from inspection output
* Diagnosed failures using exit codes and state JSON
* Cleaned up containers and images after completion

✅ Lab completed successfully on a cloud lab environment.

