# Build stage
FROM erlang:25.1-alpine as builder

RUN apk add --no-cache git make curl

RUN mkdir /buildroot
WORKDIR /buildroot

COPY erl_fenix_auto erl_fenix_auto

WORKDIR erl_fenix_auto
RUN rebar3 as prod release


# Release stage
FROM alpine
#FROM erlang:25.1-alpine

# Install some libs
RUN apk add --no-cache openssl && \
    apk add --no-cache ncurses-libs && \
    apk add --no-cache libstdc++

# Install the released application
COPY --from=builder /buildroot/erl_fenix_auto/_build/prod/rel /opt

# Expose relevant ports
EXPOSE 8080

# Maybe ENTRYPOINT?
CMD ["/opt/erl_fenix_auto/bin/erl_fenix_auto", "foreground"]
# CMD ["ls", "/tcp_echo/tcp_echo"]