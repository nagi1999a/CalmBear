FROM debian:bullseye-20240513

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential autoconf libtool pkg-config cmake g++-multilib --no-install-recommends

# 32bit libraries
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libssl-dev:i386 zlib1g-dev:i386 libre2-dev:i386 --no-install-recommends

# 64bit libraries
RUN apt-get update && apt-get install -y libssl-dev zlib1g-dev libre2-dev --no-install-recommends
