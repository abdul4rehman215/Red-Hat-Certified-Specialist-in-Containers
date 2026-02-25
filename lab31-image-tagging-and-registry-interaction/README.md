# 🧪 Lab 31: Image Tagging and Registry Interaction

## 🧾 Lab Summary
This lab covered essential image management workflows using Podman and a container registry (Docker Hub). I practiced **semantic tagging**, authenticated to a registry, pushed and pulled images, and explored how **tags can move** while **digests remain immutable**. I also used `skopeo inspect` as a reliable method for retrieving image digests when `podman inspect` didn’t return a digest value in this environment.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Tag container images using semantic versioning
- Authenticate with container registries (Docker Hub or private)
- Push and pull images from registries
- Understand tag immutability concepts and image digests

---

## ✅ Prerequisites
- Podman installed (v3.0+)
- Docker Hub account (or access to a private registry)
- Basic Linux command-line familiarity
- Internet access

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Registry | Docker Hub (`docker.io`) |
| Demo Image | `nginx:latest` |
| Digest Tool | `skopeo inspect` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab31-image-tagging-and-registry-interaction/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Tagging Images Semantically

* Listed current images
* Pulled `nginx:latest` (minimal required step since it was not present locally)
* Tagged the image using semantic versioning style:

  * `my-nginx:v1.0`
* Verified both tags point to the same image ID

**Key concept:** Semantic version tags (vMAJOR.MINOR.PATCH) improve clarity and operational control.

---

### ✅ Task 2: Logging into a Registry

* Logged into Docker Hub:

  * `podman login docker.io`
* Verified registry configuration via `podman info`

**Key concept:** Authentication is required for pushing to your namespace and private repos.

---

### ✅ Task 3: Pushing Images to Registry

* Retagged the image with a registry namespace prefix:

  * `docker.io/abdul4rehman215/my-nginx:v1.0`
* Pushed it to Docker Hub using `podman push`

**Key concept:** Registry-prefixed tags define where the image will be uploaded.

---

### ✅ Task 4: Pulling Images from Registry

* Removed the pushed tag locally (`podman rmi docker.io/...`)
* Pulled it back from Docker Hub:

  * `podman pull docker.io/abdul4rehman215/my-nginx:v1.0`
* Verified the image exists locally again

**Key concept:** Pulling retrieves whatever the tag points to at that moment.

---

### ✅ Task 5: Tag Immutability and Digests

* Attempted to print digest using:

  * `podman inspect --format '{{.Digest}}' ...`
  * (returned blank in this environment)
* Retrieved digest reliably using:

  * `skopeo inspect docker://... | grep -i Digest`
* Pulled the image by digest:

  * `podman pull docker.io/<user>/my-nginx@sha256:...`

**Key concept:**

* Tags can be reassigned (mutable references)
* Digests are immutable identifiers for a specific image content

---

## ✅ Verification & Validation

* `podman images | grep nginx` confirmed:

  * `nginx:latest` and `my-nginx:v1.0` share the same IMAGE ID
* `podman push` succeeded and uploaded blobs + manifest
* `podman pull` successfully restored the image locally
* `skopeo inspect` returned a digest value
* `podman pull ...@sha256:<digest>` succeeded (skipped existing blobs)

---

## 🧠 What I Learned

* Tags are human-friendly references and should follow semantic versioning for production
* Registry login enables pushing to your namespace and accessing private images
* Pushing and pulling are core workflow steps for CI/CD pipelines
* Digests provide a content-addressable immutable reference (best for reproducibility)
* `skopeo inspect` is very useful for registry metadata (digest/tags) when Podman output varies

---

## 🔐 Security & Operational Relevance

* Using digests improves supply-chain integrity and reproducibility
* Tag immutability policies (when enforced by registries) prevent accidental overwrites
* Always prefer stable, pinned versions for production deployments:

  * avoid relying solely on `latest`

---

## 🌍 Real-World Applications

* Publishing versioned images for releases (v1.0.0, v1.1.0, etc.)
* Promoting images across environments (dev → staging → prod)
* Ensuring deployments use exact image digests for consistent behavior
* Supporting rollback by keeping older tags and matching digest references

---

## ✅ Result

* Successfully tagged images semantically
* Logged into Docker Hub and pushed an image to a personal namespace
* Pulled the image back from Docker Hub
* Identified and used an immutable digest reference with `skopeo`
* Cleaned up images after completing the lab

✅ Lab completed successfully on a cloud lab environment.
