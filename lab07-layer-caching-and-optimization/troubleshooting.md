# 🛠️ Troubleshooting Guide — Lab 07: Layer Caching and Optimization

> This document covers common issues when building baseline vs optimized images, analyzing layers, using cache, and performing multi-stage builds.

---

## 1) `podman build` fails due to network/package errors
### ✅ Symptom
Build fails during:
- `apt-get update`
- `apt-get install`
- `pip install`

### 📌 Likely Cause
- No internet/DNS issues
- Repository temporary failures
- Proxy/firewall restrictions

### ✅ Fix
1) Verify connectivity:
```bash
ping -c 3 8.8.8.8
ping -c 3 google.com
````

2. Retry build with debug output:

```bash id="x6xob1"
podman --log-level=debug build -t myapp:initial -f Dockerfile.initial .
```

---

## 2) Image size doesn’t reduce as expected after optimization

### ✅ Symptom

Optimized image is not much smaller than initial.

### 📌 Likely Cause

* Cleanup not happening in the same layer
* Extra cache-bust layers added
* Base image size dominates

### ✅ Fix

Ensure cleanup happens inside the same `RUN` statement:

```dockerfile
RUN apt-get update && \
    apt-get install -y ... && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

Confirm sizes:

```bash id="g93v4x"
podman images myapp:*
```

---

## 3) Cache is not used when rebuilding

### ✅ Symptom

Rebuild re-runs every step instead of showing “Using cache”.

### 📌 Likely Cause

* Build context changes triggered rebuild
* Cache disabled or storage reset
* Dockerfile instruction order causes invalidation

### ✅ Fix

1. Ensure stable steps happen before changing files:

* install dependencies first
* copy source code later

2. Avoid changing Dockerfile frequently if testing cache:

```bash id="m1z0u7"
podman build -t myapp:optimized -f Dockerfile.optimized .
```

3. If you forced rebuild previously:

* `--no-cache` disables caching; avoid it unless needed

---

## 4) Cache-bust step doesn’t behave as expected

### ✅ Symptom

Cache-bust doesn’t force rebuild or always rebuilds too much.

### 📌 Likely Cause

* `ARG`/`RUN` placed incorrectly
* Cache bust value not changing

### ✅ Fix

Place `ARG` after `FROM` and reference it:

```dockerfile
ARG CACHEBUST=1
RUN echo "Cache bust: $CACHEBUST"
```

Build with a changing value:

```bash id="e9c1x7"
podman build -t myapp:optimized --build-arg CACHEBUST=$(date +%s) -f Dockerfile.optimized .
```

---

## 5) `podman history` output confusing / missing details

### ✅ Symptom

Layer output shows `<missing>` entries.

### 📌 Likely Cause

This is common when history references parent layers and the builder metadata is normalized.

### ✅ Fix

Use both tools:

```bash id="jv4k9x"
podman history myapp:optimized
podman inspect myapp:optimized
```

---

## 6) `dive` not installable via `apt`

### ✅ Symptom

`sudo apt-get install dive` returns:

* `E: Unable to locate package dive`

### 📌 Likely Cause

Package not in default Ubuntu repositories.

### ✅ Fix (as done in lab)

Install from release `.deb`:

```bash id="a1yxdr"
wget -qO dive.deb https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.deb
sudo dpkg -i dive.deb
dive myapp:optimized
```

---

## 7) Multi-stage build fails: `requirements.txt` not found

### ✅ Symptom

Build fails on:

* `COPY requirements.txt .`

### 📌 Likely Cause

File doesn’t exist in build context.

### ✅ Fix

Create it in the same directory:

```bash id="lbv7j9"
nano requirements.txt
# add:
# flask
```

Confirm:

```bash id="x2d9nq"
ls -l
```

Rebuild:

```bash id="tdvpsn"
podman build -t myapp:multistage -f Dockerfile.multistage .
```

---

## 8) Port conflict when running verification container

### ✅ Symptom

`podman run -p 8080:8080 ...` fails because host port 8080 is already in use.

### 📌 Likely Cause

A previous container (like nginx from Lab 06) is still running and bound to host 8080.

### ✅ Fix

1. Identify running containers:

```bash id="j6p8mr"
podman ps
```

2. Stop/remove the conflicting container:

```bash id="y2xq8v"
podman stop <container_name>
podman rm <container_name>
```

3. Retry run:

```bash id="f9d4d2"
podman run -d -p 8080:8080 myapp:optimized
curl localhost:8080
```

Or choose a different host port:

```bash id="a7qf8k"
podman run -d -p 8081:8080 myapp:optimized
curl localhost:8081
```

---

## ✅ Quick Verification Checklist

* Images built:

  * `podman images myapp:*`
* Cache behavior observed:

  * look for “Using cache” during `podman build`
* Layers inspected:

  * `podman history myapp:optimized`
  * `dive myapp:optimized`
* Container runs and responds:

  * `podman run -d -p 8080:8080 myapp:optimized`
  * `curl localhost:8080`
