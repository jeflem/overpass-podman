#!/bin/bash

IMAGE_NAME=localhost/overpass
CONTAINER_NAME=overpass
PORT=9004

SYSTEMD_PATH=~/.config/containers/systemd
UNIT_FILE=$SYSTEMD_PATH/$CONTAINER_NAME.container
RUNTIME_DIR=$(pwd)/runtime
