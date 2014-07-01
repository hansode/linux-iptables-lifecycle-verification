#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_disable_unload_start_genrule2_reload() {
  generate_iptables_rule2 ${node}
  assertEquals 0 ${?}

  before_status="$(status_iptables ${node})"
  [[ -n "${before_status}" ]]
  assertEquals 0 ${?}

  reload_iptables ${node}
  assertEquals 0 ${?}

  after_status="$(status_iptables ${node})"
  [[ -n "${after_status}" ]]
  assertEquals 0 ${?}

  diff_str "${before_lsmod}"  "${after_lsmod}"
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
