FROM mayanedms/mayanedms
LABEL maintainer="Christian-Maximilian Steier"

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    apt update && \
    apt install -y s3fs tesseract-ocr-deu && \
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
