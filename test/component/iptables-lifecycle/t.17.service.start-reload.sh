#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_service_start_reload() {
  start_iptables ${node}
  assertEquals 0 ${?}

  reload_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
