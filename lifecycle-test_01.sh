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

#start_iptables node01
show_ipaddr    node01 ifname=eth0
# stop_iptables node01
