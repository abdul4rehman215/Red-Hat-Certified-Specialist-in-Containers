# 🛠️ Troubleshooting Guide — Lab 13: Troubleshooting Containers (Podman)

> This document summarizes the most common issues encountered when diagnosing containers using logs, inspect, stats, and exec—plus fixes demonstrated in the lab.

---

## 1) Container won’t start or exits immediately
### ✅ Symptom
- `podman ps` does not show the container running
- `podman ps -a` shows `Exited` with an exit code

### ✅ Fix
1) Check full container list and status:
```bash
podman ps -a
````

2. Inspect exit code and error:

```bash id="3m6h8n"
podman inspect <container> | head -n 80
```

3. Check logs:

```bash id="s3l8wg"
podman logs <container>
```

---

## 2) Logs are empty or don’t show what you expect

### ✅ Symptom

`podman logs <container>` shows nothing.

### 📌 Likely Cause

* Container may not be producing stdout/stderr logs
* Container may not have started successfully
* No traffic yet (for web apps)

### ✅ Fix

1. Ensure container is running:

```bash id="f6o6d0"
podman ps
```

2. View recent logs:

```bash id="g1eq6u"
podman logs --since 5m <container>
```

3. Tail last lines:

```bash id="90h9ow"
podman logs --tail 50 <container>
```

4. Generate traffic for web apps:

```bash id="1x9x5j"
curl http://localhost:<host_port>
```

---

## 3) Need real-time logs but `-f` hangs

### ✅ Symptom

`podman logs -f <container>` keeps running and looks “stuck”.

### ✅ Explanation

That’s expected: follow mode waits for new log lines.

### ✅ Fix

Press `Ctrl+C` to exit follow mode.

---

## 4) Port binding failure (host port already in use)

### ✅ Symptom

Container fails to start with port binding error.

### ✅ Fix

1. Check if port is in use:

```bash id="75d1me"
ss -tulnp | grep 8080 || true
```

2. Stop/remove the container using the port:

```bash id="8e8xw3"
podman ps
podman stop <container_name>
podman rm <container_name>
```

3. Or choose a different host port:

```bash id="03h8ab"
podman run -d -p 8081:80 nginx:alpine
```

---

## 5) `podman exec` fails: container state improper

### ✅ Symptom

`podman exec` returns an error indicating the container isn’t running.

### ✅ Fix

1. Confirm state:

```bash id="2c5d2q"
podman ps -a
```

2. Start or recreate the container:

```bash id="e8d8b5"
podman start <container_name>
```

3. Then exec:

```bash id="5m1y6b"
podman exec -it <container_name> /bin/sh
```

---

## 6) Shell not found (`/bin/sh` or `/bin/bash`)

### ✅ Symptom

Exec command fails because shell doesn’t exist.

### ✅ Fix

Try alternatives:

```bash id="9x2d3h"
podman exec -it <container> /bin/sh
podman exec -it <container> /bin/bash
```

If neither exists, exec a specific binary (like `ls`) to explore:

```bash id="8x4e5u"
podman exec -it <container> ls /
```

---

## 7) Missing tools inside minimal images (curl not found)

### ✅ Symptom

Inside container:

* `curl: not found`

### ✅ Fix (as demonstrated)

Alpine uses `apk`:

```bash
apk add --no-cache curl
```

Then retry:

```bash id="v7u3m7"
curl -s localhost | head
```

---

## 8) High resource usage / runaway container

### ✅ Symptom

Container is slow or unresponsive.

### ✅ Fix

Check stats:

```bash id="2v5c8t"
podman stats <container>
```

Then inspect processes inside:

```bash id="2x5z2m"
podman exec -it <container> ps aux
```

---

## 9) Disk usage / storage pressure

### ✅ Symptom

Builds or pulls fail due to storage limits.

### ✅ Fix

Check disk usage breakdown:

```bash id="o3e9b4"
podman system df
```

Then cleanup unused resources carefully:

* remove unused containers/images/volumes as needed

---

## ✅ Quick Verification Checklist

* Is it running?

  * `podman ps -a`
* What are the logs saying?

  * `podman logs --tail 50 <container>`
* What’s the exit code and error?

  * `podman inspect <container>`
* Is it resource constrained?

  * `podman stats <container>`
* Can I debug inside?

  * `podman exec -it <container> /bin/sh`
