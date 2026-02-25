# 💬 Interview Q&A — Lab 25: Securing Images with Least Privilege

---

## 1) What does “least privilege” mean in the context of containers?
Least privilege means giving a container (and the processes inside it) **only the minimum permissions required** to function. This reduces impact if the container is compromised.

---

## 2) Why is running a container as root risky?
If an attacker gains execution inside a root container, they may:
- modify important directories inside the image/container
- abuse mounted volumes
- potentially exploit misconfigurations for escalation
Even if container root isn’t always host root, it still increases risk.

---

## 3) What is `podman scan` used for?
`podman scan` checks container images for known vulnerabilities (CVEs), typically listing:
- CVE ID
- severity
- affected package
- installed version
- fixed version (if available)

---

## 4) What did your vulnerability scan show for `nginx:latest`?
The scan showed:
- 0 CRITICAL vulnerabilities
- 2 HIGH vulnerabilities
- 2 MEDIUM vulnerabilities
- 1 LOW vulnerability

The vulnerabilities were in common libraries such as `libssl3` and `libc6`, which often require updating the base image.

---

## 5) What is a common best practice after identifying vulnerabilities in an image?
- Use a newer base image tag (or rebuild with updated packages)
- rebuild regularly
- integrate scanning into CI/CD
- avoid stale `latest` images in production pipelines

---

## 6) Why remove package caches inside container images?
Caches (apt/apk metadata) can:
- increase image size
- add unnecessary files and noise
- increase surface area for investigation and exposure
Removing them makes images cleaner and leaner.

---

## 7) How did you reduce cache artifacts in the Debian-based Nginx image?
I built a new image using:
```dockerfile
RUN rm -rf /var/cache/apt/* /var/lib/apt/lists/*
````

This reduced size slightly and removed cache artifacts.

---

## 8) Why are minimal base images considered more secure?

Smaller images typically have:

* fewer installed packages
* fewer libraries and tools
* reduced attack surface
  They also reduce deployment size and speed up pulls.

---

## 9) What size differences did you observe between Debian-based Nginx and Alpine-based Nginx?

In this lab:

* Debian-based Nginx image was ~192 MB
* Alpine-based Nginx image was ~22.5 MB

This demonstrated how base image choice dramatically affects size and footprint.

---

## 10) What challenge occurs when running Nginx as a non-root user?

Nginx may fail to bind to privileged ports (like port 80) without root privileges, because ports below 1024 are privileged on Linux.

---

## 11) How did you allow Nginx to bind to port 80 without running as root?

I used Linux capabilities:

```bash
setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx
```

This grants the Nginx binary the minimum capability needed to bind to privileged ports.

---

## 12) How did you verify Nginx was running as a non-root user?

I checked process ownership using:

```bash
podman exec secure_nginx ps aux
```

The output showed Nginx master/worker processes running as `nginxuser`.

---

## 13) What is “image provenance” and why is it important?

Image provenance is about proving **who produced an image** and ensuring integrity/trust. It helps prevent tampering and supports supply chain security.

---

## 14) How did you implement provenance in this lab?

I:

* generated a GPG key
* signed the image using:

  ```bash
  podman image sign --sign-by your@email.com nginx_nonroot
  ```
* verified trust metadata using:

  ```bash
  podman image trust show
  ```

---

## 15) What is the key security takeaway from this lab?

Secure container builds are layered:

* scan images (visibility)
* minimize artifacts (cleanup)
* reduce footprint (minimal base images)
* run as non-root (least privilege)
* sign images (trust/provenance)
  Together, these controls reduce risk across build and runtime.

