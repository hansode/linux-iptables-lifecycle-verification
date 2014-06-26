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

 lsmod_iptables node01
 start_iptables node01
 lsmod_iptables node01
  stop_iptables node01
 lsmod_iptables node01
