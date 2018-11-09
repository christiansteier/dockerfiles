# Alpine Docker image for Etherpad

Build a small AlpineLinux Docker image based on [LinuxServer.io](https://github.com/linuxserver).

# Installed modules #

- ep_adminpads
- ep_headings2
- ep_page_view
- ep_sociallinks
- ep_spellcheck
- ep_historicalsearch
- ep_horizontal_line
- ep_stop_writing
- ep_timesliderdiff
- ep_offline_edit
- ep_delete_empty_pads
- ep_markdownify
- ep_markdown

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

## Build

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/web/etherpad && make 
