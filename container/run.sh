#!/bin/bash

source ./config.sh

mkdir -p $SYSTEMD_PATH
touch $UNIT_FILE
echo "[Unit]" >> $UNIT_FILE
echo "Description=$CONTAINER_NAME container" >> $UNIT_FILE
echo "" >> $UNIT_FILE
echo "[Container]" >> $UNIT_FILE
echo "Image=$IMAGE_NAME" >> $UNIT_FILE
echo "ContainerName=$CONTAINER_NAME" >> $UNIT_FILE
echo "PublishPort=$PORT:80" >> $UNIT_FILE
echo "Environment=\"TZ=$TIME_ZONE\"" >> $UNIT_FILE
echo "Mount=type=bind,source=$RUNTIME_DIR/osm_db,destination=/opt/osm_db" >> $UNIT_FILE
#echo "Memory=80g" >> $UNIT_FILE
echo "AddCapability=SYS_ADMIN" >> $UNIT_FILE
echo "" >> $UNIT_FILE
echo "[Install]" >> $UNIT_FILE
echo "WantedBy=default.target" >> $UNIT_FILE

ln -s $UNIT_FILE $CONTAINER_NAME.container

#/usr/lib/systemd/user-generators/podman-user-generator --dryrun

systemctl --user daemon-reload
systemctl --user start $CONTAINER_NAME.service
