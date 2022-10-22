# Build stage 0
FROM hexpm/erlang:25.1.1-debian-bullseye-20220801-slim as builder

#--mount=type=cache,id=apt,sharing=locked,target=/var/cache/apt
RUN --mount=type=cache,id=apt,sharing=locked,target=/var/cache/apt apt-get update -y \
    && apt-get install -y make \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*

# RUN apk add --no-cache make

RUN mkdir /buildroot
WORKDIR /buildroot

COPY tcp_echo tcp_echo

WORKDIR tcp_echo
# RUN rebar3 as prod release
RUN make


# Build stage 1
#FROM alpine
FROM debian:bullseye-20221004-slim
# FROM debian:bullseye-20210902-slim
# FROM hexpm/erlang:25.1.1-debian-bullseye-20220801-slim

# Install some libs
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y libstdc++6 openssl libncurses5 locales bash postgresql-client \
    procps iproute2 net-tools curl jq nano openssl libsodium-dev libsnappy-dev \
    && apt-get clean -y \
    && rm -f /var/lib/apt/lists/*_* \
    && groupadd -g 1000 -r fenix \
    && useradd -u 1000 -r -g fenix -d /fenix -s /bin/bash -c "fenix user" fenix

WORKDIR /fenix

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER fenix:fenix
# ENV HOME=/opt

# Install the released application
COPY --from=builder --chown=fenix:fenix  /buildroot/tcp_echo/_rel .

ENV PATH="/fenix/bin:$PATH"
ENV ERL_CRASH_DUMP=/dev/null
ENV RELX_REPLACE_OS_VARS=true
ENV ERL_DIST_PORT=27784
ENV HOME "/fenix"

# Make release executables available to any user,
# in case someone runs the container with `--user`
# RUN find /opt -executable -type f -exec chmod +x {} +

# Expose relevant ports
EXPOSE 5555/tcp

# VOLUME ["/fenix/data", "/fenix/etc", "/fenix/tmp", "/fenix/log"]

# Maybe ENTRYPOINT?
CMD ["/fenix/tcp_echo/bin/tcp_echo", "foreground"]
# CMD ["ls", "/tcp_echo/tcp_echo"]

# Appended by flyctl
# ENV ECTO_IPV6 true
# ENV ERL_AFLAGS "-proto_dist inet6_tcp"
