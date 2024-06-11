#!/bin/bash

timedatectl set-timezone Europe/Berlin

chmod -R a+rw /opt/osm_db

# populate db if no db is available
cd /home/osm_user
if ! test -f /opt/osm_db/nodes.bin; then
    echo "No db found. Populating db..."
    runuser -l  osm_user -c 'wget -O planet.osm.bz2 "`cat /opt/osm_db/planet_url`"'
    runuser -l  osm_user -c 'osm-3s/bin/init_osm3s.sh planet.osm.bz2 /opt/osm_db osm-3s --meta'
    runuser -l  osm_user -c 'cp -r /home/osm_user/osm-3s/rules /opt/osm_db/rules'
fi
