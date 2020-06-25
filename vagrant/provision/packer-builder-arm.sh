#!/usr/bin/env bash

set -x

cd /vagrant
go mod download

# mkdir -p $GOPATH/src/github.com/mkaczanowski/
# cd $GOPATH/src/github.com/mkaczanowski/

rm -rf packer-builder-arm
# cp -a /vagrant packer-builder-arm
# cd packer-builder-arm

go build -o packer-builder-arm
