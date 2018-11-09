# Alpine Docker image for LimeSurvey

[LimeSurvey](https://www.limesurvey.org) based on Alpine with [s6-overlay](https://github.com/just-containers/s6-overlay) and [socklog-overlay](https://github.com/just-containers/socklog-overlay) for use with an external Database.

## Environment variables

- **APPDIR** : LimeSurvey application directory *(default: "/var/www/html")*
- **SUBDIR** : LimeSurvey application in a subdirectory *(No defaults)*
- **APPADMIN** : LimeSurvey application username *(default: "admin")*
- **APPADMINPASS** : LimeSurvey application password *(default: "generate random password")*
- **APPADMINEMAIL** : LimeSurvey application email *(default: "admin@lochalhost.local")*

###### Silent Install ######
- **SILENTINSTALL** : yes/no *(default: "no")*
- **APPDB** : Database name that LimeSurvey will use to connect with the database *(default: "etherpad")*
- **APPDBUSER** : Database user that LimeSurvey will use to connect with the database *(default: "limesurvey")*
- **APPDBPASS** : Database password that LimeSurvey will use to connect with the database *(default: "generate random password")*
- **SITENAME** : The official name of the site (appears in the Window title) *(default: "LimeSurvey")*
- **DEFAULTTHEME** : Default theme used for the 'public list' of surveys *(default: "fruity")*
- **MYSQL_HOST** : Hostname for MariaDB server *(default: "mariadb")*
- **MYSQL_ROOT_PASSWORD** : Database password for MYSQL_ROOT *(no defaults)*

## Build

Use make:

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git --depth 1
cd dockerfiles/web/limesurvey && make 
