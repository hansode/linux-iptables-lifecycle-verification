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
  current_rule="$(show_iptables_rule_counters ${node})"
  assertEquals 0 ${?}
  previous_rule="${current_rule}"

  generate_iptables_rule2 ${node}
  assertEquals 0 ${?}

  for i in {1..5}; do
    echo "... i=${i}"

    reload_iptables ${node}

    # in order to grow packet counter
    run_in_target ${node} "curl -fsSkL http://www.yahoo.co.jp/" >/dev/null

    current_rule="$(show_iptables_rule_counters ${node})"
    assertEquals 0 ${?}

    diff_str "${previous_rule}" "${current_rule}"
    assertNotEquals 0 ${?}

    previous_rule="${current_rule}"
  done
}

## shunit2

. ${shunit2_file}
