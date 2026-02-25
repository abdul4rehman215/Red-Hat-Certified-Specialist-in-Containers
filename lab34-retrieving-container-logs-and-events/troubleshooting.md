# 🛠️ Troubleshooting Guide — Lab 34: Container Logs and Events (Podman)

> This file covers common problems when viewing logs, using log drivers, and troubleshooting using `podman events`.

---

## 1) `podman logs` shows nothing

### ✅ Symptom
You run:
```bash
podman logs <container>
````

and get no output.

### 🔎 Possible Causes

* The application hasn’t written anything to stdout/stderr
* The container exited instantly before logs were produced
* Logging driver configuration differs from expectation

### ✅ Fixes

* Check container state:

  ```bash
  podman ps -a
  ```
* Check exit reason:

  ```bash
  podman inspect --format '{{.State.Status}} {{.State.ExitCode}} {{.State.Error}}' <container>
  ```
* Start an interactive test container that prints output:

  ```bash
  podman run --rm alpine echo "hello logs"
  ```

---

## 2) Container exits before log driver initializes

### ✅ Symptom

You see:

```text id="52p4a7"
Error: container "<name>" has no logs: container exited before logging driver initialized
```

### 🔎 Cause

The container process failed immediately (e.g., invalid binary path). There’s no time to initialize logging.

### ✅ Fixes

* Use events to confirm lifecycle:

  ```bash id="y7j39n"
  podman events --filter container=<name> --since 5m
  ```
* Fix the failing command and rerun:

  ```bash
  podman run --rm alpine /bin/sh -c 'echo ok'
  ```

---

## 3) `podman logs --since/--until` returns no output

### ✅ Symptom

Time filtering shows nothing even though you believe logs exist.

### 🔎 Causes

* Wrong time range
* Timestamps are outside requested range
* Container restarted and logs are older/newer than expected

### ✅ Fixes

* Check full logs first:

  ```bash
  podman logs <container>
  ```
* Use a recent window:

  ```bash
  podman logs --since 10m <container>
  ```
* Use local timestamps and correct ISO formatting.

---

## 4) `journalctl CONTAINER_NAME=...` shows nothing

### ✅ Symptom

You query journald but get no logs.

### 🔎 Possible Causes

* Container wasn’t started with `--log-driver journald`
* journald not available or not running in environment
* wrong field name used for filtering

### ✅ Fixes

* Confirm log driver:

  ```bash
  podman inspect --format '{{.HostConfig.LogConfig.Type}}' <container>
  ```
* Re-run container with journald:

  ```bash
  podman run -d --name journald-logger --log-driver journald nginx:alpine
  ```
* Query by container name field:

  ```bash
  journalctl CONTAINER_NAME=journald-logger --no-pager | tail
  ```

---

## 5) Log file path is blank in inspect output

### ✅ Symptom

This returns blank:

```bash
podman inspect --format '{{.HostConfig.LogConfig.Path}}' json-logger
```

### 🔎 Cause

Depending on Podman version/storage config, the path field may not be populated.

### ✅ Fix

Use `.LogPath` (worked in this lab):

```bash id="x9f3l5"
podman inspect --format '{{.LogPath}}' json-logger
```

---

## 6) `podman events` shows nothing

### ✅ Symptom

No events appear.

### 🔎 Possible Causes

* No recent container activity
* Missing `--since` window when filtering
* You stopped the stream too early

### ✅ Fixes

* Generate activity (start/stop a container)
* Use a time window:

  ```bash id="q2u2q0"
  podman events --since 5m
  ```
* Remove filters temporarily:

  ```bash
  podman events
  ```

---

## 7) Event filters do not match expected output

### ✅ Symptom

Filtering doesn’t show anything:

```bash
podman events --filter event=start
```

### 🔎 Causes

* No start event happened during the observed timeframe
* Need a `--since` filter for “recent” events

### ✅ Fix

Use:

```bash id="1a0bcz"
podman events --filter event=start --since 10m --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"
```

---

## 8) Debug-level Podman output is noisy

### ✅ Symptom

`--log-level=debug` prints many lines.

### 🔎 Cause

Debug mode logs internal Podman operations (runtime selection, config parsing, etc.).

### ✅ Fix

Use debug only when needed, and capture output for analysis:

```bash
podman --log-level=debug <command> 2>&1 | tee podman-debug.log
```

---

## ✅ Quick Verification Checklist

* View logs:

  ```bash
  podman logs nginx-container
  ```
* Follow logs:

  ```bash
  podman logs --follow nginx-container
  ```
* Filter logs:

  ```bash
  podman logs --since 5m nginx-container
  ```
* JSON log path:

  ```bash
  podman inspect --format '{{.LogPath}}' json-logger
  ```
* Journald logs:

  ```bash
  journalctl CONTAINER_NAME=journald-logger --no-pager | tail
  ```
* Events stream:

  ```bash
  podman events --since 5m --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"
  ```
* Failing container diagnosis:

  ```bash
  podman events --filter container=failing-container --since 5m
  ```
