# 🧠 Interview Q&A — Lab 14: Networking in Containers (Podman)

---

## 1) What is the default Podman network and what driver does it use?
Podman typically creates a default network named `podman` using the **bridge** driver. This enables container-to-container communication on a virtual bridge.

---

## 2) Why did you also see a `pasta` network?
Newer Podman builds may include additional networking backends like `pasta`. Seeing it listed is normal and depends on the Podman version and configuration.

---

## 3) What command lists Podman networks?
- `podman network ls`

---

## 4) What does `podman network inspect` show?
It shows network configuration details such as:
- network name and driver
- interface name (e.g., `podman0`)
- subnet and gateway
- DNS enabled/disabled
- IPAM driver options

---

## 5) What subnet did the default `podman` network use in this lab?
It used:
- `10.88.0.0/16`
with gateway:
- `10.88.0.1`

---

## 6) Why is inspecting subnet/gateway important for troubleshooting?
It helps diagnose:
- IP conflicts
- routing issues
- DNS problems
- unexpected connectivity failures between containers or host

---

## 7) How do you create a custom network in Podman?
Use:
- `podman network create <name>`
Example:
- `podman network create lab-network`

---

## 8) What benefit does a custom network provide?
Custom networks enable:
- isolation between container groups
- custom subnet ranges
- cleaner multi-service communication patterns
- better control for lab/testing setups

---

## 9) How did you publish container ports to the host?
Using `-p hostPort:containerPort`, for example:
- `-p 8080:80`

This binds host port 8080 to container port 80.

---

## 10) How did you verify the published port worked?
By running:
- `curl http://localhost:8080 | head`
and confirming the Nginx welcome HTML appeared.

---

## 11) Why did you check port 8080 before starting the container?
To avoid port binding failure if another service/container was already using 8080:
- `ss -tulnp | grep 8080 || true`

---

## 12) How do you attach a container to a specific network?
Use:
- `--network <network_name>`
Example:
- `--network lab-network`

---

## 13) Why did you remove the container before re-running it with the same name?
Because `podman run --name webapp ...` fails if a container named `webapp` already exists (even if stopped). Removing it avoids name conflicts.

---

## 14) How did you confirm the container was attached to `lab-network`?
By inspecting the container and checking the Networks section:
- `podman inspect webapp | grep -A 5 "Networks"`

It showed:
- network name `lab-network`
- assigned IP `10.89.0.2`
- gateway `10.89.0.1`

---

## 15) How does this relate to OpenShift/Kubernetes networking?
These fundamentals map to:
- service exposure (NodePort/Route vs port mapping)
- pod networking and CIDRs
- internal DNS-based discovery
- network isolation and segmentation practices
