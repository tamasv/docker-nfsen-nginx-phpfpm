docker run -dit --name docker-nfsen-nginx-phpfpm \
 -p 8080:80 \
 -p 9995:9995/udp \
 -v /opt/netflows:/netflows \
 nfsen-nginx-phpfpm


# -v /opt/nfsen/profiles-stat:/nfsen/profiles-stat \
# -v /opt/nfsen/profiles-data:/nfsen/profiles-data \
# -v /opt/netflows:/netflows \
# nfsen-nginx-phpfpm
