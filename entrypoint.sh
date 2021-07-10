#!/bin/bash
/bin/caddy run -adapter caddyfile \
    --config /coraza/Caddyfile \
    --watch