# 🧪 Lab 13: Troubleshooting Containers (Podman)

## 📌 Lab Summary
This lab focuses on practical container troubleshooting using Podman. It covers:
- Viewing container logs (standard, follow mode, time-based filters, tail)
- Inspecting container state and runtime configuration
- Checking container resource usage (CPU, memory, I/O)
- Using `podman exec` to debug inside a running container
- Handling common “minimal image” debugging issues (missing tools like `curl`)
- Verifying runtime behavior via HTTP checks

The lab uses `nginx:alpine` as a realistic example because it’s a minimal image and frequently used in container environments.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Diagnose container issues using logs and inspection tools
- Filter logs by time and number of lines
- Inspect container state (running, exit code, ports, entrypoint/CMD)
- Use `podman exec` to debug inside the container shell
- Validate service health from inside the container

---

## ✅ Prerequisites
- Basic CLI knowledge
- Podman installed
- A running container (created during lab)

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | 4.9.3 |
| Test Image | `docker.io/library/nginx:alpine` |
| Test Container | `nginx-test` |
| Host Port | `8080` → container `80` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab13-troubleshooting-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── notes.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Lab Setup (Create a Debug Target)

* Verified Podman is installed
* Pulled Nginx Alpine image
* Verified host port 8080 was free
* Started a test container with port mapping:

  * `8080:80`

### ✅ Task 1: View Container Logs with Filters

* Viewed logs:

  * `podman logs nginx-test`
* Followed logs in real-time:

  * `podman logs -f nginx-test`
* Filtered logs since last 5 minutes:

  * `podman logs --since 5m nginx-test`
* Viewed last 10 lines:

  * `podman logs --tail 10 nginx-test`

### ✅ Task 2: Inspect Container State and Resource Usage

* Listed running containers:

  * `podman ps`
* Inspected container details:

  * `podman inspect nginx-test`
* Checked resource usage:

  * `podman stats nginx-test`

### ✅ Task 3: Debug Inside Container Using exec

* Opened a shell inside the container:

  * `podman exec -it nginx-test /bin/sh`
* Checked running processes:

  * `ps aux`
* Viewed Nginx configuration:

  * `cat /etc/nginx/nginx.conf`
* Tested service health:

  * attempted `curl localhost`
  * installed curl (because minimal images often don’t include it)
  * successfully fetched default Nginx page

### ✅ Extra Practice: Disk Usage and Cleanup

* Checked Podman disk usage:

  * `podman system df`
* Cleaned up:

  * stopped and removed container

---

## ✅ Verification & Validation

* Container logs displayed expected Nginx startup output
* Container state confirmed as `running` in `podman inspect`
* Port mapping confirmed (`0.0.0.0:8080->80/tcp`)
* `podman stats` showed low resource usage
* Inside-container validation returned Nginx welcome page HTML

---

## 🧠 What I Learned

* Logs are usually the first place to start (`podman logs`)
* `--since` and `--tail` help isolate the relevant log window
* `podman inspect` reveals runtime config: entrypoint, cmd, env, ports, state
* `podman exec` enables “inside-the-container” debugging
* Minimal images often omit tools—installing temporary tools is a common debugging workflow
* `podman system df` provides a quick summary of disk usage (images, containers, volumes)

---

## 🌍 Why This Matters

Troubleshooting skills are essential for:

* resolving container startup failures
* identifying misconfigurations (ports, env vars, entrypoints)
* diagnosing performance and resource issues
* validating service health during deployments and incident response

This aligns directly with real-world container operations in OpenShift/Kubernetes environments.

---

## ✅ Result

* Successfully diagnosed and validated a running container using logs, inspect, stats, and exec
* Verified service behavior from inside the container
* Cleanly stopped and removed the debug target container after testing

---

## ✅ Conclusion

This lab built a practical troubleshooting workflow for containers: start with logs, verify state and configuration with inspect, check resource usage with stats, and finally debug inside the container with exec. These steps form a reliable repeatable process for debugging real container workloads.
