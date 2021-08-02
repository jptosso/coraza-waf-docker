#!/bin/bash

git clone --depth 1 --branch v1.0.0-beta.1 https://github.com/jptosso/coraza-caddy
cd coraza-caddy
CGO_ENABLED=1 go build builder/main.go
mv main /usr/bin/caddy
setcap 'cap_net_bind_service=+ep' /usr/bin/caddy