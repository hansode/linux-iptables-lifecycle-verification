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

 lsmod_iptables ${node}
 start_iptables ${node}
 lsmod_iptables ${node}
  stop_iptables ${node}
 lsmod_iptables ${node}
