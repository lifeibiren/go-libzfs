#!/bin/sh

set -ex

echo "ci inside qemu"
sleep 1

mount / -o remount,rw
depmod -a
modprobe zfs

cd /src
go test
echo "$?" > /test-result
