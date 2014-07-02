#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_enabled_save_on_restart_restart_cmprule() {
  before_str="$(show_iptables_rule ${node})"
  [[ -n "${before_str}" ]]
  assertEquals "should show iptables rule and counters" 0 ${?}

  for i in {1..3}; do
    restart_iptables ${node}
    assertEquals "should restart iptables" 0 ${?}

    run_in_target ${node} "hostname" >/dev/null
    assertEquals "should grow packet counter" 0 ${?}

    after_str="$(show_iptables_rule ${node})"
    [[ -n "${after_str}" ]]
    assertEquals "should show iptables rule counters" 0 ${?}

    diff_str "${before_str}" "${after_str}"
    assertNotEquals "should have difference" 0 ${?}

    before_str="${after_str}"
  done
}

## shunit2

. ${shunit2_file}
