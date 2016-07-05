#Docker Alpine MySQL (x86_64 and armhf)

MariaDB/MySQL based on Alpine

## Quickstart
```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/alpine-db/mariadb && quickstart
````
## Docker image usage

``` shell
$ docker run -d --name mariadb \
             -p 127.0.0.1:3306:3306 \
             -e DBUSER="dbadmin" \
             -e DBPASS="PASSWORD" \
              maxder/alpine-mariadb:x86_64
```

If you build on a ARM platform like Raspberry PI
```
docker run [docker-options] maxder/alpine-mariadb:armhf
```

## Connecting to the Database

To connect to the MariaDB server, you will need to make sure you have a client.
You can install the `mysql-client` on your host machine by running the
following (Debian or Ubuntu):

``` shell
$ sudo apt-get install mariadb-client
```

As part of the startup for MariaDB, the container will generate a random
password for the superuser.  To view the login in run `docker logs
<container_name>` like so:

``` shell
$ docker logs mariadb
MARIADB_USER=dbadmin
MARIADB_PASS=PASSWORD
Starting MariaDB...
140103 20:33:49 mysqld_safe Logging to '/data/mysql.log'.
```

Then you can connect to the MariaDB server from the host with the following
command:

``` shell
$ mysql -u dbadmin --password=PASSWORD --protocol=tcp
```

## Linking with the Database Container

You can link a container to the database container.  You may want to do this to
keep web application processes that need to connect to the database in
a separate container.

To demonstrate this, we can spin up a new container like so:

``` shell
$ docker run -t -i -link mariadb:db debian bash
```

This assumes you're already running the database container with the name
*mariadb*.  The `-link mariadb:db` will give the linked container the alias
*db* inside of the new container.

From the new container you can connect to the database by running the following
commands:

``` shell
$ apt-get install -y mysql-client
$ mysql -u "$DB_ENV_DBUSER" --password="$DB_ENV_DBPASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT"
```

If you ran the *mariadb* container with the flags `-e DBUSER=<user>` and `-e
DBPASS=<pass>`, then the linked container should have these variables available
in its environment.  Since we aliased the database container with the name
*db*, the environment variables from the database container are copied into the
linked container with the prefix `DB_ENV_`.
