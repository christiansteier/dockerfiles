FROM plexinc/pms-docker 
LABEL maintainer="Christian-Maximilian Steier"

RUN apt update && \
    apt install -y s3fs && \
    apt clean && \
    rm -rf \
      /etc/machine-id \
      /var/lib/dbus/machine-id \
      /var/lib/apt/lists/* \
      /var/log/alternatives.log \
      /var/log/apt/history.log \
      /var/log/apt/term.log \
      /var/log/dpkg.log \
      /var/cache/ldconfig/aux-cache \
      /usr/share/doc \
      /usr/share/man/ \
      /usr/share/info/* \
      /var/cache/man/* \
      /tmp/*
COPY root/ /
