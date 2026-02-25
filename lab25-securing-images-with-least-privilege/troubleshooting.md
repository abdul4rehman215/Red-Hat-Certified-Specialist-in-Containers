# 🛠️ Troubleshooting Guide — Lab 25: Securing Images with Least Privilege

> This file documents common issues that may occur while scanning images, cleaning caches, building Alpine-based images, running Nginx as non-root, and signing images with GPG.

---

## 1) `podman scan` fails or produces no results

### ✅ Symptom
- `podman scan nginx:latest` fails with an error
- scan output is empty
- scanner not available

### 🔎 Possible Causes
- scanning backend not installed/configured (environment-dependent)
- outdated Podman or missing helper tools
- restricted network access for fetching vulnerability databases

### ✅ Fixes
- Confirm Podman version:
  ```bash
  podman --version
  ```

* Retry scan after pulling image again:

  ```bash
  podman pull nginx:latest
  podman scan nginx:latest
  ```
* If scan requires additional components in your environment, install/configure them according to your platform policy.

---

## 2) Image pull fails (`nginx:latest` or `alpine:latest`)

### ✅ Symptom

Errors like:

* `TLS handshake timeout`
* `connection refused`
* `unable to pull image`

### 🔎 Possible Causes

* network/DNS issues
* registry unreachable
* temporary downtime

### ✅ Fixes

* Check connectivity:

  ```bash
  ping -c 2 8.8.8.8
  ping -c 2 docker.io
  ```
* Retry pull:

  ```bash
  podman pull docker.io/library/nginx:latest
  ```

---

## 3) Cache cleanup doesn’t reduce image size significantly

### ✅ Symptom

After removing `/var/lib/apt/lists/*`, image size only drops slightly.

### 🔎 Explanation

Cache removal usually saves a bit of space, but the base image + installed software still dominates size. However, cleanup still reduces:

* filesystem noise
* leftover metadata
* potential surface area

### ✅ Fix / Improvement

Combine update + install + cleanup in a single `RUN` step (for images where you install packages). For this lab, the cache cleanup was still valid as a hardening step.

---

## 4) Alpine build fails during `apk add`

### ✅ Symptom

`apk add --no-cache nginx` fails with repository fetch errors.

### 🔎 Possible Causes

* mirror unreachable
* transient network issue

### ✅ Fixes

* Force clean rebuild:

  ```bash
  podman build --no-cache -t nginx_alpine .
  ```
* Retry later or switch Alpine tag (more stable than `latest`):

  ```dockerfile
  FROM alpine:3.20
  ```

---

## 5) Nginx fails to start as non-root user

### ✅ Symptom

Container exits quickly or logs indicate permission problems.

### 🔎 Common Causes

* cannot bind to port 80 (privileged port)
* missing write permissions on `/var/lib/nginx` or `/var/run/nginx`
* required directories not created or not owned by the non-root user

### ✅ Fixes

* Ensure directories exist and are owned correctly:

  ```dockerfile
  RUN mkdir -p /var/lib/nginx /var/run/nginx && \
      chown -R nginxuser:nginxuser /var/lib/nginx /var/run/nginx
  ```
* Allow binding to port 80 without root using minimal capability:

  ```dockerfile
  RUN apk add --no-cache libcap && \
      setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx
  ```
* Alternative: run Nginx on an unprivileged port (like 8080 inside container) and map externally.

---

## 6) `setcap: not found` or capability assignment fails

### ✅ Symptom

`setcap` command not found or fails during build.

### 🔎 Cause

`setcap` is provided by `libcap` tools on Alpine.

### ✅ Fix

Install `libcap`:

```dockerfile id="1m17lx"
RUN apk add --no-cache nginx libcap && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx
```

---

## 7) `podman image sign` fails (GPG/signing issues)

### ✅ Symptom

Signing errors, missing key, or GPG not configured.

### 🔎 Possible Causes

* no GPG key exists yet
* GPG home not initialized
* permissions restrictions (sigstore location depends on environment)

### ✅ Fixes

* Confirm GPG is installed:

  ```bash
  gpg --version | head -n 2
  ```
* Generate a key (batch mode example used in this lab):

  ```bash
  gpg --batch --gen-key keyparams
  ```
* Then sign again:

  ```bash
  podman image sign --sign-by your@email.com nginx_nonroot
  ```

---

## 8) `podman image trust show` doesn’t show the signed image

### ✅ Symptom

Trust output doesn’t include the expected signed entry.

### 🔎 Possible Causes

* signing step failed silently
* signing stored in a different location based on runtime storage
* image name mismatch (`localhost/nginx_nonroot` vs `nginx_nonroot`)

### ✅ Fixes

* Re-run signing carefully with correct image reference:

  ```bash
  podman image sign --sign-by your@email.com localhost/nginx_nonroot:latest
  ```
* Verify trust again:

  ```bash
  podman image trust show
  ```

---

## 9) Cleanup fails because container is still running

### ✅ Symptom

`podman rmi` fails because image is in use.

### 🔎 Cause

Container `secure_nginx` still exists or is running.

### ✅ Fix

Stop and remove container first:

```bash id="i0jday"
podman stop secure_nginx
podman rm secure_nginx
```

Then remove images:

```bash id="o3e5ng"
podman rmi nginx nginx_clean nginx_alpine nginx_nonroot
```

---

## ✅ Quick Verification Checklist

* Scan works:

  ```bash
  podman scan nginx:latest
  ```
* Cleaned image exists and is smaller:

  ```bash
  podman images | grep -E 'nginx_clean|nginx'
  ```
* Alpine image is small:

  ```bash
  podman images | grep nginx_alpine
  ```
* Non-root Nginx runs as nginxuser:

  ```bash
  podman exec secure_nginx ps aux
  ```
* Trust store shows signature:

  ```bash
  podman image trust show
  ```
