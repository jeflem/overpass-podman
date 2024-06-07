#!/bin/bash

IMAGE_NAME=overpass

podman build --tag=$IMAGE_NAME .
