# 🛠️ Troubleshooting — Lab 08: Environment Variables in Images (ENV + ARG)

> This document covers common issues when using `ENV`, `ARG`, runtime overrides, env files, and inspection using `podman exec`.

---

## 1) Podman not installed / `podman: command not found`
### ✅ Symptom
- `podman --version` fails

### 📌 Likely Cause
Podman is not installed or not available in PATH.

### ✅ Fix
Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y podman
````

Verify:

```bash id="bxx4vr"
podman --version
```

---

## 2) Build fails when pulling UBI base image

### ✅ Symptom

`podman build` fails on:

* `FROM registry.access.redhat.com/ubi8/ubi-minimal`

### 📌 Likely Cause

* No internet access
* Registry blocked by firewall/proxy
* Temporary registry issues

### ✅ Fix

1. Check connectivity:

```bash id="8m7kcf"
ping -c 3 registry.access.redhat.com
```

2. Try pulling manually to confirm access:

```bash id="8m0n5h"
podman pull registry.access.redhat.com/ubi8/ubi-minimal:latest
```

3. Re-run build:

```bash id="pqsj96"
podman build -t env-demo .
```

---

## 3) ENV variables not applied as expected

### ✅ Symptom

Container output does not reflect expected environment values.

### 📌 Likely Cause

* Incorrect ENV syntax
* Quoting/escaping mistakes
* Spaces around `=` (in env files)

### ✅ Fix

1. Validate Containerfile contents:

```bash id="a7f0c6"
cat Containerfile
```

2. Ensure ENV format is correct:

```dockerfile
ENV KEY="value" \
    KEY2="value2"
```

3. Rebuild:

```bash id="x1l0fj"
podman build -t env-demo .
```

---

## 4) Runtime overrides not working with `-e`

### ✅ Symptom

You run with `-e` but output still shows old values.

### 📌 Likely Cause

* Wrong variable name (typo)
* CMD isn’t using those variables
* Shell expansion issues

### ✅ Fix

1. Ensure variable names match exactly:

```bash id="9v8p0h"
podman run -e APP_ENV="production" -e APP_VERSION="2.0" env-demo
```

2. Confirm CMD references the same variables in Containerfile:

```bash id="pg3f7s"
cat Containerfile
```

---

## 5) `--env-file` variables not loaded

### ✅ Symptom

`podman run --env-file=app.env env-demo` does not reflect env file values.

### 📌 Likely Cause

* Wrong file path
* Invalid formatting (spaces, quotes, missing KEY=VALUE)
* Windows line endings (sometimes)

### ✅ Fix

1. Validate env file format:

```bash id="m5v2xw"
cat app.env
```

2. Ensure each line is exactly:

```text
KEY=value
```

3. Re-run:

```bash id="e0v7tr"
podman run --env-file=app.env env-demo
```

---

## 6) `podman exec` fails: "can only exec into running containers"

### ✅ Symptom

`podman exec env-container env` returns:

* `container state improper`
* or similar error

### 📌 Likely Cause

The container already exited (example: CMD is `echo ...` so it finishes immediately).

### ✅ Fix

Run a long-lived command, then exec:

```bash id="qk1p4d"
podman rm env-container
podman run -d --name env-container env-demo sh -c 'sleep 300'
podman exec env-container env
```

---

## 7) ARG value not visible at runtime

### ✅ Symptom

You pass `--build-arg APP_BUILD_NUMBER=42` but container output does not show it.

### 📌 Likely Cause

`ARG` is build-time only unless copied into `ENV`.

### ✅ Fix

Set an ENV from the ARG:

```dockerfile
ARG APP_BUILD_NUMBER
ENV APP_BUILD=$APP_BUILD_NUMBER
```

Build again:

```bash id="ky1q8h"
podman build --build-arg APP_BUILD_NUMBER=42 -t arg-demo .
podman run arg-demo
```

---

## 8) Cleanup command removes more than expected

### ✅ Symptom

`podman rm -f $(podman ps -aq)` removes all containers, not only lab-related.

### 📌 Likely Cause

The command targets **all container IDs** on the host.

### ✅ Fix

Use a narrower cleanup approach if needed:

* remove only named containers:

```bash id="n8b0az"
podman rm -f env-container
```

* or list containers first:

```bash id="8l1v2s"
podman ps -a
```

---

## ✅ Quick Verification Checklist

* Image builds:

  * `podman build -t env-demo .`
* Default env output:

  * `podman run env-demo`
* Runtime overrides:

  * `podman run -e ... env-demo`
  * `podman run --env-file=app.env env-demo`
* Exec inspection works:

  * `podman run -d ... sleep 300`
  * `podman exec env-container env`
* ARG build works:

  * `podman build --build-arg APP_BUILD_NUMBER=42 -t arg-demo .`
  * `podman run arg-demo`
