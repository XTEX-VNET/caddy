FROM docker.io/library/golang:alpine AS builder

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
WORKDIR /build
RUN xcaddy build \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/ueffel/caddy-brotli \
    --with github.com/caddyserver/replace-response \
    --with github.com/shift72/caddy-geo-ip \
    --with github.com/mholt/caddy-l4 

FROM docker.io/library/alpine
COPY --from=builder /build/caddy /usr/bin/caddy
WORKDIR /
ENTRYPOINT [ "/usr/bin/caddy", "run" ]
