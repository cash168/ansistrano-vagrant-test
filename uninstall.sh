#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$( dirname "$0" )" && pwd) #"current dir
cd $SCRIPT_DIR

vagrant halt
vagrant destroy -f

ssh-keygen -f "~/.ssh/known_hosts" -R "172.16.33.21" || true
ssh-keygen -f "~/.ssh/known_hosts" -R "172.16.33.22" || true
