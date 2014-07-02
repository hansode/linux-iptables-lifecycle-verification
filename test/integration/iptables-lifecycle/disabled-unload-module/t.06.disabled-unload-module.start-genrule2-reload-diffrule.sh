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
  generate_iptables_rule2 ${node}
  assertEquals 0 ${?}

  before_str="$(show_iptables_rule_counters ${node})"
  [[ -n "${before_str}" ]]
  assertEquals 0 ${?}
  after_str="${before_str}"

  for i in {1..5}; do
    echo "... i=${i}"

    reload_iptables ${node}
    assertEquals 0 ${?}

    # in order to grow packet counter
    run_in_target ${node} "curl -fsSkL --retry 3 http://www.yahoo.co.jp/" >/dev/null
    assertEquals 0 ${?}

    after_str="$(show_iptables_rule_counters ${node})"
    [[ -n "${after_str}" ]]
    assertEquals 0 ${?}

    diff_str "${before_str}" "${after_str}"
    assertNotEquals 0 ${?}

    before_str="${after_str}"
  done
}

## shunit2

. ${shunit2_file}
