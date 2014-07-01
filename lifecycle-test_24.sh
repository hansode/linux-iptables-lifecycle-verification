#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

#

. lifecycle-functions.sh
. lifecycle-test_setup.sh

# main

node=node01

disable_unload_module ${node}

start_iptables ${node}

for i in {1..3}; do
  restart_iptables ${node}
    lsmod_iptables ${node}
   reload_iptables ${node}
    lsmod_iptables ${node}
done
