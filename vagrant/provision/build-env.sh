#!/usr/bin/env bash

set -x

sudo apt-get update -qq

sudo DEBIAN_FRONTEND=noninteractive apt-get -qqy \
    --allow-downgrades \
    --allow-remove-essential \
    --allow-change-held-packages \
     -o Dpkg::Options::="--force-confdef" \
     -o Dpkg::Options::="--force-confold" \
      dist-upgrade

# sudo apt-get install -y software-properties-common
# sudo add-apt-repository --yes ppa:longsleep/golang-backports
# sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    qemu-user-static \
    golang-go \
    kpartx \
    unzip \
    wget \
    curl \
    git \
    fdisk \
    e2fsprogs

sudo rm -rf /var/lib/apt/lists/*

echo 'export GOROOT=/usr/lib/go
export GOPATH=$HOME/work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' | tee -a /home/vagrant/.profile

export GOROOT=/usr/lib/go
export GOPATH=$HOME/work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PACKER_VERSION="1.5.5"

[[ -e /tmp/packer ]] && rm /tmp/packer
wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -q -O /tmp/packer.zip
cd /tmp
unzip -u packer.zip
rm -rf packer.zip
sudo cp packer /usr/local/bin
cd ..
