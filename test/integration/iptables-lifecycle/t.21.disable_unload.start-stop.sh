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
  disable_unload_module ${node}
  assertEquals 0 ${?}

  start_iptables ${node}
  assertEquals 0 ${?}

  lsmod_iptables ${node}
  assertEquals 0 ${?}

  stop_iptables ${node}
  assertEquals 0 ${?}

  lsmod_iptables ${node}
  assertEquals 0 ${?}
}


## shunit2

. ${shunit2_file}
