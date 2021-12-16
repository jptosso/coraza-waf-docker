FROM caddy:2.4.6-builder AS builder

COPY install-libinjection.sh .
RUN apk add gcc libc-dev bash pcre-dev
RUN mkdir -p /usr/local/include /usr/local/lib
RUN sh install-libinjection.sh
RUN ldconfig /usr/local/lib

#
# CADDY SETUP
#
WORKDIR /go/src/github.com/jptosso
RUN git clone --depth 1 https://github.com/jptosso/coraza-caddy && \    
    cd coraza-caddy && \
    git checkout 51db837 && \
    go get ./...
WORKDIR /go/src/github.com/jptosso/coraza-caddy
RUN  export CGO_LDFLAGS="-L/usr/local/lib -lpcre" &&\
    export CGO_CFLAGS="-I/usr/local/include" &&\
    export CGO_ENABLED=1  &&\
    sed -i 's/\/\/ _ "github.com/_ "github.com/g' caddy/main.go && \
    go get -u github.com/jptosso/coraza-waf/v2@1166b63 && \
    go get -u github.com/jptosso/coraza-pcre@1bea0f0 && \
    go get -u github.com/jptosso/coraza-libinjection@f462893
RUN go build caddy/main.go &&\
    mv main /usr/bin/caddy
#
# END CADDY SETUP
#

FROM caddy:2.4.6

COPY --from=builder /usr/bin/caddy  /usr/bin/caddy
COPY --from=builder /usr/local/lib/libinjection.so /usr/local/lib/
RUN apk add pcre
# Copy files
COPY ./Caddyfile /coraza/

# Let's do some cleaning
WORKDIR /srv
RUN rm -rf /tmp/*
CMD ["/usr/bin/caddy", "run", "--config", "/coraza/Caddyfile", "--adapter", "caddyfile", "--watch"]