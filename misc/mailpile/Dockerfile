FROM alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG RELEASE=1.0
RUN \
    # Cleanup based on https://gist.github.com/jumanjiman/f9d3db977846c163df12 \
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo -e "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
    echo "[i] Remove interactive login shell" && \
    sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    echo "[i] Remove broken symlinks." && \
    find $sysdirs -xdev -type l -exec test ! -e {} \; -delete && \
    \
    apk -U --no-cache add \
	gcc\
        git \
        zlib \
        gnupg1 \
        py2-pip \
	libressl \
        libressl-dev \
	musl-dev \
        py-jinja2 \
	libffi-dev \
        py-libxml2 \
        py-libxslt \
        py-lxml \
        py-pbr \
        py-pillow \
	python-dev \
        ca-certificates && \
    \
    # Get Mailpile from github
    git clone https://github.com/mailpile/Mailpile.git --branch release/$RELEASE --single-branch --depth=1 && \
    cd /Mailpile && \
    # Install missing requirements
    pip install -r requirements.txt && \
    # Initial Mailpile setup && \
    ./mp setup && \
    # Locales
    apk --no-cache add gettext && \
    #msgfmt -c shared-data/locale/de/LC_MESSAGES/mailpile.po -o shared-data/locale/de/LC_MESSAGES/mailpile.mo && \
    msgfmt -c shared-data/locale/es_ES/LC_MESSAGES/mailpile.po -o shared-data/locale/es_ES/LC_MESSAGES/mailpile.mo && \
    apk del --purge git gettext libressl-dev python-dev musl-dev libffi-dev && \
    rm -rf \
	/var/cache/apk/* \
	/etc/ssh/ssh_host_* \
	/var/cache/ldconfig/aux-cache \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \
	/var/cache/man/* \
	/tmp/* \
	/etc/fstab

WORKDIR /Mailpile
CMD ./mp --www=0.0.0.0:33411 --wait

EXPOSE 33411
VOLUME /root/.local/share/Mailpile
VOLUME /root/.gnupg
