#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_generate_iptables_rule() {
  generate_iptables_rule ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
