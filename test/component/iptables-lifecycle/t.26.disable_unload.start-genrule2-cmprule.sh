#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_disable_unload_start_genrule2_cmprule() {
  disable_unload_module ${node}
  assertEquals 0 ${?}

  start_iptables ${node}
  assertEquals 0 ${?}

  generate_iptables_rule2 ${node}
  assertEquals 0 ${?}

  current_rule="$(show_iptables_rule_counters ${node})"
  assertEquals 0 ${?}
  previous_rule="${current_rule}"

  for i in {1..3}; do
    echo "... i=${i}"

    reload_iptables ${node}
    current_rule="$(show_iptables_rule_counters ${node})"
    assertEquals 0 ${?}

    # wait for count up of iptables
    sleep 1

    diff <(echo "${previous_rule}") <(echo "${current_rule}")
    ret=${?}; echo ret=${ret}
    assertNotEquals 0 ${ret}

    previous_rule="${current_rule}"
  done
}

## shunit2

. ${shunit2_file}
