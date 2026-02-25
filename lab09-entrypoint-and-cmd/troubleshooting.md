# 🛠️ Troubleshooting Guide — Lab 09: Using ENTRYPOINT and CMD in Containerfiles

> This document covers common issues when working with ENTRYPOINT/CMD combinations, runtime overrides, and script-based entrypoints.

---

## 1) Build fails pulling UBI minimal image (registry access)
### ✅ Symptom
`podman build` fails on:
- `FROM registry.access.redhat.com/ubi9/ubi-minimal`

### 📌 Likely Cause
- Network/DNS issues
- Registry blocked by firewall/proxy
- Temporary registry outage

### ✅ Fix
1) Test connectivity:
```bash
ping -c 3 registry.access.redhat.com
````

2. Try pulling manually:

```bash id="fmr8j6"
podman pull registry.access.redhat.com/ubi9/ubi-minimal:latest
```

3. Re-run build:

```bash id="xcrl6h"
podman build -t entrypoint-demo .
```

---

## 2) CMD override does not work as expected

### ✅ Symptom

You pass arguments after the image name, but output still shows default behavior.

### 📌 Likely Cause

* ENTRYPOINT is not defined (so CMD becomes the command, not arguments)
* Confusion between command vs arguments
* Shell form behavior differs from exec form

### ✅ Fix

Confirm Dockerfile uses exec form:

```bash id="0b0m7x"
cat Containerfile
```

Use runtime override correctly:

```bash id="t4q4s3"
podman run --rm entrypoint-demo "Custom message"
```

---

## 3) Script-based ENTRYPOINT fails with permission denied

### ✅ Symptom

Container fails to start or logs show:

* `permission denied`

### 📌 Likely Cause

* Script not executable on host before copy
* Incorrect shebang or missing interpreter
* Wrong file permissions inside image

### ✅ Fix

1. Ensure script is executable:

```bash id="te2mhj"
chmod +x greet.sh
ls -l greet.sh
```

2. Ensure correct shebang:

```sh
#!/bin/sh
```

3. Rebuild:

```bash id="d8m1vm"
podman build -t greet-demo .
```

---

## 4) Script runs but output is wrong (missing args)

### ✅ Symptom

Output shows missing values like:

* `Welcome to  from`

### 📌 Likely Cause

CMD arguments were not provided or overridden incorrectly.

### ✅ Fix

Run with defaults:

```bash id="0vyj7f"
podman run --rm greet-demo
```

Override args correctly:

```bash id="3d8cbr"
podman run --rm greet-demo "Container Workshop" "Instructor"
```

---

## 5) `--entrypoint` override fails or behaves unexpectedly

### ✅ Symptom

Using `--entrypoint` does not behave as expected.

### 📌 Likely Cause

* ENTRYPOINT target not found
* Incorrect quoting or argument placement

### ✅ Fix

Use correct syntax:

```bash id="i2h1w8"
podman run --rm --entrypoint echo greet-demo "This completely replaces the ENTRYPOINT"
```

---

## 6) Shell form behaves differently than exec form

### ✅ Symptom

Shell form commands run through a shell, and behavior differs (quoting, variable expansion, signal handling).

### 📌 Likely Cause

Shell form uses `/bin/sh -c`.

### ✅ Fix / Best Practice

Prefer exec form:

```dockerfile
ENTRYPOINT ["executable", "arg1"]
CMD ["arg2"]
```

Use shell form only when you explicitly need shell features.

---

## 7) Cleanup fails: images still in use

### ✅ Symptom

`podman rmi` fails because image is used by a container.

### ✅ Fix

1. List containers:

```bash id="wzq04f"
podman ps -a
```

2. Remove dependent containers then remove images:

```bash id="a6n2rm"
podman rm <container_id_or_name>
podman rmi entrypoint-demo greet-demo shellform-demo
```

---

## ✅ Quick Verification Checklist

* Default behavior:

  * `podman run --rm entrypoint-demo`
* CMD override:

  * `podman run --rm entrypoint-demo "Custom message"`
* Script entrypoint:

  * `podman run --rm greet-demo`
  * `podman run --rm greet-demo "A" "B"`
* ENTRYPOINT override:

  * `podman run --rm --entrypoint echo greet-demo "text"`
* Shell form behavior:

  * `podman run --rm shellform-demo`

