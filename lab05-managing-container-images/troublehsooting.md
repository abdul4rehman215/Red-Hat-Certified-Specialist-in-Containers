# 🛠️ Troubleshooting Guide — Lab 05: Managing Container Images (Podman)

> This document covers common problems when searching, pulling, inspecting, and removing images using Podman.

---

## 1) `podman search` returns no results or errors
### ✅ Symptom
- Search results are empty unexpectedly
- Errors about registries or connectivity

### 📌 Likely Cause
- No internet connectivity
- DNS issues
- Registry access restrictions

### ✅ Fix
1) Verify connectivity:
```bash
ping -c 3 8.8.8.8
ping -c 3 google.com
````

2. Retry search:

```bash id="79q5bz"
podman search ubuntu
```

3. Enable debug logs if needed:

```bash id="7b7k2m"
podman --log-level=debug search ubuntu
```

---

## 2) Docker Hub rate limiting during pull/search

### ✅ Symptom

* Messages indicating rate limit or auth requirement

### 📌 Likely Cause

Docker Hub can rate-limit anonymous requests.

### ✅ Fix

Authenticate:

```bash id="br1poj"
podman login docker.io
```

✅ Security note:

* Never commit passwords/tokens
* Use environment variables or secret managers in real pipelines

---

## 3) `podman pull` fails due to registry or TLS errors

### ✅ Symptom

* TLS handshake failures
* registry unreachable
* timeout

### 📌 Likely Cause

* Corporate proxy/firewall rules
* DNS issues
* Temporary registry outage

### ✅ Fix

1. Retry with debug:

```bash id="vx9qfi"
podman --log-level=debug pull docker.io/library/ubuntu:latest
```

2. If using proxy environments, ensure proxy variables are set:

* `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`

---

## 4) Image exists but `podman images` doesn't show expected tag

### ✅ Symptom

* Image pulled but tag not listed

### 📌 Likely Cause

* Tag mismatch
* Image pulled by digest or different repo reference

### ✅ Fix

List images and verify repository/tag:

```bash id="v1a6cw"
podman images
```

Search for specific image IDs:

```bash id="6f8r4a"
podman images --no-trunc
```

---

## 5) `podman inspect` output is too large to read

### ✅ Symptom

JSON output is large and difficult to scan.

### ✅ Fix

Pipe to pager:

```bash id="qlp44r"
podman inspect docker.io/library/ubuntu:latest | less
```

Extract specific fields:

```bash id="ly0c1v"
podman inspect --format "{{.Architecture}}" docker.io/library/ubuntu:latest
podman inspect --format "{{.Os}}" docker.io/library/ubuntu:latest
podman inspect --format "{{.Config.Cmd}}" docker.io/library/ubuntu:latest
podman inspect --format "{{.Config.Env}}" docker.io/library/ubuntu:latest
```

---

## 6) `podman rmi` fails because image is in use

### ✅ Symptom

Removal fails with an error indicating the image is used by a container.

### 📌 Likely Cause

One or more containers reference the image.

### ✅ Fix (safe method)

1. Find containers using the image:

```bash id="f8r1ih"
podman ps -a --format "{{.ID}} {{.Image}} {{.Names}}"
```

2. Remove dependent containers, then remove image:

```bash id="nq62ry"
podman rm <container_name_or_id>
podman rmi docker.io/library/ubuntu:20.04
```

### ✅ Fix (force, use carefully)

```bash id="aqdqri"
podman rmi -f <IMAGE_ID>
```

---

## 7) `podman image prune -a` removes more than expected

### ✅ Symptom

Images you wanted to keep are removed.

### 📌 Likely Cause

`-a` removes all images not associated with at least one container.

### ✅ Fix / Best Practice

Before pruning:

```bash id="m4m6vh"
podman images
podman ps -a
```

If you want to keep an image, ensure at least one container references it, or avoid `-a` and prune selectively.

---

## ✅ Quick Verification Checklist

* Search works:

  * `podman search ubuntu`
* Pull works:

  * `podman pull ubuntu:latest`
* Images listed:

  * `podman images`
* Inspect works:

  * `podman inspect ubuntu:latest`
* Removal works:

  * `podman rmi ubuntu:20.04`
* Cleanup:

  * `podman image prune -a`
