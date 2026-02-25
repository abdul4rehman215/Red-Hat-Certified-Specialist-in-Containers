# 🧠 Interview Q&A — Lab 07: Layer Caching and Optimization

---

## 1) What is a container image layer?
A layer is a filesystem change created by a build instruction (like `RUN`, `COPY`). Layers stack together to form the final image, enabling caching and reuse.

---

## 2) Why do multiple `RUN` commands often increase image size?
Each `RUN` creates a separate layer. If you do `apt-get update` and later remove package lists in a different layer, the earlier layer still contains those files, increasing final size.

---

## 3) What does layer caching mean in Podman/Docker builds?
Caching means that if a build step’s inputs haven’t changed, the builder can reuse the previously built layer instead of re-running that step, making builds faster.

---

## 4) How did you optimize the Dockerfile in this lab?
By consolidating package install steps into one `RUN` and cleaning cache in the same layer:
- combined `apt-get update` + installs + pip install + cleanup
- removed `/var/lib/apt/lists/*` to reduce size

---

## 5) Why is the order of instructions important for caching?
Because if an early step changes, all later layers must be rebuilt. Placing stable steps (like installing dependencies) before frequently changing steps (like copying source code) maximizes cache reuse.

---

## 6) What changed when you modified `app.py` and rebuilt?
Only the `COPY app.py` layer and subsequent layers changed. The heavy install layer (`apt-get install ...`) was reused from cache.

---

## 7) What is cache-busting and why would you use it?
Cache-busting forces rebuild of certain layers even if inputs appear unchanged. It’s used when you want to ensure a step re-runs, such as pulling latest package updates.

---

## 8) How did you implement cache-busting in this lab?
By adding:
- `ARG CACHEBUST=1`
- `RUN echo "Cache bust: $CACHEBUST"`
And rebuilding with:
- `--build-arg CACHEBUST=$(date +%s)`

---

## 9) What does `podman history myapp:optimized` show?
It shows the layer history of an image, including:
- which instruction created each layer
- layer size contribution
- ordering of layers

---

## 10) Why did the apt-get install layer dominate image size?
Because it installs system packages (Python, pip, curl/wget) and Python dependencies, which add large amounts of data compared to small source files.

---

## 11) What is `dive` and why is it useful?
`dive` is an image analysis tool that shows:
- per-layer contents and size
- wasted bytes and efficiency metrics
It helps identify where to optimize layers.

---

## 12) What is a multi-stage build?
A build technique where you use one stage to build/install dependencies and a later stage to copy only required artifacts into a smaller runtime image.

---

## 13) Why did the multi-stage image become significantly smaller?
Because the final stage contained only runtime requirements, not the full build tooling and temporary artifacts. Build-time dependencies remain in the builder stage.

---

## 14) Why was port mapping changed to `-p 8080:8080` in verification?
Because the Flask app runs on port **8080** inside the container. Mapping `8080:8080` exposes it correctly on the host.

---

## 15) What real-world benefit does optimization provide in OpenShift/Kubernetes environments?
Smaller images and better caching result in:
- faster CI/CD builds
- faster pulls and deployments
- less storage usage in registries and nodes
- improved reliability and scalability for frequent deployments
