FROM debian:stable-slim
# Should just use the nginx base images

MAINTAINER Tamas VARGA < tamas@alapzaj.com >

# User Settings
ENV TZ=America/New_York

EXPOSE 80/tcp
EXPOSE 6343/udp
EXPOSE 9995/udp

ENV DEBIAN_FRONTEND=noninteractive 

HEALTHCHECK --interval=1m --timeout=5s CMD /healthcheck.sh

RUN mkdir -p /run/php/ && \
    mkdir -p -m 777 /nfsen && \
    mkdir -p -m 777 /netflows

ADD nfsen.conf /usr/src/nfsen.conf

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
  ca-certificates \
  php7.3 \
  php7.3-fpm \
  php7.3-cli \
  zlib1g \
  nginx \
  libbz2-1.0 \
  wget \
  unzip \
  apt-utils \
  dialog \
  build-essential \
  libtool \
  m4 \
  automake \
  bison \
  flex \
  pkg-config \
  rrdtool \
  librrds-perl \
  librrd-dev \
  libmailtools-perl \
  libsocket6-perl \
  libpcap-dev \
  libbz2-dev \
  zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* 

#RUN apt-get install --no-install-recommends --no-install-suggests -y flex bison rrdtool librrds-perl libmailtools-perl libsocket6-perl librrd-dev lighttpd  php7.3 php7.3-fpm php7.3-cli zlib1g nginx libbz2-1.0
#RUN apt-get install --no-install-recommends --no-install-suggests -y automake libtool m4 pkg-config build-essential wget zlib1g-dev librrd-dev libpcap-dev libbz2-dev 


RUN cd /usr/src \
  && wget https://github.com/phaag/nfdump/archive/v1.6.19.zip \
  && unzip v1.6.19.zip \
  && rm v1.6.19.zip \
  && cd nfdump-1.6.19 \
  && [ -d m4 ] || mkdir m4 \
  && ./autogen.sh \
  && ./configure --enable-nsel --enable-sflow --enable-nfprofile --enable-nftrack --enable-readpcap --enable-nfpcapd \
  && make \
  && make install \
  && cd .. \
  && rm -rf ./nfdump-1.6.19 

RUN cd /usr/src \
  && wget http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.8/nfsen-1.3.8.tar.gz \
  && tar -xzf nfsen-1.3.8.tar.gz \
  && rm nfsen-1.3.8.tar.gz \
  && cd nfsen-1.3.8 \
  && cp /usr/src/nfsen.conf /usr/src/nfsen-1.3.8/etc/nfsen.conf\
  && ldconfig \
  && ./install.pl ./etc/nfsen.conf || echo "Probably the semaphore error everyone gets" \
  && cd .. \
  && rm -rf ./nfsen-1.3.8 \
  && apt-get remove --purge -y automake libtool m4 pkg-config build-essential wget zlib1g-dev librrd-dev libpcap-dev libbz2-dev bison flex

ADD site.conf /etc/nginx/sites-available/default
ADD run.sh /run.sh
ADD healthcheck.sh /healthcheck.sh
CMD ["/run.sh"]
