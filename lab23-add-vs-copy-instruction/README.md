# 🧪 Lab 23: `ADD` vs `COPY` Instruction in Dockerfiles

## 🧾 Lab Summary
This lab explored the practical differences between `COPY` and `ADD` in Dockerfiles/Containerfiles. I tested both instructions for simple file copying, demonstrated `ADD`’s **automatic archive extraction**, verified `ADD`’s **remote URL fetch** capability, and reviewed how both instructions affect **build cache behavior**. Finally, I demonstrated why `COPY` is generally safer and preferred for predictable builds.

---

## 🎯 Objectives
- Understand the differences between `ADD` and `COPY`
- Learn best practices for choosing `ADD` vs `COPY`
- Experiment with `ADD` automatic archive extraction
- Validate `COPY` predictable file copying
- Explore `ADD` remote URL fetching behavior
- Analyze build efficiency and security implications

---

## ✅ Prerequisites
- Basic Docker/Podman understanding
- Podman installed (recommended for OpenShift compatibility)
- Text editor (Nano/Vim/VS Code)
- Internet access (for remote URL test)
- Basic Linux command line skills

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image Used | `alpine:latest` |
| Lab Type | Local build context + remote URL fetch |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab23-add-vs-copy-instruction/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Basic `COPY` Instruction

* Created a local file `testfile.txt`
* Used `COPY` in `Dockerfile.copy` to copy the file into `/destination/`
* Verified the file content during build and at runtime using `podman run`

**Key learning:** `COPY` is straightforward and predictable (only copies from build context).

---

### ✅ Task 2: Basic `ADD` Instruction

* Used `ADD` in `Dockerfile.add` to copy the same local file into `/destination/`
* Verified output matches the `COPY` test

**Key learning:** For basic local copying, `ADD` and `COPY` behave similarly.

---

### ✅ Task 3: `ADD` Archive Extraction Capability

* Created a compressed tar archive (`archive.tar.gz`)
* Used `ADD archive.tar.gz /extracted/` in `Dockerfile.add-extract`
* Verified that `ADD` automatically extracted the archive into the target directory

**Key learning:** `ADD` auto-extracts supported archives (convenient but has security implications).

---

### ✅ Task 4: Remote URL Fetching with `ADD`

* Created `Dockerfile.add-url` using:

  * `ADD https://.../README.md /remote/`
* Built the image and validated that the remote file content was included in the image and printed during build/runtime

**Key learning:** `ADD` can fetch remote URLs, which introduces external dependency and security risks.

---

### ✅ Task 5: Comparing Build Cache Behavior

* Created `version.txt` as `Version 1`, built with `COPY` (`Dockerfile.cache`)
* Modified it to `Version 2`, rebuilt, and confirmed cache invalidation from the `COPY` step onward
* Repeated with `ADD` using `Dockerfile.cache-add`

**Key learning:** Both `COPY` and `ADD` invalidate build cache when local source files change.

---

### ✅ Task 6: Security Implications (Archive Extraction Risk)

* Created a simulated “malicious” archive (`bad.tar.gz`)
* Used `ADD bad.tar.gz /malicious/` in `Dockerfile.security`
* Verified that `ADD` automatically extracted the archive contents into the image

**Key learning:** `ADD` extraction can be dangerous with untrusted archives; `COPY` is safer for normal file transfers.

---

## ✅ Verification & Validation

* Confirmed all demo images built and existed via `podman images`
* Verified file contents using `podman run --rm <image>`
* Verified archive extraction via `ls -la /extracted/` and `cat /extracted/testfile.txt`
* Verified remote URL content inclusion (downloaded during build)

---

## 🧠 What I Learned

* **Use `COPY` by default** for predictable local file copying
* Use `ADD` only when you specifically need:

  * archive extraction
  * remote URL fetching
* `ADD` introduces build-time external dependencies (URLs) and increases risk when handling untrusted archives
* Cache behavior is similar for local files, but remote URL behavior introduces complexity

---

## 🔐 Security Relevance (When It Matters)

* `ADD` auto-extracting archives can be abused if build context includes untrusted `.tar.gz`
* `ADD` remote URL fetching introduces a supply-chain risk:

  * URL content can change
  * build reproducibility may break
  * content integrity is not guaranteed unless verified separately

✅ Best practice: Use `COPY` unless `ADD` features are strictly required.

---

## 🌍 Real-World Applications

* Writing secure and reproducible Containerfiles for CI/CD pipelines
* Avoiding unintended archive extraction in production builds
* Reducing external dependencies by downloading remote files with controlled tools (`curl/wget`) + checksum verification

---

## ✅ Result

* Built and tested images using `COPY` and `ADD`
* Demonstrated `ADD` archive extraction and remote URL behavior
* Verified cache invalidation on file changes
* Reviewed security implications and reinforced best practices

✅ Lab completed successfully on a cloud lab environment.
