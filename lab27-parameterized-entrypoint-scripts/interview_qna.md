# 💬 Interview Q&A — Lab 27: Parameterized `ENTRYPOINT` Scripts

---

## 1) What is the main role of an ENTRYPOINT script in containers?
An ENTRYPOINT script controls **container initialization**. It can print context, validate configuration, apply startup logic, and then launch the main process (or dispatch commands).

---

## 2) Why are ENTRYPOINT scripts common in real container images?
Because they help:
- handle environment variables injected at runtime
- prepare config files (templating)
- run migrations/init steps
- apply conditional logic for different environments
- provide consistent startup behavior across deployments

---

## 3) Why did this lab install `bash` in Alpine?
Alpine images usually default to `/bin/sh` and don’t always include `/bin/bash`. Since the script used `#!/bin/bash`, the image installed `bash` using:
- `apk add --no-cache bash`

---

## 4) What does `exec "$@"` do in an entrypoint script?
It replaces the shell script process with the command provided as arguments. This is a best practice because:
- the app becomes PID 1
- signals (SIGTERM/SIGINT) are handled more correctly
- process management is cleaner

---

## 5) How did CMD and ENTRYPOINT interact in Task 2?
ENTRYPOINT was the script, and CMD supplied default arguments:
- ENTRYPOINT: `/entrypoint.sh`
- CMD: `["echo", "Default command executed"]`

So the script received that CMD as `$@` and executed it via `exec "$@"`.

---

## 6) How did you verify parameter passing worked?
When running the container with default CMD, the script printed:
- the full arguments list (`echo Default command executed`)
- the first and second arguments
and then executed the command to print:
- `Default command executed`

---

## 7) How do you override CMD while keeping ENTRYPOINT the same?
You provide a new command at runtime after the image name:
```bash id="v6ovg5"
podman run entrypoint-demo ls -l /
````

This replaces CMD args, but ENTRYPOINT still runs first.

---

## 8) What is environment-specific logic in a container?

It’s when startup behavior changes depending on environment variables, like:

* development mode: enable debug features
* production mode: apply stricter settings

This allows one image to adapt without rebuilds.

---

## 9) How was `ENV_MODE` used in this lab?

The entrypoint script checked:

* `ENV_MODE=production` → prints production message
* `ENV_MODE=development` → prints development message
* unset/other → prints default mode message

---

## 10) How do you pass environment variables to a container with Podman?

Using the `-e` flag:

```bash id="h8ms56"
podman run -e ENV_MODE=production entrypoint-demo
```

---

## 11) What is a dispatcher-style entrypoint?

A dispatcher entrypoint behaves like a small CLI by using `case` logic on `$1`, such as:

* `start [config]`
* `stop`
* invalid commands show usage

This pattern is common in operational containers or tool-like images.

---

## 12) Why did the dispatcher version not use `exec "$@"`?

Because the entrypoint itself became the main “application” that handles the command. In dispatcher style, the script decides what to do and exits after printing/processing.

---

## 13) What output confirmed the dispatcher pattern worked?

* `start production` printed:

  * `Starting application with config: production`
* `stop` printed:

  * `Stopping application gracefully`
* invalid input printed:

  * `Usage: /entrypoint.sh {start|stop} [config]`

---

## 14) What’s a real-world use case for environment detection + parameter handling?

Examples:

* Dev containers enable verbose logs and debugging tools
* Prod containers enforce strict flags, lower log verbosity, and safer defaults
* Ops teams run the same image with different commands (`start`, `stop`, `migrate`, `healthcheck`)

---

## 15) What is the main takeaway from this lab?

Parameterized entrypoints make images flexible:

* CMD provides default behavior
* runtime args override defaults
* environment variables control mode
* scripts can validate and dispatch logic
  This is a core pattern for containers running in orchestrated platforms like OpenShift/Kubernetes.
