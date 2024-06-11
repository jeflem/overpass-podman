#!/bin/bash

IMAGE_NAME=overpass
CONTAINER_NAME=overpass
PORT=8000

echo "Creating container..."

podman create \
-p $PORT:80 \
--cap-add SYS_ADMIN \
--mount=type=bind,source=runtime/osm_db,destination=/opt/osm_db \
-m=80g \
--name=$CONTAINER_NAME \
$IMAGE_NAME

mkdir -p ~/.config/systemd/user
podman generate systemd --restart-policy=always --name $CONTAINER_NAME > ~/.config/systemd/user/container-$CONTAINER_NAME.service
systemctl --user daemon-reload
systemctl --user enable container-$CONTAINER_NAME.service

echo "Starting container..."
systemctl --user start container-$CONTAINER_NAME.service
