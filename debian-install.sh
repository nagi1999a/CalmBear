#!/bin/bash
# Install script for debian-based linux distributions
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo cp -r output/i386/* /usr/local/
sudo cp -r output/x86_64/* /usr/local/