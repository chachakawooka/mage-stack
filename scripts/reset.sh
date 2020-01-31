#!/bin/bash
read -p "You will lose configs and the database will be reset. Are you sure? [y/n]" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    DIR=$(basename $(dirname $(realpath $(dirname $0))))
    FILTER="name=${DIR}_*"
    docker volume rm $(docker volume ls -f $FILTER | grep -v DRIVER | awk '{print $2}')
fi