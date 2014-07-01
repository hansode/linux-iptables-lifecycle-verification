#!/bin/bash
#
# requires:
#  bash
#

node=node01

generate_iptables_rule   ${node}
generate_iptables_config ${node}
show_iptables_rule       ${node}
force_stop_iptables      ${node}
