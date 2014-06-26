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

  start_iptables node01
restart_iptables node01
