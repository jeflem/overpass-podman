#!/bin/bash

timedatectl set-timezone Europe/Berlin

chmod -R a+rw /opt/osm_db

# populate db if no db is available
cd /home/osm_user
if ! test -f /opt/osm_db/nodes.bin; then
    echo "No db found. Populating db..."
    runuser -l  osm_user -c 'wget --no-check-certificate https://download.geofabrik.de/europe/luxembourg-latest.osm.bz2'
    runuser -l  osm_user -c 'osm-3s/bin/init_osm3s.sh luxembourg-latest.osm.bz2 /opt/osm_db osm-3s --meta'
fi



