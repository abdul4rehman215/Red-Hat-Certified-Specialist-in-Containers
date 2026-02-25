# 💬 Interview Q&A — Lab 21: Understanding the `FROM` Instruction

---

## 1) What does the `FROM` instruction do in a Containerfile/Dockerfile?
`FROM` defines the **base image** that the container build starts from. Every instruction that follows (like `RUN`, `COPY`, `ENV`) applies on top of the filesystem and environment provided by that base image.

---

## 2) Why must `FROM` typically be the first instruction?
Because it sets the starting layer for the build. The build process needs a base image before it can apply additional layers and instructions.

---

## 3) What is a “base image” in container builds?
A base image is a prebuilt container image that provides:
- a filesystem layout
- OS libraries and tools (depending on the image)
- a starting environment to build your application image

Example: `ubi8/ubi:8.7` provides a Red Hat UBI 8 userspace to build upon.

---

## 4) Why is using `latest` considered risky?
`latest` can change over time. If the base image updates, your builds might suddenly behave differently (new packages, changed dependencies, or vulnerabilities). That breaks **reproducibility** and can lead to unexpected production issues.

---

## 5) What is “pinning” an image and why is it important?
Pinning means specifying a fixed version (tag) like:
- `ubi8/ubi:8.7`

This ensures the same base image is used each time, improving **consistency** across builds and environments.

---

## 6) What is the difference between pinning by tag vs. pinning by digest?
- **Tag pinning**: `ubi:8.7` — stable, human readable, but the tag could theoretically be repointed.
- **Digest pinning**: `ubi@sha256:...` — strongest reproducibility because it points to an exact immutable image content.

Digest pinning is best when you need strict supply-chain consistency.

---

## 7) How can you check an image’s digest and metadata before using it?
Tools like `skopeo` can inspect image metadata without pulling and running it, for example:
- digest
- architecture
- tags
- creation time

This helps verify what you’re building from.

---

## 8) What are common criteria for selecting a base image?
Key considerations include:
- **Security** (trusted publisher, update cadence)
- **Size** (minimal images reduce attack surface)
- **Compatibility** (OS packages, libraries, architecture)
- **Maintenance** (patch frequency, lifecycle support)
- **Purpose** (runtime vs. build toolchains)

---

## 9) What are Universal Base Images (UBI) and why use them?
UBI images are enterprise-friendly base images designed for building container workloads in Red Hat ecosystems. They provide a stable userspace and are commonly used for consistent builds and deployments.

---

## 10) What happens if you choose a base image that’s too minimal?
Minimal images reduce size and attack surface, but they may lack tools (shell, package manager, debugging utilities). This can make building or troubleshooting harder unless you install what you need.

---

## 11) Can a Containerfile have multiple `FROM` instructions?
Yes — multiple `FROM` instructions are used in **multi-stage builds**. This helps:
- build in one stage (with compilers/tools)
- copy only required artifacts into a smaller runtime stage

Result: smaller, cleaner production images.

---

## 12) Why is base image selection relevant to container security?
The base image contributes to:
- available packages and libraries
- default users and permissions
- patch level of OS components

A poor base image choice can introduce known vulnerabilities or unnecessary services.

---

## 13) What is the role of layers in container builds?
Each instruction (like `RUN`) creates a new image layer. The base image is the first layer. Layering affects:
- build cache
- image size
- reproducibility

---

## 14) How did you verify the image you built worked correctly?
After building, I ran the container and checked the file created during build:
- `podman run --rm my-base-image cat /tmp/status.txt`

The output confirmed the `RUN` step executed successfully.

---

## 15) In a production CI/CD pipeline, what best practice would you apply regarding `FROM`?
- Avoid `latest`
- Prefer pinned tags or digests
- Validate base images using trusted registries
- Periodically refresh pinned versions with controlled updates (security patching workflow)
