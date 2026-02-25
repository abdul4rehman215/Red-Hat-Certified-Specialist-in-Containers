# 🛠️ Troubleshooting Guide — Lab 02: Using `RUN` Instruction Efficiently

> This file captures common issues you may hit while working with `RUN` instructions, Alpine `apk`, Ubuntu `apt`, and Podman builds.

---

## 1) `podman build` fails due to network / registry issues

### ✅ Symptom
- Build hangs while pulling base images
- Errors like `connection timed out`, `TLS handshake timeout`, or `unable to pull image`

### 🔎 Possible Causes
- No internet access in the lab VM
- DNS resolution problems
- Registry temporarily unreachable

### ✅ Fixes
- Test connectivity:
  ```bash
  ping -c 2 8.8.8.8
````

* Test DNS:

  ```bash
  ping -c 2 docker.io
  ```
* Retry the build:

  ```bash
  podman build -t run-lab-shell .
  ```

---

## 2) Alpine `apk add` fails (repository fetch errors)

### ✅ Symptom

During build you see errors while fetching APKINDEX, for example:

* `fetch ... APKINDEX.tar.gz`
* failure to download packages

### 🔎 Possible Causes

* Alpine mirror temporarily down
* Network instability
* Proxy restrictions

### ✅ Fixes

* Retry build (often transient):

  ```bash
  podman build --no-cache -t run-lab-shell .
  ```
* If needed, change Alpine version/tag instead of `latest`:

  ```dockerfile
  FROM alpine:3.20
  ```

---

## 3) `apt-get update` / `apt-get install` fails on Ubuntu base image

### ✅ Symptom

Errors like:

* `Temporary failure resolving 'archive.ubuntu.com'`
* `Failed to fetch`
* `Hash Sum mismatch`

### 🔎 Possible Causes

* DNS issues
* Repository mirror issues
* Cached metadata problems

### ✅ Fixes

* Try rebuild without cache:

  ```bash
  podman build --no-cache -t optimized-nginx .
  ```
* Validate network + DNS:

  ```bash
  ping -c 2 archive.ubuntu.com
  ```

---

## 4) Large image size even after cleanup

### ✅ Symptom

Image still feels large (example: Ubuntu + nginx ≈ 82MB+)

### 🔎 Cause

* Ubuntu base is already significantly larger than Alpine
* Nginx pulls dependencies and base packages

### ✅ Fixes / Improvements

* Use a smaller base image if appropriate (case-dependent):

  * Debian slim variants
  * Alpine (if compatible)
* Verify layer count and where size comes from:

  ```bash
  podman history optimized-nginx
  ```

---

## 5) Cleanup not effective when split across multiple `RUN` instructions

### ✅ Symptom

You remove `/var/lib/apt/lists/*` but image size doesn’t improve much.

### 🔎 Cause

If you do:

```dockerfile
RUN apt-get update
RUN apt-get install -y nginx
RUN rm -rf /var/lib/apt/lists/*
```

the cache can remain in earlier layers and still contribute to final image size.

### ✅ Fix

Combine into one `RUN`:

```dockerfile
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*
```

---

## 6) Cache-related confusion during testing

### ✅ Symptom

You update Dockerfile but builds appear to “reuse old results”.

### 🔎 Cause

Podman uses build cache for layers when it detects no changes.

### ✅ Fix

Force a clean rebuild:

```bash
podman build --no-cache -t optimized-nginx .
```

---

## 7) Permission issues during build

### ✅ Symptom

Errors related to storage drivers, mounts, or permissions.

### 🔎 Possible Causes

* Rootless Podman storage configuration
* Limited privileges in the environment

### ✅ Fixes

* Check Podman info:

  ```bash
  podman info
  ```
* If your environment requires elevated privileges, you may need to run Podman with appropriate permissions (lab-policy dependent).

---

## ✅ Quick Verification Checklist

Use this checklist to confirm your optimization is working:

* Shell form image build works:

  ```bash
  podman build -t run-lab-shell .
  ```

* Exec form image build works:

  ```bash
  podman build -t run-lab-exec .
  ```

* Optimized image built:

  ```bash
  podman build -t optimized-nginx .
  ```

* Layer reduction visible:

  ```bash
  podman history optimized-nginx
  ```

* Compare sizes:

  ```bash
  podman images
  ```
