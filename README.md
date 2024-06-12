# Overpass API Podman image

This repo contains a [Podman](https://podman.io/) image for running an [Overpass API](https://overpass-api.de/) instance for querying the [OpenStreetMap](https://www.openstreetmap.org) data base.

Code and configuration provided here are not optimized for performance, but for simplicity and for getting things running without too much fiddling. The setup uses HTTP (not HTTPS) and is intended to be run behind a reverse proxy. For public instances with high load further tweaking would be necessary.

Data base gets populated automatically (whole planet or some subset) and will be updated hourly. Area queries are supported.

Tested on Debian 12.

Work is based on [OSM Wiki's Overpass API Installation Guide](https://wiki.openstreetmap.org/wiki/Overpass_API/Installation) and [ZeLonewolf's Overpass Installation Guide](https://wiki.openstreetmap.org/wiki/User:ZeLonewolf/Overpass_Installation_Guide).

## Build the image
Clone the repo. Then
```
cd overpass-podman/image
./build.sh
```
## Running a container
There are shell scripts `run.sh`, `remove.sh`, `shell.sh` in `overpass-podman/container` to create and start a container, to stop and remove a container, and to run a root shell inside the container.

Before you start a container some configuration is required.
### Port
In `overpass-podman/container/run.sh` edit the `PORT=` line to set the port the Overpass API is listening on.
### Memory limits
In `overpass-podman/container/run.sh` edit the `-m=` line to set the maximum amount of memory the container is allowed to use.
### Data source
At first start of the container the data base is created automatically if it does not exist already. The data base is stored in `overpass-podman/container/runtime/osm_db` and thus even persists if the container gets removed.

In `overpass-podman/container/runtime/osm_db` rename files `planet_url.template` and `replicate_id.template` to `planet_url` and `replicate_id`. Set the URL in `planet_url` to some `*.osm.pbf` file (no leading/trailing spaces, no line breaks!). Then have a look at [OSM replication data](https://planet.openstreetmap.org/replication/hour) and find the newest replication ID older than your `*.osm.pbf` file. Write this replication ID to the `replication_id` file (again, no spaces, no line breaks).
### Starting the container
After setting above configuration options create and start the container:
```
cd overpass-podman/container
./run.sh
```
To see what's happening run a shell inside the container:
```
./shell.sh
```
There, type `journalctl` to see the logs. With `journalctl -f` output will be updated automatically. To leave the shell type `exit`.

Populating the data base may take many hours. In a second step area information is created, which again may take several hours.
### API keys
The default configuration is that querying the Overpass API requires an API key (default keys are `apikey1` and `apikey2`). API keys are configured in `/etc/nginx/sites-available/default`. In the container's shell run `nano /etc/nginx/sites-available/default` to edit the file. Content starts with
```
map $http_x_api_key $valid_key {
        default 0;
        "apikey1" 1;
        "apikey2" 1;
}
```
You may set as many API keys as you need (for different users or apps). To disable API keys at all, replace `default 0` by `default 1`.

Good API keys may be created with
```
openssl rand -hex 16
```
## Test
To see whether everything works as expected, run
```
curl -H "X-API-Key: YOUR_API_KEY" \
     -g "https://YOUR_DOMAIN/overpass/api/interpreter?data=area[name=Ettelbruck];node(area)[highway=bus_stop];out;"
```
on some machine connected to your server.