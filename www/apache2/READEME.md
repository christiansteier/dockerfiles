# Apache Docker image

Small Apine Docker image.

## Build automagical for x86 64-bit or ARM

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git --depth 1
cd dockerfiles/www/apache2 && sudo make
```

## Usage

```dockerfile
FROM cms0/httpd
RUN ...
```
