# 🧪 Lab 34: Retrieving Container Logs and Events

## 🧾 Lab Summary
This lab focused on operational visibility in Podman by exploring **container logs** and **container lifecycle events**. I ran an Nginx container and viewed logs using `podman logs`, streamed logs in real time with `--follow`, and filtered logs by time windows. I also tested alternative log drivers (`json-file` and `journald`) and confirmed log locations/queries. Finally, I monitored Podman events with filters, used events to troubleshoot a failing container that exited before logs were initialized, and demonstrated running Podman with debug-level logging.

---

## 🎯 Objectives
- View and filter container logs using Podman
- Monitor container lifecycle events
- Configure alternative log drivers
- Analyze events for troubleshooting purposes

---

## ✅ Prerequisites
- Podman installed (v3.0+ recommended)
- Basic Linux command-line familiarity
- A running container (created during the lab)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Image Used | `nginx:alpine`, `alpine` |
| Log Drivers | default, `json-file`, `journald` |
| Observability Tools | `podman logs`, `podman events`, `journalctl`, `podman inspect` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab34-retrieving-container-logs-and-events/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman version
* Pulled `nginx:alpine` image for quick log/event testing

---

### ✅ Task 1: Viewing Container Logs

* Started `nginx-container` in detached mode
* Viewed logs using:

  * `podman logs nginx-container`
* Streamed logs in real time using:

  * `podman logs --follow nginx-container`
* Filtered logs by time window:

  * `podman logs --since 5m nginx-container`
* Tested a fixed date range filter:

  * returned no output because container logs were from 2026 (expected)

---

### ✅ Task 2: Configuring Alternative Log Drivers

* Started a container using JSON log driver:

  * `--log-driver json-file`
* Checked log file path:

  * `.HostConfig.LogConfig.Path` returned blank in this environment
  * verified actual path using `.LogPath`
* Started a container using journald logging:

  * `--log-driver journald`
* Viewed container logs in system journal using:

  * `journalctl CONTAINER_NAME=journald-logger`

---

### ✅ Task 3: Monitoring Container Events

* Demonstrated event monitoring output format:

  * `podman events --format "{{.Time}} {{.Type}} {{.Status}}"`
* Created a container (`event-test`) and observed lifecycle events:

  * create → init → start
* Filtered events by:

  * event type (`event=start`)
  * container name (`container=event-test`)
  * time window (`--since`)

---

### ✅ Task 4: Troubleshooting with Logs and Events

* Ran a failing container (`/bin/nonexistent-command`) to simulate startup failure
* Observed realistic behavior:

  * `podman logs` was empty because container exited before log driver initialized
* Used events to confirm failure lifecycle:

  * create → init → die
* Ran another container with Podman debug logging enabled:

  * `--log-level=debug`
* Verified container logs after startup

---

## ✅ Verification & Validation

* Confirmed Nginx startup logs visible via `podman logs`
* Confirmed log streaming via `--follow`
* Confirmed time filtering worked and fixed historical filter returned no output as expected
* Confirmed `json-file` log file path exists via `.LogPath`
* Confirmed journald log visibility via `journalctl CONTAINER_NAME=...`
* Confirmed events stream captured create/init/start lifecycle
* Confirmed failing container showed `die` event even when logs were empty
* Confirmed debug-level Podman output displayed runtime debug messages

---

## 🧠 What I Learned

* `podman logs` is the first stop for container runtime visibility
* `--follow`, `--since`, and `--until` are practical tools for narrowing log windows
* Different log drivers affect where logs are stored and how they’re queried
* `podman events` is extremely useful for lifecycle debugging (especially fast failures)
* Some containers can exit before logs are written; events still record what happened
* Debug-level Podman output helps troubleshoot runtime and OCI execution issues

---

## 💡 Why This Matters

Logs + lifecycle events are foundational for:

* diagnosing crashes
* validating deployments
* monitoring runtime changes
* incident response workflows
  These skills map directly to production troubleshooting and platform operations.

---

## ✅ Result

* Viewed, streamed, and filtered container logs
* Configured and verified `json-file` and `journald` logging paths
* Monitored container lifecycle events with filtering
* Troubleshot a failing container using events when logs were unavailable
* Cleaned up all created containers

✅ Lab completed successfully on a cloud lab environment.
