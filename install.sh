#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$( dirname "$0" )" && pwd) #"current dir
cd $SCRIPT_DIR

VM_STATUS=`vagrant status web01 --machine-readable | grep ",state,"  | awk -F, '{print $4}'`
case "${VM_STATUS}" in
  running)
    echo "Vagrant web0 already running..."
    exit 1
  ;;
  poweroff)
    echo "Vagrant web01 POWEROFF"
    exit 1
  ;;
  *)
     echo "Unhandled web01: ${VM_STATUS}"
  ;;
esac

VM_STATUS=`vagrant status web02 --machine-readable | grep ",state,"  | awk -F, '{print $4}'`
case "${VM_STATUS}" in
  running)
    echo "Vagrant web02 already running..."
    exit 1
  ;;
  poweroff)
    echo "Vagrant web02 POWEROFF"
    exit 1
  ;;
  *)
     echo "Unhandled web02: ${VM_STATUS}"
  ;;
esac

if ping -c1 -w2 172.16.33.21 >/dev/null 2>&1
then
  echo "Error: Ping responded; IP address 172.16.33.21 allocated!" >&2
  echo "Remove existed host or run uninstall.sh first..." >&2
  exit 1
fi

if ping -c1 -w2 172.16.33.22 >/dev/null 2>&1
then
  echo "Error: Ping responded; IP address 172.16.33.22 allocated!" >&2
  echo "Remove existed host or run uninstall.sh first..." >&2
  exit 1
fi

vagrant up

ssh-keygen -f "~/.ssh/known_hosts" -R "172.16.33.21" || true
ssh-keygen -f "~/.ssh/known_hosts" -R "172.16.33.22" || true

sleep 2

cd $SCRIPT_DIR/my-playbook

ansible-playbook -v -i hosts install.yml
