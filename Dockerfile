FROM golang:1.16.5

RUN mkdir /coraza
RUN apt-get update && apt install -y libpcre++-dev
COPY install-libinjection.sh .
COPY Caddyfile /coraza/
RUN ./install-libinjection.sh

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN CGO_ENABLED=1 xcaddy build --with github.com/jptosso/coraza-caddy
RUN mv caddy /bin/
RUN setcap 'cap_net_bind_service=+ep' /bin/caddy

COPY entrypoint.sh /bin/
ENTRYPOINT [ "/bin/entrypoint.sh"]