#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_disable_unload_start_stop() {
  before_lsmod="$(lsmod_iptables ${node})"
  [[ -n "${before_lsmod}" ]]
  assertEquals 0 ${?}

  stop_iptables ${node}
  assertEquals 0 ${?}

  after_lsmod="$(lsmod_iptables ${node})"
  [[ -n "${after_lsmod}" ]]
  assertEquals 0 ${?}

  diff_str "${before_lsmod}" "${after_lsmod}"
  assertNotEquals 0 ${?}
}


## shunit2

. ${shunit2_file}
