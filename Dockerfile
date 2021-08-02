FROM golang:1.16.6 AS builder

COPY install-libinjection.sh .
COPY install-caddy.sh .
RUN sh install-libinjection.sh
RUN apt update && apt install -y libpcre++-dev
RUN sh install-caddy.sh

# Setup CRS
COPY install-crs.sh .

ARG CRS_USE=false
ARG CRS_VERSION
ARG CRS_EXCLUDE_WORDPRESS=false
RUN mkdir -p /coraza/crs && ./install-crs.sh

FROM caddy:2.4.3

COPY --from=builder /usr/bin/caddy  /usr/bin/caddy
COPY --from=builder /usr/local/lib/libinjection.so /usr/local/lib/
COPY --from=builder /coraza/crs /coraza/

WORKDIR /tmp
# Copy files
RUN mkdir -p /coraza/crs
COPY ./Caddyfile /coraza/


# We are removing the workdir so we switch to another one
# We are also cleaning old files
WORKDIR /usr/bin
RUN rm -rf /tmp/*

CMD ["caddy", "run", "--config", "/coraza/Caddyfile", "--adapter", "caddyfile"]