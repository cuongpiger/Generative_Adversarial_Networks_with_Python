#!/bin/bash
# Run this file with `sudo su`

sudo apt update
sudo apt upgrade -y
sudo apt install build-essential dkms linux-headers-$(uname -r) -y
sudo apt install gcc make perl -y

sudo apt update
sudo add-apt-repository ppa:openjdk-r/ppa

sudo apt install default-jdk -y

sudo apt update
sudo apt install git fakeroot build-essential tar libncurses-dev tar xz-utils libssl-dev bc stress python3-distutils libelf-dev linux-headers-$(uname -r) bison flex libncurses5-dev util-linux net-tools linux-tools-$(uname -r) exuberant-ctags cscope sysfsutils gnome-system-monitor curl perf-tools-unstable gnuplot rt-tests indent tree psmisc smem libnuma-dev numactl hwloc bpfcc-tools sparse flawfinder cppcheck tuna bsdmainutils trace-cmd virt-what -y