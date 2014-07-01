#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_disable_unload_start_restart_reload() {
  for i in {1..3}; do
    restart_iptables ${node}
    assertEquals 0 ${?}

    before_str="$(lsmod_iptables ${node})"
    [[ -n "${before_str}" ]]
    assertEquals 0 ${?}

    reload_iptables ${node}
    assertEquals 0 ${?}

    after_str="$(lsmod_iptables ${node})"
    [[ -n "${after_str}" ]]
    assertEquals 0 ${?}

    diff_str "${before_str}"  "${after_str}"
    assertEquals 0 ${?}
  done
}

## shunit2

. ${shunit2_file}
