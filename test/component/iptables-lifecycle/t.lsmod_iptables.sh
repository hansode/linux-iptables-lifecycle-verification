#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_lsmod_iptables() {
  lsmod_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
