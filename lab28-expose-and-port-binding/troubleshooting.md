# 🛠️ Troubleshooting Guide — Lab 28: `EXPOSE` and Port Binding

> This file covers common issues when building a web-app container, publishing ports with Podman, validating connectivity, and resolving port conflicts.

---

## 1) Container runs but the app is not reachable from the host

### ✅ Symptom
`curl http://localhost:8080` fails (timeout / connection refused).

### 🔎 Possible Causes
- App is bound to `127.0.0.1` inside container (not accessible externally)
- Container port not published (`-p` missing)
- Wrong host port used
- Container is not running

### ✅ Fixes
- Ensure app binds to `0.0.0.0`:
  ```python
  app.run(host='0.0.0.0', port=8080)
  ```

* Ensure port is published:

  ```bash
  podman run -d -p 8080:8080 --name webapp exposed-app
  ```
* Confirm container is up:

  ```bash
  podman ps
  ```

---

## 2) Port mapping exists but curl still fails

### ✅ Symptom

`podman ps` shows port mapping, but host requests still fail.

### 🔎 Possible Causes

* App crashed inside the container
* Container is exiting immediately
* Firewall/network restrictions in environment

### ✅ Fixes

* Check container logs:

  ```bash
  podman logs webapp
  ```
* Check container state:

  ```bash
  podman ps -a
  ```
* Restart container if needed:

  ```bash
  podman restart webapp
  ```

---

## 3) `ss: command not found` on CentOS 7

### ✅ Symptom

Running:

```bash
ss -tulnp
```

returns:

```text
-bash: ss: command not found
```

### 🔎 Cause

The environment may not have `ss` available in PATH or the tooling may be minimal.

### ✅ Fix

Install or confirm `iproute` package:

```bash id="i0dtpo"
sudo yum install -y iproute
```

---

## 4) Port conflict: `bind: address already in use`

### ✅ Symptom

When running:

```bash
podman run -d -p 8080:8080 --name webapp3 exposed-app
```

you get:

```text
bind: address already in use
```

### 🔎 Cause

Another process is already listening on host port 8080.

### ✅ Fixes

* Identify the process using the port:

  ```bash
  sudo lsof -i :8080
  ```
* Stop that process (example from lab):

  ```bash
  kill <PID>
  ```
* Or use a different host port:

  ```bash
  podman run -d -p 8081:8080 --name webapp3 exposed-app
  ```
* Or use Podman auto-publish:

  ```bash
  podman run -d -P --name webapp4 exposed-app
  podman port webapp4
  ```

---

## 5) Confusion about `EXPOSE`: “I exposed a port but it’s not accessible”

### ✅ Symptom

You used `EXPOSE 8080`, but host cannot connect.

### 🔎 Cause

`EXPOSE` is documentation only. It does not publish ports.

### ✅ Fix

Publish using `-p`:

```bash id="u3dkyq"
podman run -d -p 8080:8080 --name webapp exposed-app
```

---

## 6) `pip install` warnings during build

### ✅ Symptom

Build shows warnings like:

* `WARNING: Running pip as the 'root' user ...`

### 🔎 Explanation

This is a common warning in container builds where pip runs as root during build stage. It doesn’t necessarily break the build.

### ✅ Fix / Best Practice (optional)

In production images, consider:

* using virtual environments
* using non-root user for runtime
* pinning package versions in `requirements.txt`

(For this lab, the build completed successfully.)

---

## 7) `podman stop -a` and `podman rm -a` removes everything

### ✅ Symptom

All containers are stopped/removed.

### 🔎 Cause

The `-a` flag targets **all** containers.

### ✅ Fix

If you want to remove only specific containers:

```bash id="e6tq7f"
podman stop webapp2 webapp4
podman rm webapp2 webapp4
```

---

## ✅ Quick Verification Checklist

* Build image:

  ```bash
  podman build -t exposed-app .
  ```
* Run with port mapping:

  ```bash
  podman run -d -p 8080:8080 --name webapp exposed-app
  ```
* Verify mapping:

  ```bash
  podman ps
  ```
* Test access:

  ```bash
  curl http://localhost:8080
  ```
* If conflict occurs:

  ```bash
  sudo lsof -i :8080
  podman run -d -p 9090:8080 --name webapp2 exposed-app
  ```
* Auto-publish:

  ```bash
  podman run -d -P --name webapp4 exposed-app
  podman port webapp4
  ```
