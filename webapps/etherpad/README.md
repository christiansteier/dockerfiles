# Alpine Docker image for Etherpad

Small Etherpad-Lite image based on Alpine with [s6-overlay](https://github.com/just-containers/s6-overlay) and some additional modules for use with an external DB.

 [![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

# Installed modules #

- ep_adminpads 
- ep_font_color
- ep_font_size
- ep_fullscreen
- ep_headings2
- ep_historicalsearch
- ep_horizontal_line
- ep_markdown
- ep_markdownify
- ep_offline_edit
- ep_page_view
- ep_spellcheck
- ep_tables2
- ep_timesliderdiff

## Environment variables

- **ETHERPAD_TITLE** : Etherpad application name (appears in the Window title) *(default: "Etherpad")*
- **ETHERPAD_ADMIN_USER** : Etherpad application username for admin *(default: "admin")*
- **ETHERPAD_ADMIN_PASS** : Etherpad application password fpr admin *(default: "generate random password")*
- **ETHERPAD_APIKEY** : Etherpad application token for API-Authentication *(default: "generate random token at the first start")*

###### Silent Install ######
- **SILENTINSTALL** : yes/no *(default: "yes")*
- **APPDB** :  Database name that Etherpad will use to connect with the database *(default: "etherpad")*
- **APPDBUSER** : Database user that Etherpad will use to connect with the database *(default: "etherpad")*
- **APPDBPASS** : Database password that Etherpad will use to connect with the database *(default: "generate random password")*
- **MYSQL_HOST** : Hostname for MariaDB server *(default: "mariadb")*
- **MYSQL_ROOT_PASSWORD** : Database password for MYSQL_ROOT *(no defaults)*

## Build

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/web/etherpad && make
```
