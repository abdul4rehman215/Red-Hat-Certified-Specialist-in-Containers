# 🧠 Interview Q&A — Lab 04: Creating and Managing Pods (Podman)

---

## 1) What is a pod in the context of containers?
A pod is a group of one or more containers that share certain resources, most importantly the **network namespace**. Pods are a core concept in Kubernetes/OpenShift, and Podman provides a pod abstraction to model similar behavior locally.

---

## 2) Why does Podman create an “infra container” in a pod?
The infra container holds the shared namespaces (like networking) for the pod. Other containers join the infra container’s namespaces, enabling pod-like shared networking and resource coordination.

---

## 3) What does `podman pod create --name demo-pod -p 8080:80` do?
It creates a pod named `demo-pod` and maps:
- host port **8080** → pod port **80**
This means services listening on port 80 inside the pod can be accessed via port 8080 on the host.

---

## 4) How do you list pods in Podman?
Use:
- `podman pod list`
This shows pod ID, name, status, infra ID, and container count.

---

## 5) How do you run a container inside a Podman pod?
Use:
- `podman run --pod <pod-name> ...`
Example:
- `podman run -d --pod demo-pod --name nginx-container nginx:alpine`

---

## 6) What does `podman ps --pod` show?
It shows containers grouped by pod, including:
- infra container
- application containers
It also shows port mappings and container status.

---

## 7) How did you verify both containers existed inside the pod?
I used:
- `podman pod inspect demo-pod | jq '.Containers[].Names'`
This displayed names for the infra container and each container attached to the pod.

---

## 8) Why was `jq` installed during the lab?
`podman pod inspect` outputs JSON. `jq` helps parse JSON and extract only the values needed (like container names) in a readable way.

---

## 9) How did you verify shared networking between containers in the pod?
I executed into the nginx container and pinged the redis container by name:
- `podman exec -it nginx-container sh`
- `ping -c 4 redis-container`
Successful ping indicates the containers share the pod network namespace and can reach each other.

---

## 10) Why did `ping` initially fail inside the nginx container?
The nginx:alpine image is minimal and often does not include networking tools like `ping`. This is common in lightweight container images.

---

## 11) How did you fix missing `ping` in Alpine?
Inside the container, I installed `iputils` using:
- `apk add --no-cache iputils`
Then ping worked as expected.

---

## 12) What does `podman port demo-pod` show?
It displays port forwarding rules for the pod, e.g.:
- `80/tcp -> 0.0.0.0:8080`
This confirms that pod port 80 is exposed on host port 8080.

---

## 13) What is a Podman volume and why use it in a pod?
A Podman volume provides persistent/shared storage managed by Podman. It allows multiple containers to share data or persist data beyond container lifecycle.

---

## 14) How did you verify shared volume behavior across containers?
I mounted the same volume into two containers and created a file from one container, then verified it exists in the other:
- `podman exec -it nginx2 touch /data/testfile`
- `podman exec -it redis2 ls /data` → showed `testfile`

---

## 15) Why are pods important for OpenShift/Kubernetes learning?
OpenShift/Kubernetes schedules and manages pods as the basic deployment unit. Understanding pods helps with:
- multi-container patterns (sidecars)
- service networking
- shared storage workflows
- debugging and inspection in orchestrated environments
