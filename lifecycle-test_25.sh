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

generate_iptables_rule2 ${node}

 status_iptables ${node}
 reload_iptables ${node}
 status_iptables ${node}
