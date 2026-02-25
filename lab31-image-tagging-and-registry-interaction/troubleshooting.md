# 🛠️ Troubleshooting Guide — Lab 31: Image Tagging and Registry Interaction

> This guide covers common issues when tagging images, logging into registries, pushing/pulling, and working with digests in Podman.

---

## 1) `podman tag` fails with “image not known” / “no such image”

### ✅ Symptoms
- `Error: image not known`
- `Error: no such image ...`

### 🔎 Cause
The source image name/tag is wrong, or the image was never pulled locally.

### ✅ Fix
1) List images and copy the exact name:
```bash
podman images
````

2. Pull the image explicitly (example for nginx):

```bash
podman pull docker.io/library/nginx:latest
```

3. Tag again using the correct reference:

```bash
podman tag docker.io/library/nginx:latest localhost/my-nginx:v1.0
```

---

## 2) `podman images | grep nginx` shows nothing after tagging

### ✅ Symptoms

* Tag command ran, but `grep` shows no output.

### 🔎 Causes

* You tagged `localhost/my-nginx:v1.0` but grep is filtering incorrectly
* The image name differs (e.g., `my-nginx` not containing the string you grepped)

### ✅ Fix

Use a broader filter:

```bash
podman images | egrep 'nginx|my-nginx'
```

Or list all images:

```bash
podman images
```

---

## 3) `podman login docker.io` fails (auth error)

### ✅ Symptoms

* `Error: authenticating creds for "docker.io": invalid username/password`
* `unauthorized: incorrect username or password`

### 🔎 Causes

* Wrong credentials
* Account uses 2FA (requires access token instead of password)
* Network/DNS issues

### ✅ Fix

* Re-run login and re-enter carefully:

```bash
podman login docker.io
```

* If 2FA enabled on Docker Hub: use a **Docker Hub access token** as password.

* Check connectivity:

```bash
curl -I https://registry-1.docker.io/v2/
```

---

## 4) `podman push` fails with “denied: requested access to the resource is denied”

### ✅ Symptoms

* Push fails with permission/denied errors.

### 🔎 Causes

* Not logged in
* Pushing to a repo you don’t own (wrong username)
* Image not tagged with your Docker Hub namespace

### ✅ Fix

1. Confirm login:

```bash
podman login docker.io
```

2. Tag correctly with your namespace:

```bash
podman tag localhost/my-nginx:v1.0 docker.io/<your_username>/my-nginx:v1.0
```

3. Push again:

```bash
podman push docker.io/<your_username>/my-nginx:v1.0
```

---

## 5) `podman push` fails due to rate limits / transient registry errors

### ✅ Symptoms

* `toomanyrequests`
* `Service Unavailable`
* Timeouts or slow upload

### 🔎 Causes

* Docker Hub rate limiting
* Network instability

### ✅ Fix

* Retry after some time
* Ensure you’re logged in (logged-in users often have higher limits)
* Use a different registry (Quay, private registry) if available

---

## 6) `podman rmi docker.io/<user>/my-nginx:v1.0` doesn’t remove the image completely

### ✅ Symptoms

* You remove the tag, but image still exists under another tag (`nginx:latest`, `localhost/my-nginx:v1.0`, etc.)

### 🔎 Cause

Images are stored by layers/ID. Removing one tag only removes that reference if others still exist.

### ✅ Fix

Check all tags referencing same IMAGE ID:

```bash
podman images | grep 3c2b1a0f9e8d
```

If you want to remove everything for that image ID (careful):

```bash
podman rmi 3c2b1a0f9e8d
```

---

## 7) `podman pull docker.io/<user>/my-nginx:v1.0` fails with “manifest unknown”

### ✅ Symptoms

* `manifest unknown`
* `not found`

### 🔎 Causes

* Tag doesn’t exist on Docker Hub
* Repo name or username is wrong
* Push didn’t actually complete

### ✅ Fix

* Verify repository exists on Docker Hub (web UI)
* Confirm exact tag:

```bash
skopeo inspect docker://docker.io/<your_username>/my-nginx:v1.0
```

---

## 8) `podman inspect --format '{{.Digest}}' ...` prints blank

### ✅ Symptoms

* Digest output is empty

### 🔎 Cause

Podman’s stored metadata may not populate `.Digest` consistently depending on version/storage driver or how the image was pulled.

### ✅ Fix

Use `skopeo inspect` (reliable for registry digests):

```bash
skopeo inspect docker://docker.io/<your_username>/my-nginx:v1.0 | grep -i Digest
```

---

## 9) Pulling by digest fails

### ✅ Symptoms

* `Error: reading manifest ...`
* Unauthorized or not found

### 🔎 Causes

* Digest copied incorrectly
* Digest belongs to a different repo/tag
* Registry auth required

### ✅ Fix

1. Copy digest from `skopeo inspect` carefully:

```bash
skopeo inspect docker://docker.io/<your_username>/my-nginx:v1.0 | grep -i Digest
```

2. Pull with the `@sha256:...` format:

```bash
podman pull docker.io/<your_username>/my-nginx@sha256:<digest>
```

3. If private repo, login first:

```bash
podman login docker.io
```

---

## 10) Cleanup command removes more than expected

### ✅ Symptoms

* `podman rmi -f $(podman images -q)` deletes many images

### 🔎 Cause

It removes **all** locally stored images.

### ✅ Fix

Prefer targeted cleanup:

```bash
podman rmi docker.io/library/nginx:latest
podman rmi docker.io/<your_username>/my-nginx:v1.0
podman rmi localhost/my-nginx:v1.0
```

Or filter by name:

```bash
podman images | grep nginx
```

---

## ✅ Quick Verification Checklist

* Check tags exist:

```bash
podman images | egrep 'nginx|my-nginx'
```

* Confirm you’re logged in:

```bash
podman info | grep -A 5 "registries"
```

* Verify remote tag exists:

```bash
skopeo inspect docker://docker.io/<your_username>/my-nginx:v1.0 | grep -i Digest
```

* Confirm digest behavior:
* Tag can move (mutable)
* Digest identifies exact immutable content

