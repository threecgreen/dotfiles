#!/bin/bash
find /var/btlogs/ -type f  | grep -v BtSalt | xargs truncate --size 0
rm -rf /tmp/bt/*
rm -rf /dev/shm/*
ipcrm -a
mkdir -p /tmp/bt
chmod -R 777 /var/btlogs/*
chmod -R 777 /var/btlogs
chmod -R 777 /tmp/bt/
touch /tmp/bt/UnlimitedCores
