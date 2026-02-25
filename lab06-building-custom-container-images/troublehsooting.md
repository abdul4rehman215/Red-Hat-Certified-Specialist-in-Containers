
# 🛠️ Troubleshooting Guide — Lab 06: Building Custom Container Images (Podman)

> This document covers common issues when writing a Containerfile, building an image, running the container, and validating it via HTTP.

---

## 1) `podman: command not found`
### ✅ Symptom
- `podman --version` fails
- Podman commands do not work

### 📌 Likely Cause
Podman is not installed on the system.

### ✅ Fix
Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y podman
````

Fedora/RHEL:

```bash id="eq2t8p"
sudo dnf install -y podman
```

Verify:

```bash id="pcv4mz"
podman --version
```

---

## 2) Build fails: `COPY failed: file not found in build context`

### ✅ Symptom

`podman build` fails at the `COPY index.html ...` step.

### 📌 Likely Cause

* `index.html` does not exist in the current directory (build context)
* Wrong path used in `COPY`

### ✅ Fix

1. Confirm you are in the correct folder:

```bash
pwd
ls -l
```

2. Ensure `index.html` exists:

```bash id="m3o8cg"
echo "<h1>Welcome to My Custom Nginx Container!</h1>" > index.html
ls -l
```

3. Rebuild:

```bash id="p2h2f8"
podman build -t my-custom-nginx .
```

---

## 3) Build fails due to Containerfile syntax issues

### ✅ Symptom

`podman build` stops with errors like:

* unknown instruction
* invalid reference format
* parsing errors

### 📌 Likely Cause

Typos or formatting issues in `Containerfile`.

### ✅ Fix

Open and verify the Containerfile:

```bash id="2gfv9c"
nano Containerfile
```

Minimum expected contents:

* `FROM docker.io/nginx:alpine`
* `ENV AUTHOR="OpenShift Developer"`
* `COPY index.html /usr/share/nginx/html`
* `RUN echo "Container built by $AUTHOR" > /build-info.txt`

---

## 4) Image builds but doesn’t show in `podman images`

### ✅ Symptom

Build finishes, but image not visible.

### 📌 Likely Cause

* build failed silently earlier (less likely)
* different tag used than expected

### ✅ Fix

Check for correct tag:

```bash id="o5l5y9"
podman images
```

Rebuild with explicit tag:

```bash id="v4qmhz"
podman build -t my-custom-nginx:latest .
```

---

## 5) Container doesn’t start / exits immediately

### ✅ Symptom

`podman run -d -p 8080:80 my-custom-nginx` returns a container ID, but container stops quickly.

### 📌 Likely Cause

* Nginx fails to start due to invalid content/config (rare for simple HTML)
* Port conflicts or runtime errors

### ✅ Fix

1. Check all containers:

```bash
podman ps -a
```

2. View container logs:

```bash id="cavwdz"
podman logs <container_id_or_name>
```

---

## 6) Port mapping issues (curl fails / connection refused)

### ✅ Symptom

`curl http://localhost:8080` fails with:

* connection refused
* timeout

### 📌 Likely Cause

* container not running
* port conflict on host (8080 already used)
* firewall restrictions in environment

### ✅ Fix

1. Confirm container is running and port mapping is correct:

```bash id="b0ffdn"
podman ps
```

2. If port is already used, run on another port:

```bash id="slm0dv"
podman run -d -p 8081:80 my-custom-nginx
curl http://localhost:8081
```

3. Check host port listeners:

```bash id="qf1i2s"
ss -tulnp | grep 8080
```

---

## 7) Cleanup (optional best practice)

### ✅ Symptom

Too many leftover containers/images after repeated builds.

### ✅ Fix

Stop containers:

```bash id="92po4w"
podman ps
podman stop <container_name_or_id>
```

Remove containers:

```bash id="k8l2sa"
podman rm <container_name_or_id>
```

Remove images:

```bash id="v5qkdr"
podman rmi localhost/my-custom-nginx:latest
```

---

## ✅ Quick Verification Checklist

* Podman works:

  * `podman --version`
* Build context is correct:

  * `ls -l` shows `Containerfile` and `index.html`
* Image created:

  * `podman images` includes `localhost/my-custom-nginx:latest`
* Container running:

  * `podman ps` shows `Up` with `0.0.0.0:8080->80/tcp`
* Web content served:

  * `curl http://localhost:8080` returns custom HTML
