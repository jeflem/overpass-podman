#!/bin/bash

timedatectl set-timezone Europe/Berlin

chmod a+rwX /opt
chmod -R a+rwX /opt/osm_db

# populate db if no db is available
cd /home/osm_user
if ! test -f /opt/osm_db/nodes.bin; then
    echo "No db found. Populating db..."
    runuser -l osm_user -c 'wget -O planet.osm.pbf "`cat /opt/osm_db/planet_url`"'
    runuser -l osm_user -c 'osmconvert planet.osm.pbf | /usr/local/bin/update_database --db-dir=/opt/osm_db --meta'
    runuser -l osm_user -c 'cp -r /home/osm_user/osm-3s/rules /opt/osm_db/rules'
    rm planet.osm.pbf
fi
