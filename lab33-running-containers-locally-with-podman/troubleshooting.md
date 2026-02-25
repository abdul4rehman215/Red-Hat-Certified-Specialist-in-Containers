# 🛠️ Troubleshooting Guide — Lab 33: Running Containers Locally with Podman

> This file covers common runtime issues when running containers in foreground/detached modes, publishing ports, using volumes, overriding users, and inspecting containers.

---

## 1) `sudo: dnf: command not found`

### ✅ Symptom
Running:
```bash
sudo dnf install -y podman
````

returns:

```text id="t4y93c"
sudo: dnf: command not found
```

### 🔎 Cause

CentOS 7 typically uses `yum` instead of `dnf`.

### ✅ Fix

Use:

```bash id="5dtpql"
sudo yum install -y podman
```

---

## 2) Container exits immediately

### ✅ Symptom

You run a container and it stops right away.

### 🔎 Cause

The container’s main process ends, so the container stops (normal container behavior).

### ✅ Fixes

* Check what command is running:

  ```bash
  podman ps -a
  ```
* Check container logs:

  ```bash
  podman logs <container_name>
  ```
* For “keep-alive” testing, run a long-lived command:

  ```bash
  podman run -d alpine tail -f /dev/null
  ```

---

## 3) Foreground container stops when you press `Ctrl+C`

### ✅ Symptom

Nginx stops when you hit `Ctrl+C`.

### 🔎 Cause

Foreground mode is attached to your terminal. `Ctrl+C` sends SIGINT to the container process, causing it to shut down.

### ✅ Fix

Run in detached mode:

```bash id="bmxkpi"
podman run -d --name background-container nginx
```

---

## 4) Port binding conflict (`address already in use`)

### ✅ Symptom

Running:

```bash id="dw95l8"
podman run -d -p 8080:80 --name webapp nginx
```

fails with an “already in use” error.

### 🔎 Cause

Another process or container is already using host port `8080`.

### ✅ Fixes

* Check port usage:

  ```bash
  ss -tulnp | grep 8080
  ```
* Use a different host port:

  ```bash
  podman run -d -p 8081:80 --name webapp nginx
  ```
* Stop/remove conflicting container:

  ```bash
  podman ps
  podman stop <name>
  podman rm <name>
  ```

---

## 5) Container name conflict (`name is in use`)

### ✅ Symptom

You see:

```text
Error: name "webapp" is in use: container already exists
```

### 🔎 Cause

A container with that name already exists (running or stopped).

### ✅ Fix

Remove the old container:

```bash id="p3m0yo"
podman rm -f webapp
```

Or choose a new name:

```bash id="lx72x7"
podman run -d --name webapp2 -p 8080:80 nginx
```

---

## 6) `curl` fails even though container is running

### ✅ Symptom

`curl http://localhost:8080` fails or times out.

### 🔎 Possible Causes

* Port not published
* Wrong host port
* Service inside container not listening
* Network restrictions in environment

### ✅ Fixes

* Confirm port mapping:

  ```bash
  podman ps
  ```
* Confirm Nginx is healthy with logs:

  ```bash
  podman logs webapp
  ```
* Ensure you used the correct mapping:

  ```bash
  podman run -d -p 8080:80 nginx
  ```

---

## 7) `whoami: unknown uid 1000`

### ✅ Symptom

Running with a numeric UID:

```bash
podman run --rm --user 1000 alpine whoami
```

returns:

```text
whoami: unknown uid 1000
```

### 🔎 Cause

The container doesn’t have a username entry for UID 1000 in `/etc/passwd`.

### ✅ Fixes

* Use a known user:

  ```bash id="nkh9ii"
  podman run --rm --user nobody alpine whoami
  ```
* Or create a user inside a custom image (Dockerfile/Containerfile) if you need a named account.

---

## 8) Volume mount appears empty

### ✅ Symptom

`podman exec vol-container ls /data` shows nothing.

### 🔎 Cause

A newly created volume is empty by default (this is normal).

### ✅ Fix

Write data into it to confirm persistence:

```bash id="5m8c0x"
podman exec vol-container sh -c "echo test > /data/file.txt"
podman exec vol-container cat /data/file.txt
```

---

## 9) `podman inspect` output is too large / hard to read

### ✅ Symptom

`podman inspect` prints a lot of JSON.

### ✅ Fix

Use filters or format output:

```bash id="sb4d2g"
podman inspect webapp | head -n 25
```

Or use formatted output for specific fields:

```bash id="evu0kw"
podman inspect --format '{{.State.Status}}' webapp
```

---

## ✅ Quick Verification Checklist

* Running containers:

  ```bash
  podman ps
  ```
* Port mapping visible:

  ```bash
  podman ps
  ```
* HTTP works:

  ```bash
  curl -I http://localhost:8080
  ```
* Logs show service started:

  ```bash
  podman logs webapp | tail
  ```
* Stats snapshot:

  ```bash
  podman stats --no-stream
  ```
* Clean shutdown + cleanup:

  ```bash
  podman stop -a
  podman rm -a
  podman volume rm mydata
  ```
