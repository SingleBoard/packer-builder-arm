#!/bin/bash
trap 'exit 0' SIGINT
/usr/sbin/update-binfmts --enable qemu-arm >/dev/null 2>&1

PACKER=/bin/packer

echo running $PACKER

exec $PACKER "${@}"

exit 0
