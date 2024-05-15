#!/bin/bash
# Install script for debian-based linux distributions
dpkg --add-architecture i386 && apt-get update
apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 --no-install-recommneds
cp -r output/i386/* /usr/
cp -r output/x86_64/* /usr/