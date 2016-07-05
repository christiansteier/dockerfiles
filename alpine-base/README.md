# Alpine Docker image (x86_64 and amrhf)

Build a small AlpineLinux Docker image based on [gliderlabs](http://gliderlabs.viewdocs.io/docker-alpine) with bash, cron and s6 installed. 

## Build automagical

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/alpine-base && make
```

To build on debian based system you need build-essential
```
apt-get install build-essential
```

## Usage

On x86 64-bit server:
```dockerfile
FROM maxder/alpine-base:x86_64
RUN ...
```

On ARM server like rpi:
```dockerfile
FROM maxder/alpine-base:armhf
RUN ...
```

## Build manuel

Here are steps to rebuild the images on a rpi:
```
git clone https://github.com/gliderlabs/docker-alpine.git docker-alpine-gliderlabs
cd docker-alpine-gliderlabs/

# the "builder" images has to be FROM an rpi based alpine
sed -i "/FROM/ s:.*:FROM hypriot/rpi-alpine-scratch:" builder/Dockerfile
docker build -t alpine-builder builder

# build library alpine
docker run --name alpine-build-edge alpine-builder -s -t UTC -r edge -m http://dl-4.alpinelinux.org/alpine > ./versions/library-edge/rootfs.tar.gz
docker build -t alpine:latest versions/library-edge

# build gliderlabs/alpine
docker rm alpine-build-edge
docker run --name alpine-build-edge alpine-builder -s -c -t UTC -r edge -m http://alpine.gliderlabs.com/alpine > ./versions/gliderlabs-edge/rootfs.tar.gz
docker  build -t gliderlabs/alpine:latest versions/gliderlabs-edge
```
