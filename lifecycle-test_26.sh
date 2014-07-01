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

current_rule="$(show_iptables_rule_counters ${node})"
previous_rule="${current_rule}"

set +x

for i in {1..5}; do
  echo "... i=${i}"

  reload_iptables ${node}
  current_rule="$(show_iptables_rule_counters ${node})"

  # should not be same
  ! diff <(echo "${previous_rule}") <(echo "${current_rule}")

  previous_rule="${current_rule}"
done
