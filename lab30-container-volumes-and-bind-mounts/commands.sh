#!/bin/bash
# Lab 30: Container Volumes and Bind Mounts
# Commands Executed During Lab (sequential, no explanations)

sudo dnf install podman
sudo yum install -y podman

podman --version

podman volume create mydata_volume

podman volume ls

podman run -d --name volume_test -v mydata_volume:/data docker.io/library/alpine sleep infinity

podman exec volume_test ls /data

podman exec volume_test sh -c "echo 'Persistent Data' > /data/testfile"

podman stop volume_test
podman rm volume_test

podman run --name new_test -v mydata_volume:/data docker.io/library/alpine cat /data/testfile

mkdir ~/container_data
echo "Host file content" > ~/container_data/hostfile.txt
cat ~/container_data/hostfile.txt

podman run -it --rm -v ~/container_data:/container_data:Z docker.io/library/alpine cat /container_data/hostfile.txt

ls -Z ~/container_data/hostfile.txt

sudo mkdir /restricted_data
sudo chmod 700 /restricted_data
sudo chown root:root /restricted_data

sudo ls -ldZ /restricted_data

podman run -it --rm -v /restricted_data:/data docker.io/library/alpine touch /data/testfile

sudo chmod 755 /restricted_data
sudo chcon -t container_file_t /restricted_data

podman run -it --rm -v /restricted_data:/data:Z docker.io/library/alpine touch /data/testfile

sudo ls -lZ /restricted_data

podman run -d --name persist_test -v mydata_volume:/data -v ~/container_data:/container_data:Z docker.io/library/alpine sleep infinity

podman exec persist_test sh -c "echo 'Named Volume Data' >> /data/named.txt"
podman exec persist_test sh -c "echo 'Bind Mount Data' >> /container_data/bind.txt"

podman stop persist_test
podman rm persist_test

podman run --rm -v mydata_volume:/data docker.io/library/alpine cat /data/named.txt

cat ~/container_data/bind.txt

getenforce

podman volume rm mydata_volume

podman rm -f $(podman ps -aq)

rm -rf ~/container_data

sudo rm -rf /restricted_data
