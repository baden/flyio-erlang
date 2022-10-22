# Build stage 0
FROM erlang:25.1-alpine

RUN apk add --no-cache make

RUN mkdir /buildroot
WORKDIR /buildroot

COPY tcp_echo tcp_echo

WORKDIR tcp_echo
# RUN rebar3 as prod release
RUN make


# Build stage 1
#FROM alpine
FROM erlang:25.1-alpine

# Install some libs
RUN apk add --no-cache openssl && \
    apk add --no-cache ncurses-libs && \
    apk add --no-cache libstdc++

# Install the released application
COPY --from=0 /buildroot/tcp_echo/_rel /opt

# Expose relevant ports
EXPOSE 5555

# Maybe ENTRYPOINT?
CMD ["/opt/tcp_echo/bin/tcp_echo", "foreground"]
# CMD ["ls", "/tcp_echo/tcp_echo"]