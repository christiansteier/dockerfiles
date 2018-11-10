# Alpine Docker image for Etherpad  [![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

Small Etherpad-Lite image based on Alpine with [s6-overlay](https://github.com/just-containers/s6-overlay) for use with an external DB.
.

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
