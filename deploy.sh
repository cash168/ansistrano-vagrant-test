#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$( dirname "$0" )" && pwd) #"current dir
cd $SCRIPT_DIR

VM_STATUS=`vagrant status web01 --machine-readable | grep ",state,"  | awk -F, '{print $4}'`
case "${VM_STATUS}" in
  running)
    echo "Vagrant web01 running..."
  ;;
  poweroff)
    echo "Vagrant web01 POWEROFF"
    exit 1
  ;;
  *)
     echo "Unhandled web01: ${VM_STATUS}"
    exit 1
  ;;
esac

VM_STATUS=`vagrant status web02 --machine-readable | grep ",state,"  | awk -F, '{print $4}'`
case "${VM_STATUS}" in
  running)
    echo "Vagrant web02 running..."
  ;;
  poweroff)
    echo "Vagrant web02 POWEROFF"
    exit 1
  ;;
  *)
     echo "Unhandled web02: ${VM_STATUS}"
    exit 1
  ;;
esac

if ping -c1 -w2 172.16.33.21 >/dev/null 2>&1
then
  echo "Ping responded; IP address 172.16.33.21 allocated!" >&2
fi

if ping -c1 -w2 172.16.33.22 >/dev/null 2>&1
then
  echo "Ping responded; IP address 172.16.33.22 allocated!" >&2
fi

cd $SCRIPT_DIR/my-playbook

ansible-playbook -v -i hosts deploy.yml
