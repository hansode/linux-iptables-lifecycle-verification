#!/bin/bash
#
# requires:
#  bash
#

node=node01

generate_iptables_rule ${node}
show_iptables_rule     ${node}
force_stop_iptables    ${node}
