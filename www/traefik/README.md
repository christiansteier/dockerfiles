# Alpine Docker image for traefik
Treafik based on Alpine. Designed for quick tests with TLS.

## Usage

On x86 64-bit server:
```dockerfile
docker create \
	--name traefik \
	-p 80:80 \
	-p 443:443 \
	-e PUID=<UID> -e PGID=<GID> \
	-v /srv/docker/traefik:/config/traefik \
	maxder/alpine-traefik.x86_64
```

On ARM server like rpi:
```dockerfile
docker create \
        --name traefik \
        -p 80:80 \
        -p 443:443 \
        -e PUID=<UID> -e PGID=<GID> \
        -v /srv/docker/traefik:/config/traefik \
        maxder/alpine-traefik.armhf
```

With Makefile:
```
make run
```

## Build

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/www/traefik && make 
```

