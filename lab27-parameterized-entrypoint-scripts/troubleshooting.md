# 🛠️ Troubleshooting Guide — Lab 27: Parameterized `ENTRYPOINT` Scripts

> This file covers common issues when using script-based entrypoints, parameter passing (`CMD` → `ENTRYPOINT`), env vars, and dispatcher logic.

---

## 1) `exec format error` when running the container

### ✅ Symptom
Container fails with:
- `exec /entrypoint.sh: exec format error`

### 🔎 Common Causes
- Missing shebang line (e.g., `#!/bin/bash`)
- Script has Windows line endings (CRLF)
- Script is not executable (or copied incorrectly)

### ✅ Fixes
- Ensure shebang is on the first line:
  ```bash
  head -n 1 entrypoint.sh
  ```

* Convert CRLF → LF if needed:

  ```bash
  sed -i 's/\r$//' entrypoint.sh
  ```
* Ensure executable permission:

  ```bash
  chmod +x entrypoint.sh
  ```

---

## 2) `/bin/bash: not found` in Alpine-based image

### ✅ Symptom

Container fails with:

* `/bin/bash: not found`

### 🔎 Cause

Alpine does not include bash by default and typically uses `/bin/sh`.

### ✅ Fix

Install bash in the image:

```dockerfile
RUN apk add --no-cache bash
```

---

## 3) ENTRYPOINT script runs but command from CMD does not execute

### ✅ Symptom

The script prints startup messages, but the expected command output never appears.

### 🔎 Cause

`exec "$@"` is missing or incorrect in the script version that should pass through commands.

### ✅ Fix

Use the pass-through pattern:

```bash id="e7tqni"
exec "$@"
```

> Note: In the dispatcher version (Task 4), pass-through is intentionally removed because the script handles commands itself.

---

## 4) CMD override doesn’t work as expected

### ✅ Symptom

You run:

```bash
podman run entrypoint-demo ls -l /
```

but output is not what you expected.

### 🔎 Cause

The ENTRYPOINT script decides what to do. In Task 2 and Task 3 versions, runtime args override CMD and are executed via `exec "$@"`.
In Task 4 (dispatcher), args are not executed—they are interpreted by `case "$1"`.

### ✅ Fix

Confirm which script behavior you are testing:

* Task 2/3: pass-through script (`exec "$@"`)
* Task 4: dispatcher script (start/stop only)

---

## 5) Environment variables not recognized (`ENV_MODE` logic not triggered)

### ✅ Symptom

You expected:

* `DEVELOPMENT MODE...` or `PRODUCTION MODE...`
  but always see:
* `No ENV_MODE specified...`

### 🔎 Causes

* `-e ENV_MODE=...` not passed correctly
* typo in variable name
* using a script version that no longer contains ENV detection logic (Task 4 replaces it)

### ✅ Fixes

* Run with correct env flag:

  ```bash id="ulhbqv"
  podman run -e ENV_MODE=development entrypoint-demo
  podman run -e ENV_MODE=production entrypoint-demo
  ```
* Confirm script currently includes ENV logic:

  ```bash
  grep ENV_MODE entrypoint.sh
  ```

---

## 6) Permission denied when executing `/entrypoint.sh`

### ✅ Symptom

Container fails with:

* `Permission denied`

### 🔎 Causes

* script not executable before copy
* wrong permissions inside image

### ✅ Fixes

* Ensure script is executable on host:

  ```bash
  chmod +x entrypoint.sh
  ```
* Add chmod inside Dockerfile if needed:

  ```dockerfile
  RUN chmod +x /entrypoint.sh
  ```

---

## 7) Build cache causes old script behavior to persist

### ✅ Symptom

You updated `entrypoint.sh`, rebuilt, but container still behaves like old version.

### 🔎 Cause

Build cache reused earlier layers.

### ✅ Fix

Force rebuild without cache:

```bash id="vz9ebm"
podman build --no-cache -t entrypoint-demo .
```

---

## 8) Dispatcher mode returns usage unexpectedly

### ✅ Symptom

You run something like:

```bash
podman run entrypoint-demo start
```

and see usage errors or unexpected output.

### 🔎 Cause

Dispatcher expects:

* `start [config]` or `stop`
  Other inputs trigger the default case.

### ✅ Fix

Use valid patterns:

```bash id="a8z3yp"
podman run entrypoint-demo start production
podman run entrypoint-demo stop
```

---

## ✅ Quick Verification Checklist

* Script has correct shebang:

  ```bash
  head -n 1 entrypoint.sh
  ```
* Script is executable:

  ```bash
  ls -l entrypoint.sh
  ```
* Image builds:

  ```bash
  podman build -t entrypoint-demo .
  ```
* Pass-through mode runs CMD:

  ```bash
  podman run entrypoint-demo
  ```
* Override command works (Task 2 style):

  ```bash
  podman run entrypoint-demo ls -l /
  ```
* ENV mode works (Task 3 style):

  ```bash
  podman run -e ENV_MODE=production entrypoint-demo
  ```
* Dispatcher works (Task 4 style):

  ```bash
  podman run entrypoint-demo start production
  podman run entrypoint-demo stop
  ```
