# 💬 Interview Q&A — Lab 34: Retrieving Container Logs and Events

---

## 1) What does `podman logs` show?
`podman logs` displays the stdout/stderr output produced by the container’s main process, based on the configured logging driver.

---

## 2) How do you stream logs in real time?
Use:
```bash id="fok6dn"
podman logs --follow <container_name>
````

Stop streaming with `Ctrl+C`.

---

## 3) How can you filter logs by time in Podman?

You can use:

* `--since` (relative like `5m` or absolute timestamp)
* `--until` (absolute timestamp)

Example:

```bash id="32crb5"
podman logs --since 5m nginx-container
```

---

## 4) Why did `--since 2023... --until 2023...` return no output in this lab?

Because the container logs were generated in **2026**, so a 2023 time window does not match any log entries.

---

## 5) What are logging drivers, and why would you change them?

Logging drivers define where logs are stored and how they’re accessed (files, journald, etc.). You might change drivers to:

* integrate with system logging (journald)
* centralize logs
* improve operational workflows

---

## 6) How did you run a container using the JSON file log driver?

Using:

```bash id="hwp4c0"
podman run -d --name json-logger --log-driver json-file nginx:alpine
```

---

## 7) How did you find the log file path for the JSON log driver?

In this environment, `.HostConfig.LogConfig.Path` returned blank, so `.LogPath` was used:

```bash id="5k6a0s"
podman inspect --format '{{.LogPath}}' json-logger
```

---

## 8) What is journald logging and how do you view those logs?

With journald driver, container logs go to systemd journal. You can query:

```bash id="2y8t2x"
journalctl CONTAINER_NAME=journald-logger --no-pager
```

---

## 9) What does `podman events` do?

`podman events` streams lifecycle events like:

* create
* init
* start
* die
* remove
  This is useful for troubleshooting and auditing.

---

## 10) How can you filter events for only start events?

Use:

```bash id="4h4f4a"
podman events --filter event=start --since 1m
```

---

## 11) How can you filter events for a specific container?

Use:

```bash id="8y8s3a"
podman events --filter container=event-test --since 5m
```

---

## 12) Why can events be useful even when logs are empty?

A container may exit before the log driver initializes (fast exec failure). Logs may be missing, but events still show lifecycle transitions like `create → init → die`.

---

## 13) Why did `podman logs failing-container` return “has no logs”?

Because the process failed immediately during exec (`/bin/nonexistent-command`) and the container exited before logs were written.

---

## 14) What did you learn from the `die` event for the failing container?

It confirmed the container reached `init` and then died quickly, which supports diagnosing startup failures even without logs.

---

## 15) What’s the value of running Podman with `--log-level=debug`?

It prints debug messages about runtime and configuration decisions (OCI runtime selection, container creation steps). This is helpful when troubleshooting deeper execution issues beyond application logs.

