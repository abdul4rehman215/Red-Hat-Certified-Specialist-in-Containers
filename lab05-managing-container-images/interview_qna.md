# 🧠 Interview Q&A — Lab 05: Managing Container Images (Podman)

---

## 1) What is a container image?
A container image is a packaged filesystem and metadata bundle that contains everything needed to run an application in a container (binaries, libraries, configuration defaults). Containers are runtime instances created from images.

---

## 2) What does `podman search ubuntu` do?
It searches container registries (by default Docker Hub / configured registries) for images matching the keyword `ubuntu`, showing name, description, stars, and whether the image is official.

---

## 3) Why would you use `podman search --filter=is-official=true ubuntu`?
To filter results so only official images appear. This helps reduce risk and improves trust when selecting base images.

---

## 4) What is Docker Hub in this context?
Docker Hub is a public container registry (`docker.io`) that hosts container images. Podman can pull images from Docker Hub using standard image references.

---

## 5) What is the purpose of `podman login docker.io`?
It authenticates your Podman client to Docker Hub. This can help avoid rate limits and may be required for private repositories.

---

## 6) What does `podman pull docker.io/library/ubuntu:latest` do?
It downloads the Ubuntu image tagged `latest` from Docker Hub to the local image store so it can be used to run containers.

---

## 7) What are image tags and why do they matter?
Tags represent versions/variants of an image (e.g., `latest`, `20.04`). Tags help ensure **reproducible deployments** by pinning a specific version instead of relying on a moving `latest`.

---

## 8) What does `podman images` show?
It lists images stored locally, including:
- repository name
- tag
- image ID
- creation time
- size

---

## 9) What does `podman inspect` provide for an image?
It returns JSON metadata such as:
- image ID and digest
- architecture and OS
- environment variables
- default command (CMD)
- filesystem layers (RootFS layers)

---

## 10) Why is image inspection important before deployment?
It helps verify what you are about to run:
- architecture compatibility
- default command entrypoint behavior
- environment variables
- layer structure and digest (integrity and traceability)

---

## 11) What does `podman inspect --format "{{.Config.Env}}" ...` do?
It extracts only the environment variable list from the image metadata using a Go-template format string, making output easier to read.

---

## 12) What does `podman rmi docker.io/library/ubuntu:20.04` do?
It removes the specified image tag from local storage. If no other tags reference the same image layers, Podman deletes the underlying image data.

---

## 13) Why might `podman rmi` fail sometimes?
If an image is currently being used by an existing container, Podman may block removal unless forced.

---

## 14) What does `podman image prune -a` do?
It removes unused images (those not referenced by any containers). The `-a` flag makes it more aggressive, cleaning up more images.

---

## 15) What is the security risk of using random community images?
Community images may contain:
- outdated packages
- misconfigurations
- hidden malware/backdoors
Best practice is to use official or verified images, pin tags, and scan images in CI/CD.
