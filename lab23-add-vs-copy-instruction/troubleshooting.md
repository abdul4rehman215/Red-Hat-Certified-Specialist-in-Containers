# 🛠️ Troubleshooting Guide — Lab 23: `ADD` vs `COPY`

> This file lists common build and runtime issues you might encounter while testing `ADD` and `COPY`, plus fixes.

---

## 1) Build fails because the file is not found in build context

### ✅ Symptom
Build errors like:
- `stat testfile.txt: no such file or directory`
- `no such file or directory`

### 🔎 Cause
`COPY`/`ADD` can only use files available in the **build context** (the directory you run `podman build` from). If the file isn’t there, the build fails.

### ✅ Fix
- Confirm you are in the correct directory:
  ```bash
  pwd
````

* Confirm file exists:

  ```bash
  ls -l
  ```
* Recreate file if missing:

  ```bash
  echo "This is a test file for COPY instruction" > testfile.txt
  ```

---

## 2) `podman build` fails when pulling `alpine:latest`

### ✅ Symptom

Errors like:

* `connection timed out`
* `unable to pull image`
* `TLS handshake timeout`

### 🔎 Possible Causes

* Network issues / DNS issues
* Registry connectivity problems

### ✅ Fixes

* Test network:

  ```bash
  ping -c 2 8.8.8.8
  ```
* Test DNS:

  ```bash
  ping -c 2 docker.io
  ```
* Retry the build:

  ```bash
  podman build -t copy-demo -f Dockerfile.copy .
  ```

---

## 3) `ADD` archive extraction doesn’t appear to work

### ✅ Symptom

After build, expected extracted files are missing.

### 🔎 Possible Causes

* Archive was not created correctly
* Wrong destination path
* Using unsupported archive format (rare)

### ✅ Fixes

* Recreate the archive:

  ```bash
  tar -czf archive.tar.gz testfile.txt
  ```
* Confirm archive exists:

  ```bash
  ls -lh archive.tar.gz
  ```
* Confirm Dockerfile is correct:

  ```dockerfile
  FROM alpine:latest
  ADD archive.tar.gz /extracted/
  RUN ls -la /extracted/
  ```

---

## 4) `ADD URL` fails to download remote content

### ✅ Symptom

Build step fails during:

```dockerfile
ADD https://... /remote/
```

### 🔎 Possible Causes

* No internet access in the lab environment
* URL typo or file removed
* GitHub/raw content temporarily unavailable

### ✅ Fixes

* Verify URL works from the VM:

  ```bash
  curl -I https://raw.githubusercontent.com/moby/moby/master/README.md
  ```
* Retry build:

  ```bash
  podman build --no-cache -t add-url-demo -f Dockerfile.add-url .
  ```
* If still failing, use a controlled alternative approach:

  * Install `curl` and fetch using `RUN` (when allowed/needed)

---

## 5) Cache doesn’t update after changing `version.txt`

### ✅ Symptom

You edit `version.txt` but rebuild output still shows old content.

### 🔎 Cause

Build cache may be reused.

### ✅ Fix

Force clean build:

```bash id="hcv6zy"
podman build --no-cache -t cache-demo -f Dockerfile.cache .
```

---

## 6) Permission / SELinux related build issues

### ✅ Symptom

Errors about permissions, mounts, or access denial.

### 🔎 Cause

Some environments enforce SELinux or restrictive filesystem rules.

### ✅ Fix (only if environment policy allows)

Temporarily set SELinux to permissive:

```bash
sudo setenforce 0
```

> Note: This is environment-dependent. Only use if permitted in your lab VM and you understand the security implications.

---

## 7) Cleanup command leaves images behind

### ✅ Symptom

After cleanup, one or more images still appear in:

```bash
podman images
```

### 🔎 Cause

The cleanup command did not include all image names. In this lab, `cache-demo-add` was built but not removed in the cleanup command list.

### ✅ Fix

Remove remaining image(s) explicitly:

```bash
podman rmi cache-demo-add
```

---

## ✅ Quick Verification Checklist

Use this to confirm the lab worked end-to-end:

* `COPY` demo prints the file content:

  ```bash
  podman run --rm copy-demo
  ```

* `ADD` demo prints the file content:

  ```bash
  podman run --rm add-demo
  ```

* `ADD` extraction demo shows extracted file:

  ```bash
  podman run --rm add-extract-demo
  ```

* `ADD URL` demo displays remote README:

  ```bash
  podman run --rm add-url-demo
  ```

* Cache behavior updates on rebuild after file change:

  ```bash
  podman build -t cache-demo -f Dockerfile.cache .
  ```
