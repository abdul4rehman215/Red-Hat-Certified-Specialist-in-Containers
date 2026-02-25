# 💬 Interview Q&A — Lab 35: Inspecting Containers and Images with Podman

---

## 1) What is `podman inspect` used for?
`podman inspect` returns detailed JSON metadata about containers or images. It’s used to troubleshoot runtime configuration and understand how containers/images are built and executed.

---

## 2) What’s the difference between inspecting an image and inspecting a container?
- **Image inspect** shows static configuration (digest, architecture, default env, CMD).
- **Container inspect** shows runtime state (PID, status, ports, mounts, env overrides, timestamps).

---

## 3) How can you quickly reduce the large JSON output from `podman inspect`?
Use `head`, or use formatted output:
```bash id="7n7h7w"
podman inspect my_nginx | head -n 30
````

or:

```bash id="1zq5e6"
podman inspect my_nginx --format '{{.State.Status}}'
```

---

## 4) How did you extract the container IP address?

Using:

```bash id="y8t5l2"
podman inspect my_nginx --format '{{.NetworkSettings.IPAddress}}'
```

---

## 5) How did you extract the container creation timestamp?

Using:

```bash id="h4j5k8"
podman inspect my_nginx --format '{{.Created}}'
```

---

## 6) How do you inspect environment variables for a running container?

You can print the whole list:

```bash id="y0i5q0"
podman inspect env_test --format '{{.Config.Env}}'
```

---

## 7) Why did the Go-template function `split` fail in this lab?

Because Podman’s available Go-template functions can vary by version/build. In this environment, `split` was not defined, so the template parser failed.

---

## 8) What reliable fallback did you use to extract a specific env variable?

I printed the env list and filtered it using standard tools:

```bash id="6p4k1o"
podman inspect env_test --format '{{.Config.Env}}' | tr ' ' '\n' | grep '^APP_COLOR='
```

---

## 9) How did you verify container mounts using inspect?

By printing the mounts field:

```bash id="i2b5u1"
podman inspect vol_test --format '{{.Mounts}}'
```

It showed a bind mount from `/tmp` to `/container_tmp`.

---

## 10) How did you inspect published port mappings?

Using:

```bash id="u3v2qp"
podman inspect my_nginx --format '{{.NetworkSettings.Ports}}'
```

This displayed a mapping for `80/tcp` to host port `8080`.

---

## 11) How did you extract only the host port for container port 80/tcp?

Using index lookups in the format template:

```bash id="m9t6ri"
podman inspect my_nginx --format '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}'
```

---

## 12) Why are exit codes useful for troubleshooting containers?

Exit codes quickly indicate whether a container finished successfully (`0`) or failed (`non-zero`). They are useful for:

* automation checks
* CI/CD validation
* debugging crash loops

---

## 13) How did you simulate and confirm a non-zero exit code?

I ran a container that exits with code 3:

```bash id="q4b6o8"
podman run --name fail_test alpine sh -c "exit 3"
```

Then inspected the exit code:

```bash id="y7q8z0"
podman inspect fail_test --format '{{.State.ExitCode}}'
```

---

## 14) Why did you install `jq` during this lab?

To pretty-print JSON output for readability when inspecting `.State`. It makes debugging faster than reading compact JSON.

---

## 15) What is the main takeaway from this lab?

`podman inspect` is a core troubleshooting tool to confirm:

* runtime state and exit codes
* environment variables
* mounts and port publishing
* static image configuration
  And when templates vary, standard Linux text tools (`tr`, `grep`) provide reliable fallbacks.
