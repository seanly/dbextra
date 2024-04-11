ARG VERSION=6.2.6
FROM redis:${VERSION}-bookworm

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

ENV TZ=Asia/Shanghai
RUN set -eux;\
    apt update && \
    apt install -y --no-install-recommends \
        apt-transport-https ca-certificates\
        procps curl wget xz-utils\
        file git vim net-tools iputils-ping telnet zip \
        unzip wget tzdata fontconfig && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime &&\
    echo $TZ > /etc/timezone && \
    apt install -y --no-install-recommends tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Add locales
RUN set -o errexit -o nounset \
  && apt update -y && apt install -y locales \
  && locale-gen en_GB.UTF-8 \
  && echo 'LANG=en_GB.UTF-8' > /etc/locale.conf \
  && echo 'LC_ALL=en_GB.UTF-8' >> /etc/locale.conf \
  && echo 'LANGUAGE=en_GB:en' >> /etc/locale.conf 

ENV LANG=en_GB.UTF-8
ENV LANGUAGE=en_GB.UTF-8
ENV LC_ALL=en_GB.UTF-8

COPY ./docker-entrypoint.sh /

CMD ["/docker-entrypoint.sh"]