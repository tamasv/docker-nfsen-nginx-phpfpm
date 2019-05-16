FROM ubuntu:latest
MAINTAINER Tamas VARGA < tamas@alapzaj.com >

ENV TZ=Europe/Luxembourg
HEALTHCHECK --interval=1m --timeout=5s CMD /healthcheck.sh

RUN mkdir -p /build
ADD nfsen.conf /build/nfsen.conf

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --no-install-suggests -y install flex bison rrdtool librrds-perl libmailtools-perl libsocket6-perl librrd-dev lighttpd  php7.2 php7.2-fpm php7.2-cli zlib1g nginx libbz2-1.0 && \
    mkdir -p /run/php/ && \
    apt-get install -y automake libtool m4 pkg-config build-essential wget zlib1g-dev librrd-dev libpcap-dev libbz2-dev && \
    cd /build && \
    wget https://github.com/phaag/nfdump/archive/v1.6.17.tar.gz && \
    tar -xzf v1.6.17.tar.gz && \
    cd nfdump-1.6.17 && \
    ./autogen.sh && \
    ./configure --enable-nsel --enable-sflow --enable-nfprofile --enable-nftrack --enable-compat15 --enable-readpcap --enable-nfpcapd && \
    make && \
    make install && \
    mkdir -p -m 777 /nfsen && \
    mkdir -p -m 777 /netflows && \
    cd /build && \
    wget http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.8/nfsen-1.3.8.tar.gz && \
    tar -xzf nfsen-1.3.8.tar.gz && \
    cd nfsen-1.3.8 && \
    cp /build/nfsen.conf /build/nfsen-1.3.8/etc/nfsen.conf && \
    ldconfig && \
    ./install.pl ./etc/nfsen.conf || echo "" && \
    apt-get remove --purge -y automake libtool m4 pkg-config build-essential wget zlib1g-dev librrd-dev libpcap-dev libbz2-dev && \
    rm -rf /build
WORKDIR /nfsen
ADD site.conf /etc/nginx/sites-available/default
ADD run.sh /run.sh
ADD healthcheck.sh /healthcheck.sh
CMD ["/run.sh"]




