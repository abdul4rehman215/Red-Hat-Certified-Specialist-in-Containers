# 💬 Interview Q&A — Lab 33: Running Containers Locally with Podman

---

## 1) What’s the difference between running a container in the foreground vs detached mode?
- **Foreground (attached)**: your terminal attaches to the container process and shows live logs/output.
- **Detached (`-d`)**: container runs in the background and returns control of the terminal immediately.

---

## 2) Why might you choose foreground mode?
Foreground mode is useful for:
- quick testing
- debugging startup failures
- watching logs in real time
- verifying signal handling (Ctrl+C → graceful stop)

---

## 3) What does `podman run -d` return?
It returns the container ID and keeps the container running in the background.

---

## 4) How do you verify a container is running?
Use:
```bash id="hfq5fr"
podman ps
````

It lists active running containers with status and names.

---

## 5) How does port mapping work in Podman?

Port mapping publishes a container port to the host using:

* `-p HOST_PORT:CONTAINER_PORT`

Example:

```bash id="7jip4b"
podman run -d -p 8080:80 --name webapp nginx
```

---

## 6) How did you verify that Nginx was reachable through the mapped port?

I used:

```bash id="91x0er"
curl -I http://localhost:8080
```

and also checked page content using:

```bash id="ms5h7d"
curl http://localhost:8080 | head
```

---

## 7) What caused the `Error: name "webapp" is in use` message?

A container named `webapp` already existed from a previous run/lab, so Podman refused to reuse the same name.

---

## 8) How did you fix the container name conflict?

By removing the existing container:

```bash id="cvv32p"
podman rm -f webapp
```

Then running the container again.

---

## 9) What is a Podman named volume and why use it?

A named volume is Podman-managed storage that persists independently of containers. It’s commonly used for data persistence (databases, app state).

---

## 10) How did you create and mount a named volume?

Create:

```bash id="8p2mgk"
podman volume create mydata
```

Mount:

```bash id="q3jyn0"
podman run -d --name vol-container -v mydata:/data alpine tail -f /dev/null
```

---

## 11) What does `--user` do in `podman run`?

It overrides the user inside the container at runtime. You can pass:

* a numeric UID (e.g., `1000`)
* a username (e.g., `nobody`)

---

## 12) Why did `whoami` show `unknown uid 1000`?

Because the Alpine image doesn’t have a username entry for UID 1000 in `/etc/passwd`. The UID exists but isn’t mapped to a named user.

---

## 13) How do you inspect container configuration and state?

Using:

```bash id="k0e2dl"
podman inspect webapp
```

It returns detailed JSON including:

* mounts
* ports
* user
* environment
* state (PID, running status, timestamps)

---

## 14) What’s the difference between `podman logs` and `podman stats`?

* `podman logs` shows application output (stdout/stderr) from the container.
* `podman stats` shows resource usage (CPU, memory, net I/O, PIDs) for running containers.

---

## 15) What’s the key takeaway from this lab?

Podman provides a full set of local container workflows:

* run in foreground or background
* publish services with port mapping
* persist storage with volumes
* control runtime permissions with user overrides
* troubleshoot with inspect/logs/stats
  These skills are foundational for development and production container operations.
