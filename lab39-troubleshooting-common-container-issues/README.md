# 🧪 Lab 39: Troubleshooting Common Container Issues

## 🧾 Lab Summary
This lab focused on diagnosing and resolving common real-world container problems using Podman on CentOS 7. I worked through four major troubleshooting areas:

1. **Resource constraints** (CPU/memory inspection + live usage + updating limits)
2. **SELinux denials** (audit logs, permissive mode for debugging, relabeling fixes)
3. **Network conflicts** (port binding collisions, namespace inspection, `nsenter` debugging)
4. **Permission issues** (container user context + volume permissions + SELinux relabel via `:Z`)

Each section included hands-on reproduction of the issue and then a practical resolution path. The lab ends with log verification and cleanup.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Diagnose container resource constraints (CPU, memory)
- Identify and resolve SELinux denials
- Troubleshoot network conflicts (port binding, namespace issues)
- Fix permission-related problems in containers

---

## ✅ Prerequisites
- Linux system with Podman installed
- Basic Linux + container concepts
- sudo/root access for SELinux and namespace debugging

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Podman | `3.4.4` |
| Tools Used | `podman inspect`, `podman stats`, `ausearch`, `setenforce`, `chcon`, `ss`, `nsenter` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab39-troubleshooting-common-container-issues/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

> 📝 This lab is mostly command-line troubleshooting. No persistent scripts were created beyond the commands executed.

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Diagnose Resource Constraints

* Started a small test container (`nginx:alpine`) so resource inspection was meaningful
* Checked default runtime limits via `podman inspect` (CPU/memory fields)
* Observed live resource consumption using `podman stats --no-stream`
* Updated runtime memory limit to **512MB** using `podman update --memory 512m`
* Re-verified the new memory value in inspect output

---

### ✅ Task 2: Resolve SELinux Denials

* Queried AVC denials using:

  * `sudo ausearch -m avc -ts recent`
* Temporarily switched SELinux to **Permissive** for debugging:

  * `sudo setenforce 0`
* Reproduced a realistic host path denial scenario using a `~/badmount` directory
* Verified file label was `default_t`, then fixed it with:

  * `sudo chcon -Rt container_file_t /home/centos/badmount`
* Returned SELinux to **Enforcing**:

  * `sudo setenforce 1`

---

### ✅ Task 3: Debug Network Conflicts

* Simulated a port conflict by binding Nginx to host port **8080** (`port1`)
* Confirmed host process listening using:

  * `sudo ss -tulnp | grep 8080`
* Verified conflict when starting a second container on same port (`port2`) → bind error
* Stopped conflicting container to resolve the issue
* Inspected container network namespace path via:

  * `.NetworkSettings.SandboxKey`
* Used `nsenter` with the container PID to inspect interfaces inside container network namespace:

  * `sudo nsenter -n -t <pid> ip a`

---

### ✅ Task 4: Fix Permission Issues

* Checked container user context:

  * `.Config.User` (empty = default user, usually root unless image sets USER)
* Ran an Alpine container explicitly as root for permission testing
* Verified bind mount access using SELinux relabel (`:Z`) and successfully read the protected file:

  * mounted `/home/centos/badmount` into `/data`
  * read `secret.txt` inside container

---

## ✅ Verification & Validation

* Resource checks confirmed memory updated to `536870912` bytes (512MB)
* SELinux denials identified in audit logs and resolved via relabeling (`container_file_t`)
* Port conflict reproduced and verified with `ss`, then resolved by stopping conflicting container
* Network namespace debug output showed container IP and interfaces via `nsenter`
* Volume access verified by listing and reading `secret.txt` inside container
* Final log verification:

  * `podman logs res-test | tail -n 5`

---

## 🧠 What I Learned

* `podman inspect` and `podman stats` quickly reveal resource allocation and real-time usage
* SELinux issues are often caused by incorrect file contexts (e.g., `default_t`) and fixed by relabeling
* Port conflicts are common in shared hosts; verify with `ss` and resolve by freeing ports or changing mappings
* For advanced networking debugging, `SandboxKey` + `nsenter` provides a powerful view inside container namespaces
* Permission issues often involve:

  * container user context
  * host file permissions
  * SELinux labeling (`:Z` is a common fix for bind mounts)

---

## 🔐 Why This Matters (Security Relevance)

These issues are common causes of production outages and security gaps:

* resource exhaustion → downtime / instability
* SELinux denials → blocked access or insecure workarounds (permissive mode)
* port conflicts → failed deployments
* permission errors → misconfigurations that may lead to unsafe “run as root” defaults

This lab reinforces a secure troubleshooting workflow: **observe → confirm → apply minimal fix → re-verify**.

---

## ✅ Result

* Diagnosed CPU/memory defaults and updated container memory limit
* Identified SELinux denials and resolved them correctly with labeling fixes
* Reproduced and resolved port binding conflicts
* Inspected container network namespaces using PID + `nsenter`
* Fixed mount/permission problems using correct SELinux bind mount labeling
* Verified stability using container logs and cleaned up resources

✅ Lab completed successfully on a cloud lab environment.
