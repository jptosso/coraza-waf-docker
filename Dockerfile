FROM golang:1.16.6

# TODO
# For future versions, Coraza should be downloaded as a pre-compiled binary and we should use busybox

# Copy files
RUN mkdir -p /coraza/crs
COPY install-libinjection.sh .
COPY Caddyfile /coraza/
COPY entrypoint.sh /bin/
COPY install-crs.sh .
COPY install-caddy.sh .

# Setup libinjection
RUN apt-get update && apt install -y \
    libpcre++-dev \
    && rm -rf /var/lib/apt/lists/*
RUN ./install-libinjection.sh

# OWASP CRS
RUN ./install-crs.sh

# Setup Caddy
RUN ./install-caddy.sh

# We are removing the workdir so we switch to another one
# We are also cleaning old files
WORKDIR /bin
RUN rm -rf /go
RUN apt-get clean autoclean &&\
    apt-get autoremove --yes &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT [ "/bin/entrypoint.sh"]