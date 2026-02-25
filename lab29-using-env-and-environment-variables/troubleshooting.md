# 🛠️ Troubleshooting Guide — Lab 29: `ENV` and Environment Variables

> This file lists common issues when defining `ENV` variables in a Containerfile, overriding them with `podman run -e`, using multi-line values, and verifying with `podman inspect`.

---

## 1) Variables do not change when using `-e`

### ✅ Symptom
You run:
```bash
podman run -e APP_NAME="NewApp" env-demo
```

but the output still shows the old value.

### 🔎 Possible Causes

* Wrong variable name (typo)
* `-e` flag placed incorrectly
* Running the wrong image name/tag

### ✅ Fixes

* Confirm exact variable names:

  ```bash
  grep -n "ENV" -A3 Containerfile
  ```
* Ensure `-e` appears before the image name:

  ```bash
  podman run -e APP_NAME="NewApp" env-demo
  ```
* Confirm you are using the correct image:

  ```bash
  podman images | grep env-demo
  ```

---

## 2) Environment variables not expanding in CMD output

### ✅ Symptom

Output shows literal text like `$APP_NAME` instead of actual value.

### 🔎 Cause

This commonly happens when using exec-form `CMD`:

```dockerfile
CMD ["echo", "Running $APP_NAME"]
```

Exec form does not automatically run through a shell, so variables won’t expand.

### ✅ Fix

Use shell-form CMD (as used in this lab):

```dockerfile id="lna6xw"
CMD echo "Running $APP_NAME"
```

Or explicitly run a shell:

```dockerfile id="cglf5f"
CMD ["/bin/sh", "-c", "echo Running $APP_NAME"]
```

---

## 3) Multi-line ENV value becomes weird / breaks unexpectedly

### ✅ Symptom

Your multi-line variable prints incorrectly or the build fails.

### 🔎 Causes

* Missing backslash `\` continuation
* Incorrect quoting
* Unintended whitespace or formatting issues

### ✅ Fixes

* Confirm backslash placement:

  ```dockerfile
  ENV APP_DESCRIPTION="This is a multi-line \
  environment variable example"
  ```
* Re-check Containerfile output:

  ```bash
  cat Containerfile
  ```
* Rebuild without cache if needed:

  ```bash
  podman build --no-cache -t multiline-env .
  ```

---

## 4) Build succeeds but you see no output when running container

### ✅ Symptom

`podman run multiline-env` prints nothing.

### 🔎 Possible Causes

* CMD is missing
* CMD does not print anything
* Wrong image name used

### ✅ Fixes

* Confirm CMD exists:

  ```bash
  grep -n "CMD" Containerfile
  ```
* Confirm correct image is run:

  ```bash
  podman run multiline-env
  ```

---

## 5) `podman inspect` output doesn’t show your variables

### ✅ Symptom

You run inspect but don’t see `APP_NAME`, etc.

### 🔎 Possible Causes

* Container name mismatch
* Inspecting the wrong container
* Formatting issues with the Go template

### ✅ Fixes

* Confirm container exists:

  ```bash
  podman ps -a | grep envcheck
  ```
* Inspect and print all env lines:

  ```bash
  podman inspect envcheck --format '{{ range .Config.Env }}{{ println . }}{{ end }}'
  ```
* Filter expected variables:

  ```bash
  podman inspect envcheck --format '{{ range .Config.Env }}{{ println . }}{{ end }}' | grep -E 'APP_NAME|APP_VERSION|APP_DESCRIPTION'
  ```

---

## 6) Documentation table formatting looks broken in Markdown

### ✅ Symptom

The table doesn’t render correctly on GitHub.

### 🔎 Cause

Incorrect separators or extra `|` characters.

### ✅ Fix

Use a valid Markdown table structure:

```markdown id="ai1zqj"
| Variable        | Description                 | Default Value        |
|----------------|-----------------------------|----------------------|
| APP_NAME        | Name of the application     | MyApp                |
| APP_VERSION     | Application version         | 1.0.0                |
| APP_DESCRIPTION | Multi-line description      | (see Containerfile)  |
```

---

## ✅ Quick Verification Checklist

* Build base ENV demo:

  ```bash
  podman build -t env-demo .
  podman run env-demo
  ```
* Override at runtime:

  ```bash
  podman run -e APP_NAME="NewApp" env-demo
  ```
* Build multi-line ENV demo:

  ```bash
  podman build -t multiline-env .
  podman run multiline-env
  ```
* Verify env values via inspect:

  ```bash
  podman run -d --name envcheck multiline-env
  podman inspect envcheck --format '{{ range .Config.Env }}{{ println . }}{{ end }}' | grep APP_
  podman rm -f envcheck
  ```
