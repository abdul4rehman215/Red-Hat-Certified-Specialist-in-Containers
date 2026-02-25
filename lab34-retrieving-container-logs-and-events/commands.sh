#!/bin/bash
# Lab 34: Retrieving Container Logs and Events
# Commands Executed During Lab (sequential, no explanations)

podman --version

podman pull docker.io/library/nginx:alpine

podman run -d --name nginx-container docker.io/library/nginx:alpine

podman logs nginx-container

podman logs --follow nginx-container

podman logs --since 5m nginx-container

podman logs --since 2023-01-01T00:00:00 --until 2023-01-01T12:00:00 nginx-container

podman run -d --name json-logger --log-driver json-file docker.io/library/nginx:alpine

podman inspect --format '{{.HostConfig.LogConfig.Path}}' json-logger

podman inspect --format '{{.LogPath}}' json-logger

podman run -d --name journald-logger --log-driver journald docker.io/library/nginx:alpine

journalctl CONTAINER_NAME=journald-logger --no-pager | tail -n 12

podman events --format "{{.Time}} {{.Type}} {{.Status}}"

podman run -d --name event-test docker.io/library/nginx:alpine

podman events --filter event=start --since 1m --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"

podman events --filter container=event-test --since 5m --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"

podman events --filter event=die --since 1h --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"

podman run --name failing-container docker.io/library/alpine /bin/nonexistent-command

podman logs failing-container

podman events --filter container=failing-container --since 1m --format "{{.Time}} {{.Type}} {{.Name}} {{.Status}}"

podman run -d --name debug-container --log-level=debug docker.io/library/nginx:alpine

podman logs debug-container | head -n 15

podman rm -f nginx-container json-logger journald-logger event-test failing-container debug-container
