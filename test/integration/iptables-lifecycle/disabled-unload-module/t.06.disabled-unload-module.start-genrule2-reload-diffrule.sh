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
}

function test_disable_unload_start_genrule2_cmprule() {
  before_str="$(show_iptables_rule_counters ${node})"
  [[ -n "${before_str}" ]]
  assertEquals "should show iptables rule and counters" 0 ${?}
  after_str="${before_str}"

  for i in {1..5}; do
    echo "... i=${i}"

    reload_iptables ${node}
    assertEquals "should reload iptables" 0 ${?}

    run_in_target ${node} "curl -fsSkL --retry 3 http://www.yahoo.co.jp/" >/dev/null
    assertEquals "should grow packet counter" 0 ${?}

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
