#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_panic_iptables() {
  # no need to test...
 #panic_iptables ${node} ifname=eth0
  :
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
