#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_force_stop_iptables() {
  force_stop_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
