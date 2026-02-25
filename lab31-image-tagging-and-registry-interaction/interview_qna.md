# 💬 Interview Q&A — Lab 31: Image Tagging and Registry Interaction

---

## 1) What is an image tag in container registries?
A tag is a human-readable label that points to a specific image manifest in a registry (example: `nginx:latest` or `my-nginx:v1.0`). Tags are references and can be updated to point to a different image over time.

---

## 2) What is semantic versioning for image tags?
Semantic versioning is a structured version format:
- `vMAJOR.MINOR.PATCH` (example: `v1.0.0`)
It helps teams understand compatibility and manage releases more reliably than using only `latest`.

---

## 3) Why is using `latest` risky in production?
Because `latest` can change at any time. Deployments that pull `latest` may get different code and dependencies unexpectedly, causing:
- inconsistent behavior
- unstable rollouts
- difficult debugging and rollbacks

---

## 4) How did you tag an existing image in this lab?
I pulled `nginx:latest` and tagged it as:
```bash id="4e8x7q"
podman tag docker.io/library/nginx my-nginx:v1.0
````

---

## 5) Does tagging create a new copy of the image?

No. Tagging creates a new reference to the same underlying image ID. In this lab, both `nginx:latest` and `my-nginx:v1.0` showed the same IMAGE ID.

---

## 6) Why do you need to log into a registry for pushing images?

Registries require authentication to push images into a user namespace or private repo. Without login, pushes are rejected (401/denied).

---

## 7) What command is used to login with Podman?

```bash id="p3qv7c"
podman login docker.io
```

This stores credentials for registry interaction.

---

## 8) Why do you tag with a registry prefix before pushing?

The registry prefix tells Podman where to push, for example:

```bash id="gnc2zb"
podman tag my-nginx:v1.0 docker.io/abdul4rehman215/my-nginx:v1.0
```

Without the prefix, Podman may treat it as a local image name.

---

## 9) What does `podman push` upload?

It uploads:

* image layers (blobs)
* image configuration
* manifest
  to the specified registry repository and tag.

---

## 10) What happens when you remove an image tag locally with `podman rmi`?

If other tags still reference the same image ID, removing one tag only removes that reference locally. The underlying image may still exist until all references are removed.

---

## 11) What is an image digest?

A digest is an immutable, content-addressable identifier for an image manifest, usually `sha256:<hash>`. It uniquely identifies the exact image content.

---

## 12) Why are digests considered immutable?

Because the digest is derived from the content. If anything changes (layers/manifest), the digest changes. That means a digest always points to the same exact image version.

---

## 13) Why might `podman inspect --format '{{.Digest}}'` be blank?

Depending on Podman version and storage backend, the digest field may not be populated in inspect output for certain image references. In this lab, `skopeo inspect` was used as a reliable alternative.

---

## 14) How did you retrieve the digest reliably in this lab?

Using:

```bash id="ipw0p9"
skopeo inspect docker://docker.io/abdul4rehman215/my-nginx:v1.0 | grep -i Digest
```

---

## 15) What is the key takeaway about tag immutability vs digest immutability?

* **Tags are mutable**: they can be moved to point to different images.
* **Digests are immutable**: they always identify one exact image.
  For reproducible deployments, pulling by digest is the most reliable method.
