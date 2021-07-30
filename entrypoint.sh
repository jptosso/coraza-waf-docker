#!/bin/bash
if test -f "/coraza/caddy.json"; then
    /bin/caddy run -adapter json \
        --config /coraza/caddy.json \
        --watch
else
    /bin/caddy run -adapter caddyfile \
        --config /coraza/Caddyfile \
        --watch
fi
