# 💬 Interview Q&A — Lab 30: Container Volumes and Bind Mounts

---

## 1) What is the difference between a named volume and a bind mount?
- **Named volume**: Managed by Podman. Stored in Podman’s storage location and persists independently of containers.
- **Bind mount**: Maps a specific host directory/file into the container. Host permissions and SELinux context directly affect container access.

---

## 2) Why would you use a named volume instead of a bind mount?
Named volumes are easier to manage and are ideal for persistent application data because:
- they are not tied to a specific host path
- Podman manages lifecycle and storage location
- they are commonly used for databases and stateful services

---

## 3) How did you create a named volume in this lab?
Using:
```bash id="d2j4n2"
podman volume create mydata_volume
````

---

## 4) How did you confirm the volume exists?

Using:

```bash id="k4f1m6"
podman volume ls
```

It listed `mydata_volume` under the `local` driver.

---

## 5) How did you mount the named volume into a container?

Using the `-v` flag:

```bash id="xg7v0y"
podman run -d --name volume_test -v mydata_volume:/data alpine sleep infinity
```

---

## 6) How did you prove the volume data persisted across container removal?

I wrote a file to `/data/testfile`, removed the container, started a new container using the same volume, and read the file back:

* output confirmed: `Persistent Data`

---

## 7) What is a bind mount and when is it useful?

A bind mount maps host files/directories into the container. It’s useful when you want:

* container to use host config files
* logs written directly to host
* live code editing during development

---

## 8) What does the `:Z` option do for bind mounts on SELinux systems?

`:Z` tells SELinux to relabel the host content so containers are allowed to access it. It applies a container-friendly SELinux type such as `container_file_t`.

---

## 9) How did you verify SELinux relabeling happened?

Using:

```bash id="62x13r"
ls -Z ~/container_data/hostfile.txt
```

The output showed `container_file_t`.

---

## 10) Why did writing to `/restricted_data` fail at first?

Because the directory was:

* owned by root
* permission `700`
  So the container process lacked required permissions to create files there.

---

## 11) How did you fix container write access to `/restricted_data`?

I:

* changed permissions to allow access:

  * `sudo chmod 755 /restricted_data`
* changed SELinux type:

  * `sudo chcon -t container_file_t /restricted_data`
* mounted with `:Z`
  Then file creation succeeded.

---

## 12) Why is SELinux relevant for container storage?

SELinux enforces mandatory access controls. Even if filesystem permissions allow access, SELinux labels can still block container processes unless correctly configured (e.g., `:Z` for bind mounts).

---

## 13) What did the combined persistence test demonstrate?

It demonstrated:

* named volume data persists in Podman-managed storage (`/data`)
* bind mount data persists on the host (`~/container_data`)
  both remain after stopping/removing the container.

---

## 14) How can you check whether SELinux is enforcing?

Using:

```bash id="adwht2"
getenforce
```

In this lab it returned `Enforcing`.

---

## 15) What’s the key takeaway from this lab?

Containers need storage patterns that balance persistence and security:

* named volumes are best for long-lived app data
* bind mounts are best for host-controlled data/config
  On SELinux systems, correct labeling (`:Z`) + proper permissions are essential to avoid “permission denied” errors while staying secure.
