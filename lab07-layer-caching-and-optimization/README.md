# 🧪 Lab 07: Layer Caching and Optimization (Podman)

## 📌 Lab Summary
This lab demonstrates **image layer caching** and practical optimization techniques for container builds. Starting from a non-optimized Dockerfile, the lab improves build efficiency and reduces image size by:
- Consolidating RUN layers
- Cleaning package manager cache in the same layer
- Observing build cache behavior when only source code changes
- Using **cache-busting** with build args
- Inspecting layers with `podman history` and `podman inspect`
- Using `dive` to analyze per-layer size and wasted bytes
- Implementing a **multi-stage build** to reduce final runtime image size

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand Docker/Podman layer caching behavior
- Apply optimization techniques that reduce layer count and image size
- Compare build outputs and image sizes between initial vs optimized builds
- Use cache intentionally (and bust it when needed)
- Inspect and analyze layers using `podman history`, `podman inspect`, and `dive`
- Build a multi-stage image to remove unnecessary build-time dependencies from the final image

---

## ✅ Prerequisites
- Podman installed (Podman recommended for OpenShift)
- Basic understanding of Dockerfile/Containerfile syntax
- Terminal access
- Internet connection for pulling base images

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu (cloud lab environment) |
| Podman Version | 4.9.3 |
| Base Image | `ubuntu:22.04` |
| App Type | Python + Flask |
| Analysis Tools | `podman history`, `podman inspect`, `dive` (installed via `.deb`) |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab07-layer-caching-and-optimization/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── Dockerfile.initial
    ├── Dockerfile.optimized
    ├── Dockerfile.multistage
    ├── app.py
    └── requirements.txt
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Build a Non-Optimized Image (Baseline)

* Created a working directory for the lab (`layer-optimization-lab`)
* Wrote a non-optimized Dockerfile with multiple `RUN` steps (`Dockerfile.initial`)
* Created a simple Flask application (`app.py`)
* Built the initial image:

  * `myapp:initial`
* Checked image size:

  * observed larger size due to many layers and no cleanup

### ✅ Task 2: Optimize the Dockerfile (Layer Consolidation)

* Created an optimized Dockerfile (`Dockerfile.optimized`) that:

  * combines package installs and pip install into a single RUN step
  * runs cleanup in the same layer (`apt-get clean` + removing apt lists)
* Built the optimized image:

  * `myapp:optimized`
* Compared image sizes:

  * optimized image size reduced compared to initial

### ✅ Task 3: Leverage Build Cache + Cache Busting

* Modified `app.py` by adding a comment (cache-test change)
* Rebuilt the optimized image and observed caching:

  * only `COPY app.py` layer rebuilt
  * earlier heavy install layers reused from cache
* Added cache-busting layers (`ARG CACHEBUST`, `RUN echo ...`)
* Rebuilt with a changing build arg:

  * `--build-arg CACHEBUST=$(date +%s)`
* Observed which steps were re-executed vs cached

### ✅ Task 4: Inspect and Analyze Layers

* Viewed layer history:

  * `podman history myapp:optimized`
* Inspected image metadata:

  * `podman inspect myapp:optimized | head -n 35`
* Installed and used `dive` to analyze:

  * layer sizes, efficiency, wasted bytes, potential savings

### ✅ Task 5: Advanced Optimization (Multi-Stage Builds)

* Created `requirements.txt` (required for multistage build)
* Wrote a multi-stage Dockerfile (`Dockerfile.multistage`) with:

  * **builder stage** installing python/pip and dependencies
  * **runtime stage** copying only required python packages + app code
* Built `myapp:multistage`
* Compared image sizes and confirmed multistage produced a much smaller runtime image

### ✅ Verification Run

* Confirmed port conflict resolution by stopping an existing container using 8080
* Ran optimized container with `-p 8080:8080` (Flask app inside container)
* Verified output using curl:

  * `Hello from optimized container!`
* Compared final sizes across initial/optimized/multistage

---

## ✅ Verification & Validation

* Podman verified: `podman --version` → `4.9.3`
* Baseline image built and size measured:

  * `myapp:initial` ≈ **392 MB**
* Optimized build reduced size:

  * `myapp:optimized` ≈ **307 MB** (and later builds show ~321 MB depending on cache-bust layers)
* Cache reuse confirmed:

  * `RUN apt-get ...` layer reused (“Using cache”)
  * `COPY app.py` rebuilt after code change
* Layer analysis confirmed:

  * `podman history` clearly shows layer ordering and sizes
  * `dive` highlights heavy layers and optimization opportunities
* Multi-stage image significantly smaller:

  * `myapp:multistage` ≈ **190 MB**

---

## 🧠 What I Learned

* Each Dockerfile instruction typically creates a new layer; too many layers increase image size and reduce efficiency
* Combining package installs into one RUN reduces layers and enables cleanup in the same layer
* Ordering matters: stable steps first improves cache hit rate (e.g., install deps before copying frequently-changing files)
* Build args can force cache-busting when you need a fresh rebuild
* Tools like `podman history` and `dive` help identify large layers and wasted bytes
* Multi-stage builds are a practical best practice to ship smaller runtime images

---

## 🌍 Why This Matters

Layer optimization improves:

* build speed in CI/CD pipelines
* image distribution performance (faster pulls)
* disk usage on hosts and registries
* maintainability and operational reliability
  This is especially important in OpenShift/Kubernetes environments where images are pulled and deployed frequently.

---

## ✅ Result

* Built and compared baseline vs optimized vs multi-stage images
* Verified caching behavior and cache busting techniques
* Inspected layer history and analyzed image contents with `dive`
* Successfully ran the optimized Flask app container and validated output

---

## ✅ Conclusion

This lab demonstrated how to build smarter images by reducing layers, cleaning up temporary artifacts, and leveraging caching. It also showed how multi-stage builds dramatically reduce final image size by removing build-time dependencies—an essential best practice for production-grade container images.
