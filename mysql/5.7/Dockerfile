ARG VARIANT=5.7.35
FROM mysql:${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive
ENV XTRABACKUP_MAJOR=24
ENV XTRABACKUP_URL=https://repo.percona.com/apt/pool/main/p/percona-release/percona-release_1.0-27.generic_all.deb

RUN set -eux \
    ; echo 'Acquire::AllowInsecureRepositories "true";' >> /etc/apt/apt.conf.d/insecure-repo \
    ; echo 'Acquire::AllowDowngradeToInsecureRepositories "true";' >> /etc/apt/apt.conf.d/insecure-repo \
    ; apt update -y && apt install wget lsb-release curl -y

RUN set -eux \
    ;curl -sL $XTRABACKUP_URL > /tmp/all.deb && \
    apt install -y /tmp/all.deb && rm -rf /tmp/all.deb && \
    apt update -y && \
    apt install percona-xtrabackup-dbg-${XTRABACKUP_MAJOR} qpress -y