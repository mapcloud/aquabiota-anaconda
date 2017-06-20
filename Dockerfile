# -*- mode: ruby -*-
# vi: set ft=ruby :

FROM aquabiota/phusion-base:16.04

LABEL maintainer "Aquabiota Solutions AB <mapcloud@aquabiota.se>"


RUN apt-get update --fix-missing && \
    apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends \
    # from https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    # Solving installation-of-package-devtools-had-non-zero-exit-status when R-Kernel is used
    libssl-dev libcurl4-gnutls-dev libxml2-dev

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

CMD ["/sbin/my_init"]

# # Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Added a health check

# HEALTHCHECK CMD curl --fail http://localhost:2480/ || exit 1
## Adding orientdb daemon
RUN mkdir /etc/service/aquabiota
ADD aquabiota.sh /etc/service/aquabiota/run
