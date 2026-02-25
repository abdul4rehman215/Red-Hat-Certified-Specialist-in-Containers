# 💬 Interview Q&A — Lab 39: Troubleshooting Common Container Issues

---

## 1) How do you quickly check whether a container has CPU or memory limits set?
Use `podman inspect` and search for CPU/memory fields:
```bash id="y2k6w1"
podman inspect <container_id> | grep -i "memory\|cpu"
````

If values are `0`, it usually means no explicit limits were set (defaults apply).

---

## 2) What does `podman stats` show and why is it useful?

`podman stats` shows live container resource usage such as CPU, memory, network I/O, block I/O, and process count. It’s useful for diagnosing performance issues and resource exhaustion.

---

## 3) How did you apply a memory limit to a running container?

Using:

```bash id="d3m8q0"
podman update --memory 512m <container_id>
```

Then verified via inspect that memory was set to `536870912` bytes.

---

## 4) Where do you look for SELinux denials related to containers?

The audit logs, commonly via:

```bash id="c9p2r4"
sudo ausearch -m avc -ts recent
```

You look for contexts like `container_t` being denied access to files labeled incorrectly (e.g., `default_t`).

---

## 5) Why is setting SELinux to permissive only a temporary debugging step?

Permissive mode stops enforcing policy, which can hide real security issues. It’s useful to confirm SELinux is the cause, but you should revert to enforcing after applying the correct fix.

---

## 6) What is a common SELinux cause of bind-mount issues?

Host files mounted into containers may have incorrect SELinux labels (e.g., `default_t`), causing `container_t` processes to be denied access.

---

## 7) How did you fix the SELinux labeling issue in this lab?

By relabeling the host directory with a container-friendly type:

```bash id="m1u8v9"
sudo chcon -Rt container_file_t /home/centos/badmount
```

Then verified with:

```bash
ls -Z /home/centos/badmount/secret.txt
```

---

## 8) What is the purpose of the `:Z` option in Podman volume mounts?

`:Z` relabels the mounted content for container use (private label) so SELinux allows access:

```bash id="w4r1f2"
podman run --rm -v /host/path:/data:Z alpine /bin/sh
```

---

## 9) How do you troubleshoot a host port binding conflict?

* Check if the port is already in use:

  ```bash
  sudo ss -tulnp | grep 8080
  ```
* Attempting to bind the same port again typically fails with “address already in use”.

---

## 10) What was the error you saw when trying to bind two containers to port 8080?

```text id="v8g1p2"
bind: address already in use
```

This confirmed a port conflict.

---

## 11) How do you inspect a container’s network namespace path in Podman?

Using:

```bash id="p9c7m1"
podman inspect <container_id> --format '{{.NetworkSettings.SandboxKey}}'
```

It returns a `/run/netns/...` path.

---

## 12) How do you debug networking from inside a container namespace without entering the container shell?

Use `nsenter` with the container PID:

```bash id="c6n2z8"
sudo nsenter -n -t $(podman inspect --format '{{.State.Pid}}' <container_id>) ip a
```

This displays container network interfaces and IP assignments.

---

## 13) What does an empty output from `podman inspect --format '{{.Config.User}}'` usually mean?

It usually means the container is running with the image’s default user (commonly `root` unless the image sets a `USER` instruction).

---

## 14) When would you explicitly run a container as root during troubleshooting?

If you suspect permissions issues due to a non-root runtime user, you can test with:

```bash id="c2y9j7"
podman run --rm -it --user root alpine /bin/sh
```

This helps confirm whether failures are due to user permissions vs SELinux labeling.

---

## 15) What’s the key takeaway from this lab?

Container troubleshooting often requires checking:

* resource usage and limits (`inspect`, `stats`)
* SELinux contexts and denials (`ausearch`, `chcon`, `:Z`)
* port conflicts (`ss`)
* advanced namespace debugging (`SandboxKey`, `nsenter`)
  Fixing issues correctly means applying the minimal change and re-verifying the behavior.

