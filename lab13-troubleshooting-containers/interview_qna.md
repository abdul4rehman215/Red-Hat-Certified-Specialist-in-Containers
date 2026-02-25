# 🧠 Interview Q&A — Lab 13: Troubleshooting Containers (Podman)

---

## 1) What is the first command you run when a container “doesn’t work”?
Usually `podman ps -a` to see whether it is running, exited, restarting, or created but never started.

---

## 2) How do you view container logs in Podman?
Use:
- `podman logs <container_name>`

This shows STDOUT/STDERR output emitted by the container process.

---

## 3) How do you follow logs in real time?
Use:
- `podman logs -f <container_name>`

This streams logs continuously until you stop it (Ctrl+C).

---

## 4) How do you filter logs to show only recent entries?
Use time filtering like:
- `podman logs --since 5m <container_name>`

This is useful when logs are large and you want the most relevant window.

---

## 5) How do you show only the last N log lines?
Use:
- `podman logs --tail 10 <container_name>`

---

## 6) What does `podman inspect` provide?
It provides detailed JSON metadata about a container, including:
- State (running, exit code, errors)
- Image name, created time
- Entrypoint and command
- Environment variables
- Network ports and bindings

---

## 7) Which `inspect` fields are most useful when debugging startup failures?
- `State.Status`
- `State.ExitCode`
- `State.Error`
- `Config.Entrypoint` and `Config.Cmd`
- `NetworkSettings.Ports`

---

## 8) What does `podman stats` show?
Live container resource usage:
- CPU %
- memory usage
- network I/O
- block I/O
- number of processes (PIDs)

This helps identify resource pressure or runaway processes.

---

## 9) What does `podman exec` do?
It runs a command inside a running container. It’s used for interactive debugging (shell access) and inspecting internal state.

---

## 10) Why would `podman exec` fail?
`podman exec` only works on **running** containers. If the container exited, you must restart it or run it with a long-running command.

---

## 11) What did `ps aux` show inside the nginx container?
It showed:
- the nginx master process
- nginx worker processes
- the interactive shell session
This confirms the service is running as expected.

---

## 12) Why did `curl localhost` fail initially inside the container?
Because `nginx:alpine` is a minimal image and often does not include debugging tools like `curl` by default.

---

## 13) How did you resolve missing debugging tools in a minimal image?
Installed the tool temporarily:
- `apk add --no-cache curl`

This is a common real-world troubleshooting step.

---

## 14) What is `podman system df` useful for?
It shows disk usage by:
- images
- containers
- volumes
- build cache
Helpful when troubleshooting disk pressure issues.

---

## 15) What’s a practical troubleshooting workflow for containers?
A solid baseline flow:
1. `podman ps -a` (state)
2. `podman logs` (errors)
3. `podman inspect` (config + exit code)
4. `podman stats` (resources)
5. `podman exec` (inside-container debugging)
