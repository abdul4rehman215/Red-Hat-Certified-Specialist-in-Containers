# 🧪 Lab 20: Service and Ingress Setup (ClusterIP, NodePort, Ingress-NGINX)

## 📌 Lab Summary
This lab demonstrates how to expose a Kubernetes application using multiple methods:
- **ClusterIP** for internal-only access inside the cluster
- **NodePort** for node-level external access
- **Ingress** (Ingress-NGINX controller) for hostname-based HTTP routing

A sample **Nginx deployment** was created and exposed using both **ClusterIP** and **NodePort** services. Then, an **Ingress-NGINX controller** was installed, an **Ingress resource** was created, and access was validated externally using a custom hostname mapped via `/etc/hosts`.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Expose an application internally using **ClusterIP**
- Expose an application externally using **NodePort**
- Configure and validate **Ingress** for hostname-based routing
- Install and verify an Ingress controller (ingress-nginx)
- Test accessibility using curl from the terminal

---

## ✅ Prerequisites
- Running Kubernetes/OpenShift cluster
- `kubectl` (or `oc`) installed and configured
- Basic knowledge of Pods, Deployments, Services, and networking concepts
- A sample workload (Nginx) to expose

> Note: `oc` was not available in this environment, so the lab used Kubernetes Ingress rather than OpenShift Routes.

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Cluster | Minikube |
| Kubernetes Version | v1.30.2 |
| Node IP | `192.168.49.2` |
| Deployment | `nginx` (`nginx:latest`) |
| ClusterIP Service | `nginx-clusterip` |
| NodePort Service | `nginx-nodeport` (`30007/TCP`) |
| Ingress Controller | ingress-nginx |
| Ingress Hostname | `nginx.example.com` |
| Ingress Address | `192.168.49.2` |
| Test Tools | `kubectl`, `curl`, `/etc/hosts` entry |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab20-service-and-ingress-setup/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    └── nginx-ingress.yaml
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Create ClusterIP and NodePort Services

#### 1) Deploy a sample Nginx application

* Created deployment:

  * `kubectl create deployment nginx --image=nginx:latest`
* Verified deployment and pod status:

  * `kubectl get deployments`
  * `kubectl get pods`

#### 2) Expose via ClusterIP (internal)

* Created ClusterIP service:

  * `kubectl expose deployment nginx --port=80 --type=ClusterIP --name=nginx-clusterip`
* Verified:

  * `kubectl get svc nginx-clusterip`

#### 3) Expose via NodePort (external via node IP)

* Created NodePort service:

  * `kubectl expose deployment nginx --port=80 --type=NodePort --name=nginx-nodeport`
* Verified:

  * `kubectl get svc nginx-nodeport`
* Tested NodePort access using Minikube node IP:

  * `curl -I http://192.168.49.2:30007`

---

## ✅ Task 2: Configure OpenShift Route or Kubernetes Ingress

### Route (OpenShift)

* Not used here (`oc` not installed/configured)

### ✅ Kubernetes Ingress (Ingress-NGINX)

#### 1) Install Ingress-NGINX controller

* Applied official ingress-nginx deployment manifest (cloud provider YAML)
* Verified controller pod in `ingress-nginx` namespace

#### 2) Create Ingress resource for external routing

* Created `nginx-ingress.yaml` with:

  * host: `nginx.example.com`
  * path `/` → backend service `nginx-nodeport:80`
* Applied and verified Ingress:

  * `kubectl apply -f nginx-ingress.yaml`
  * `kubectl get ingress nginx-ingress`

#### 3) Test external access by hostname

* Added host entry:

  * `192.168.49.2 nginx.example.com` → `/etc/hosts`
* Verified access:

  * `curl -I http://nginx.example.com`

---

## ✅ Verification & Validation

* Deployment ready: `1/1`
* ClusterIP service created successfully and visible via `kubectl get svc`
* NodePort service created and reachable via node IP + nodeport
* Ingress controller deployed and running in `ingress-nginx`
* Ingress resource created and shows address = Minikube IP
* Hostname routing works via `/etc/hosts` mapping and returns HTTP 200

---

## 🧠 What I Learned

* **ClusterIP** is for internal traffic only (service discovery inside cluster)
* **NodePort** exposes the app on each node’s IP on a port in `30000-32767`
* **Ingress** provides layer-7 routing and friendly hostnames (HTTP/HTTPS)
* Installing an Ingress controller is required before Ingress resources work
* `/etc/hosts` is a simple method to test hostnames in local lab environments

---

## 🌍 Why This Matters

Most Kubernetes apps are exposed using a combination of:

* internal services (ClusterIP)
* external routing (Ingress or OpenShift Routes)
  These patterns are core skills for deploying web services and APIs in real cloud environments.

---

## ✅ Result

* Exposed Nginx via ClusterIP and NodePort
* Installed ingress-nginx controller
* Created and validated Ingress routing by hostname (`nginx.example.com`)
* Verified accessibility through curl tests

---

## ✅ Conclusion

This lab provided hands-on practice with Kubernetes networking exposure patterns, from internal-only services to external access through NodePort and Ingress. These concepts map directly to production deployment workflows and OpenShift Route-based access patterns.
