# 🧪 Lab 06: Building Custom Container Images (Podman)

## 📌 Lab Summary
This lab demonstrates how to build a **custom container image** using Podman and a **Containerfile** (Dockerfile-compatible). The image is based on `nginx:alpine`, includes a custom `index.html`, and writes build metadata during image creation using environment variables.

Key outcomes:
- Created a build context (`custom-nginx/`)
- Authored a Containerfile with `FROM`, `ENV`, `COPY`, `RUN`
- Built and tagged an image (`my-custom-nginx`)
- Ran the image as a container and validated via `curl`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the structure of a **Containerfile** (Dockerfile alternative for Podman)
- Use Containerfile instructions:
  - `FROM`, `ENV`, `COPY`, `RUN`
- Build and tag images using `podman build`
- Run and validate a containerized web server using port mappings

---

## ✅ Prerequisites
- Linux environment with Podman installed
- Basic command line familiarity

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu (cloud lab environment) |
| Podman Version | 4.9.3 |
| Base Image | `docker.io/nginx:alpine` |
| Custom Image | `localhost/my-custom-nginx:latest` |
| Test Tool | `curl` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab06-building-custom-container-images/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── Containerfile
    └── index.html
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Create a Simple Containerfile

* Created a working directory for the build context:

  * `custom-nginx/`
* Created a custom landing page:

  * `index.html`
* Authored a `Containerfile` that:

  * uses Nginx Alpine as base (`FROM`)
  * sets metadata using environment variables (`ENV`)
  * copies `index.html` into the Nginx web root (`COPY`)
  * writes build info into `/build-info.txt` during build (`RUN`)
* Verified project files using `ls -l`

### ✅ Task 2: Build and Tag the Image

* Built the image using:

  * `podman build -t my-custom-nginx .`
* Verified the image exists locally using:

  * `podman images`

### ✅ Task 3: Run and Validate the Container

* Ran the custom image in detached mode with port mapping:

  * host `8080` → container `80`
* Verified container status using `podman ps`
* Verified web output using `curl http://localhost:8080`

---

## ✅ Verification & Validation

* Podman verified:

  * `podman --version` returned `podman version 4.9.3`
* Build context verified:

  * `ls -l` showed `Containerfile` and `index.html`
* Image build verified:

  * `podman build` completed with `Successfully tagged localhost/my-custom-nginx:latest`
* Image presence verified:

  * `podman images` listed `localhost/my-custom-nginx:latest`
* Runtime verified:

  * `podman ps` showed container `Up` with `0.0.0.0:8080->80/tcp`
* Functional test verified:

  * `curl http://localhost:8080` returned the custom HTML string

---

## 🧠 What I Learned

* How Containerfiles define an image build process using layer-based steps
* How to embed build-time metadata using `ENV` + `RUN`
* How build context matters (files like `index.html` must exist in the build directory)
* How to test a containerized web service quickly using `curl`

---

## 🌍 Why This Matters

Building custom images is a core workflow in container-based development:

* it enables packaging apps + configuration in a reproducible way
* it supports CI/CD pipelines and OpenShift builds
* it improves portability across environments

---

## 🧩 Real-World Applications

* Shipping custom application images for deployment on OpenShift/Kubernetes
* Baking configuration and static assets into images
* Adding build metadata (author, version, commit ID) for traceability
* Creating minimal runtime containers using small base images like Alpine

---

## ✅ Result

* Built a working custom Nginx image with a custom page
* Successfully ran the container and served the custom HTML on port 8080
* Confirmed functionality via `curl`

---

## ✅ Conclusion

This lab provided hands-on practice creating a Containerfile, building a custom image with Podman, and validating a running container. These fundamentals directly support OpenShift workflows where building and deploying custom images is a daily task.
