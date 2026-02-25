# 💬 Interview Q&A — Lab 24: `WORKDIR` and `USER` Instructions

---

## 1) What does `WORKDIR` do in a Dockerfile/Containerfile?
`WORKDIR` sets the **default working directory** for all subsequent instructions (`RUN`, `COPY`, `ADD`, `CMD`, `ENTRYPOINT`) and for the container’s runtime. If the directory doesn’t exist, it is created automatically.

---

## 2) Why is `WORKDIR` useful in container builds?
It helps standardize paths and reduces mistakes caused by using long or inconsistent directory paths. It also makes the Dockerfile easier to read and maintain.

---

## 3) How did you verify the `WORKDIR` value in this lab?
I wrote the output of `pwd` into a file during build:
- `RUN pwd > /tmp/workdir.log`
Then I checked it at runtime:
- `podman run --rm workdir-demo cat /tmp/workdir.log`
It returned `/app`.

---

## 4) What does the `USER` instruction do?
`USER` sets the default user for:
- subsequent build instructions (`RUN`, etc.)
- and for runtime when the container starts

Once `USER appuser` is set, commands run under that user unless overridden at runtime.

---

## 5) Why is running containers as non-root considered best practice?
Because if the container process is compromised, a non-root user has fewer permissions. This limits the attacker’s ability to:
- modify system paths
- access privileged kernel interfaces
- write to restricted mount points

It reduces the blast radius.

---

## 6) What steps are typically required to run as a non-root user?
Common steps:
1. Create a user in the image (`useradd`)
2. Ensure required directories are owned by that user (`chown`)
3. Switch default execution user (`USER <username>`)

---

## 7) Why did you install `shadow-utils` in this lab?
Because the base image used (`ubi-minimal`) is minimal and may not include `useradd` by default. Installing `shadow-utils` provides user management utilities.

---

## 8) What is the importance of `chown -R appuser:appuser /app`?
It ensures the non-root user can read/write to the working directory. Without ownership or proper permissions, the container might fail when the application tries to create files under `/app`.

---

## 9) How did you confirm the container was running as `appuser`?
I verified using:
- `podman run --rm nonroot-demo whoami` → `appuser`
and also checked `/tmp/user.log` generated during build.

---

## 10) What did the privileged-operation test prove?
Running:
```bash
podman run --rm nonroot-demo touch /sys/kernel/profiling
````

returned `Permission denied`, proving the container user lacks privilege to write to sensitive kernel-backed paths. This supports least privilege.

---

## 11) How did you verify process ownership inside a running container?

I started a container:

* `podman run -d --name testuser nonroot-demo sleep 300`
  Then inspected processes:
* `podman exec testuser ps -ef`

All processes showed the owner as `appuser`.

---

## 12) Can you override `USER` at runtime?

Yes. For example:

```bash id="xgpuh5"
podman run --rm --user root <image> whoami
```

This overrides the default `USER` set in the image, if permitted by runtime policy and the environment.

---

## 13) What is the security risk of running containers as root?

Root processes inside a container can:

* modify more files inside the image filesystem
* potentially interact with mounted host paths
* increase impact if a breakout or misconfiguration occurs

Even if “container root” isn’t always “host root,” it increases risk.

---

## 14) What is the “Principle of Least Privilege” and how does it apply here?

It means granting only the permissions required to do the job. By using `USER appuser`, the container runs with minimal permissions, reducing harm if something goes wrong.

---

## 15) What additional hardening steps can be combined with `USER`?

Common improvements include:

* using read-only filesystem (`--read-only`)
* dropping Linux capabilities (`--cap-drop`)
* setting seccomp/apparmor profiles
* using user namespaces (`--userns=keep-id`)
* avoiding running privileged containers unless necessary
