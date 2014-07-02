#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function setUp() {
  generate_iptables_rule2 ${node}
  reload_iptables ${node}
}

function test_disable_unload_start_genrule2_cmprule() {
  before_str="$(show_iptables_rule_counters ${node})"
  [[ -n "${before_str}" ]]
  assertEquals "should show iptables rule and counters" 0 ${?}

  for i in {1..3}; do
    reload_iptables ${node}
    assertEquals "should reload iptables" 0 ${?}

    j=0
    while [[ ${i} != ${j} ]]; do
      run_in_target ${node} "hostname" >/dev/null
      assertEquals "should grow packet counter" 0 ${?}
      j=$((${j} + 1))
    done

    after_str="$(show_iptables_rule_counters ${node})"
    [[ -n "${after_str}" ]]
    assertEquals "should show iptables rule counters" 0 ${?}

    diff_str "${before_str}" "${after_str}"
    assertNotEquals "should have difference" 0 ${?}

    before_str="${after_str}"
  done
}

## shunit2

. ${shunit2_file}
