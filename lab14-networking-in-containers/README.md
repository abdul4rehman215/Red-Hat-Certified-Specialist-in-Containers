# 🧪 Lab 14: Networking in Containers (Podman)

## 📌 Lab Summary
This lab covers Podman container networking fundamentals:
- Listing default Podman networks (`podman`, `pasta`)
- Inspecting network configuration (subnets, gateway, DNS)
- Creating an isolated custom bridge network
- Running containers with **port publishing** (`-p host:container`)
- Attaching a container to a custom network and validating the assigned IP

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand Podman networking basics (bridge networks, rootless behavior)
- Inspect network configurations using `podman network inspect`
- Create an isolated network using `podman network create`
- Publish container ports to the host using `-p`
- Attach a container to a custom network and verify the network assignment

---

## ✅ Prerequisites
- Linux environment with Podman installed
- Basic terminal usage and networking familiarity

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | v4.9.3 |
| Default Networks Observed | `podman` (bridge), `pasta` |
| Custom Network | `lab-network` (bridge) |
| Test Image | `docker.io/library/nginx` |
| Host Port Used | `8080` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab14-networking-in-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: List Podman Networks

* Listed available networks:

  * `podman network ls`
* Verified details of default `podman` bridge network:

  * subnet `10.88.0.0/16`
  * gateway `10.88.0.1`
  * DNS enabled

### ✅ Task 2: Create and Inspect a Custom Network

* Created a new bridge network:

  * `podman network create lab-network`
* Verified it exists via `podman network ls`
* Inspected network settings:

  * subnet `10.89.0.0/24`
  * gateway `10.89.0.1`
* Checked Podman environment details (`podman info`) for realistic troubleshooting context

### ✅ Task 3: Run Containers with Port Publishing

* Verified port `8080` availability using `ss`
* Ran Nginx with host port publishing:

  * `-p 8080:80`
* Confirmed accessibility:

  * `curl http://localhost:8080`
* Relaunched Nginx attached to `lab-network`:

  * stopped and removed old container to reuse the name
  * ran container with `--network lab-network`
* Verified network assignment and IP via `podman inspect`

---

## ✅ Verification & Validation

* Networks listed successfully (`podman`, `pasta`, plus custom `lab-network`)
* Network inspection returned expected JSON fields:

  * subnet, gateway, interface name, DNS settings
* Port publishing verified:

  * `curl` returned Nginx welcome page HTML
* Network assignment verified:

  * container attached to `lab-network` with IP `10.89.0.2`

---

## 🧠 What I Learned

* Podman uses **bridge networking** by default, often named `podman`
* Newer Podman versions may include additional default networking modes like `pasta`
* `podman network inspect` is essential for debugging:

  * subnets, gateway, dns, interfaces
* Port publishing (`-p`) exposes services to the host
* Custom bridge networks allow isolated container communication and controlled IP ranges
* Container naming conflicts require removing old containers before reusing names

---

## 🌍 Why This Matters

Networking is core to container operations:

* web apps need port publishing for access
* microservices need isolated networks for internal communication
* debugging requires understanding IP ranges, DNS behavior, and port mappings
  These concepts directly map to OpenShift/Kubernetes networking fundamentals.

---

## ✅ Result

* Listed and inspected Podman networks
* Created and inspected a custom bridge network
* Ran a container with host port publishing and confirmed accessibility
* Attached a container to a custom network and verified its assigned IP

---

## ✅ Conclusion

This lab provided hands-on practice with Podman’s container networking: inspecting default networks, creating isolated networks, and publishing ports for external access. These are foundational skills for debugging and deploying container workloads in real environments.
