# 🛠️ Troubleshooting Guide — Lab 26: `CMD` vs `ENTRYPOINT`

> This file lists common issues when building and running images that use `CMD`, `ENTRYPOINT`, and script-based entrypoints.

---

## 1) Container prints nothing / unexpected output

### ✅ Symptom
Running the container produces no output or output you didn’t expect.

### 🔎 Possible Causes
- Dockerfile syntax mistake in JSON array formatting
- Wrong file used during build (`-f` points to the wrong Containerfile)
- Running the wrong image tag/name

### ✅ Fixes
- Check the file contents:
  ```bash
  cat Containerfile.cmd
  cat Containerfile.entrypoint
  cat Containerfile.combined
  cat Containerfile.script
  ```

* Verify correct build command:

  ```bash
  podman build -t cmd-demo -f Containerfile.cmd .
  ```
* Verify the image exists:

  ```bash
  podman images | grep cmd-demo
  ```

---

## 2) JSON array formatting errors

### ✅ Symptom

Build fails with errors related to parsing `CMD` or `ENTRYPOINT`.

### 🔎 Cause

JSON array form must be valid, for example:

```dockerfile
CMD ["echo", "Hello"]
```

### ✅ Fix

* Ensure quotes, commas, and brackets are correct
* Avoid single quotes inside JSON form unless properly escaped

---

## 3) Script entrypoint fails with `exec format error`

### ✅ Symptom

Container fails with:

* `exec /entrypoint.sh: exec format error`

### 🔎 Common Causes

* Missing shebang line (`#!/bin/sh`)
* Script has Windows line endings (CRLF)
* Script is not executable

### ✅ Fixes

* Confirm shebang exists as first line:

  ```sh
  #!/bin/sh
  ```
* Ensure executable permission:

  ```bash
  chmod +x entrypoint.sh
  ```

  (In this lab, we applied it inside the image using `RUN chmod +x /entrypoint.sh`.)
* Convert line endings if needed:

  ```bash
  sed -i 's/\r$//' entrypoint.sh
  ```

---

## 4) Script runs but does not execute the command properly

### ✅ Symptom

Script prints the message but does not run the intended command.

### 🔎 Cause

The script may not be passing arguments correctly, or `exec "$@"` is missing.

### ✅ Fix

Use the recommended pattern:

```sh
echo "Starting container with arguments: $@"
exec "$@"
```

---

## 5) Overriding CMD doesn’t work as expected

### ✅ Symptom

You try:

```bash
podman run combined-demo "Custom message"
```

but it does not behave like expected.

### 🔎 Cause

Override behavior depends on whether `ENTRYPOINT` is set:

* If ENTRYPOINT is `["echo"]`, then `"Custom message"` becomes the argument to `echo`.
* If ENTRYPOINT is not set, then `"Custom message"` becomes the entire command.

### ✅ Fix

Confirm the combined file:

```dockerfile id="pg1nqx"
ENTRYPOINT ["echo"]
CMD ["Default message"]
```

---

## 6) Overriding ENTRYPOINT doesn’t work

### ✅ Symptom

You pass a command after the image name, but the script still runs.

### 🔎 Cause

Passing a command after the image name overrides CMD or appends to ENTRYPOINT — it does **not** replace ENTRYPOINT.

### ✅ Fix

Use `--entrypoint`:

```bash id="c5zp94"
podman run --entrypoint /bin/ls script-demo -l /
```

---

## 7) Build fails because base image cannot be pulled

### ✅ Symptom

Build fails at `FROM alpine:latest` due to network errors.

### 🔎 Possible Causes

* Internet/DNS issues in the environment
* Registry temporarily unreachable

### ✅ Fixes

* Test connectivity:

  ```bash
  ping -c 2 docker.io
  ```
* Retry build:

  ```bash
  podman build -t cmd-demo -f Containerfile.cmd .
  ```
* If needed, pull explicitly:

  ```bash
  podman pull alpine:latest
  ```

---

## 8) Cleanup fails because images are in use

### ✅ Symptom

`podman rmi ...` fails due to containers using images.

### 🔎 Cause

A container might still exist referencing the image.

### ✅ Fix

List and remove containers first:

```bash id="pyq1kk"
podman ps -a
podman rm -f <container_name_or_id>
```

Then remove images:

```bash id="1k9kw6"
podman rmi cmd-demo entrypoint-demo combined-demo script-demo
```

---

## ✅ Quick Verification Checklist

* CMD default works:

  ```bash
  podman run cmd-demo
  ```
* CMD override works:

  ```bash
  podman run cmd-demo echo "Overridden command"
  ```
* ENTRYPOINT append works:

  ```bash
  podman run entrypoint-demo "with appended text"
  ```
* Combined defaults + override works:

  ```bash
  podman run combined-demo
  podman run combined-demo "Custom message"
  ```
* Script entrypoint prints args and runs command:

  ```bash
  podman run script-demo
  ```
* Full entrypoint override works:

  ```bash
  podman run --entrypoint /bin/ls script-demo -l /
  ```

