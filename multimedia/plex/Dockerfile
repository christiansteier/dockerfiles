FROM plexinc/pms-docker 
LABEL maintainer="Christian-Maximilian Steier"

RUN apt update && \
    apt install -y s3fs && \
    apt clean
COPY root/ /
