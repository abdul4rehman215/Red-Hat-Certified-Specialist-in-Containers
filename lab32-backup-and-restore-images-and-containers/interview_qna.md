# 💬 Interview Q&A — Lab 32: Backup and Restore Images and Containers with Podman

---

## 1) What does `podman save` do?
`podman save` exports a **container image** (layers + metadata) into a tar archive. It’s mainly used for backups or transferring images between systems (including air-gapped environments).

---

## 2) What does `podman load` do?
`podman load` imports an image tar archive created by `podman save` and restores the image into local storage, preserving repository name and tags.

---

## 3) What is the difference between `podman save` and `podman export`?
- `podman save` works with **images** and preserves layers/metadata/tags.
- `podman export` works with **containers** and exports only the container filesystem (no image layers/metadata).

---

## 4) Why would you save an image to a tarball?
Common use cases:
- moving images to offline/air-gapped systems
- disaster recovery backups
- transferring images without pulling from a registry
- archiving a known-good image version

---

## 5) How did you confirm the tarball was created correctly?
I verified:
- file exists and size with `ls -lh alpine_backup.tar`
- file type with `file alpine_backup.tar` (showed `POSIX tar archive`)

---

## 6) Does `podman load` restore the image name and tags?
Yes. In this lab, `podman load` restored:
- `docker.io/library/alpine:latest`

---

## 7) What does `podman commit` do?
`podman commit` creates a new image from the current filesystem state of an existing container. It’s like taking a snapshot of the container changes and turning it into an image.

---

## 8) When is `podman commit` useful?
- saving a container state for debugging
- creating a quick “golden image” from a tested container
- capturing manual runtime changes when no Dockerfile is available

---

## 9) How did you validate the committed image contained your changes?
I ran:
```bash id="s2o2d0"
podman run --rm my_custom_alpine:v1 cat /testfile
````

It printed:

* `Lab 12`

---

## 10) What are important limitations of `podman commit`?

Commit does **not** capture:

* data stored in volumes
* running processes state
* network configuration

It also isn’t as reproducible as building from a Dockerfile/Containerfile.

---

## 11) Why are saved image tarballs architecture-specific?

Because the layers contain binaries built for a specific CPU architecture. An image saved from `x86_64` may not run correctly on `ARM` systems unless it’s a multi-arch image.

---

## 12) How can you check disk usage impact of images and containers?

Using:

```bash id="qv3b8s"
podman system df
```

It shows totals and reclaimable storage for images, containers, and volumes.

---

## 13) What is a best practice for reproducible container builds compared to commit?

Prefer building images using Dockerfiles/Containerfiles because:

* builds are versioned and auditable
* builds are repeatable
* changes are explicit and reviewable

---

## 14) How would you verify the integrity of a saved tarball?

Compute and store a checksum:

```bash id="x6w7ee"
sha256sum alpine_backup.tar
```

Then compare it later after transfer.

---

## 15) What’s the key takeaway from this lab?

Use:

* `podman save/load` for portable image backups and transfers
* `podman commit` for quick snapshots (with known limitations)
  And always consider reproducibility, portability, and storage impact in real environments.

