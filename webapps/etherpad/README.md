# Alpine Docker image for Etherpad

Build a small AlpineLinux Docker image based on [LinuxServer.io](https://github.com/linuxserver).

# Installed modules #

<ul>
<li>ep_adminpads</li>
<li>ep_headings2</li>
<li>ep_page_view</li>
<li>ep_sociallinks</li>
<li>ep_spellcheck</li>
<li>ep_historicalsearch</li>
<li>ep_horizontal_line</li>
<li>ep_stop_writing</li>
<li>ep_timesliderdiff</li>
<li>ep_offline_edit</li>
<li>ep_delete_empty_pads</li>
<li>ep_markdownify</li>
<li>ep_markdown</li>
</ul>

## Environment variables

- **ETHERPAD_TITLE** : Name your instance *(default: "Etherpad")*
- **ETHERPAD_ADMIN_USER** : *(default: "admin")*
- **ETHERPAD_ADMIN_PASS** : *(default: "generate random password")*
- **ETHERPAD_APIKEY** : Token for API-Authentication *(default: "generate random token at the first start")*

###### Silent Install ######
- **SILENTINSTALL** : yes/no *(default: "yes")*
- **APPDB** : *(default: "etherpad")*
- **DBHOST** : *(default: "db")*
- **DBUSER** : *(default: "etherpad")*
- **DBPASS** : *(default: "generate random password")*
- **MYSQL_ROOT_PASSWORD** : *(Root pass from MySQL instanz)*

## Usage with MySQL

On x86 64-bit server:
```dockerfile
docker run -d \
	--name etherpad_db \
	-e MYSQL_ROOT_PASSWORD=<YOUR_ROOT_PASSWORD> \
	-v /srv/docker/etherpad/db/conf:/config \
	-v /srv/docker/etherpad/lib:/var/lib/mysql \
	linuxserver/mariadb

docker run -d \
	--name etherpad \
	-p 9001:9001 \
	-e MYSQL_ROOT_PASSWORD=<YOUR_ROOT_PASSWORD> \
	-v /srv/docker/etherpad:/config/etherpad \
	--link etherpad_db:db \
	maxder/alpine-etherpad.x86_64
```

## Build

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/web/etherpad && make 
