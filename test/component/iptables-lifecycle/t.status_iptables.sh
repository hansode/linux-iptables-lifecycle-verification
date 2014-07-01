#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_status_iptables() {
  # "status" depends on iptables running
  status_iptables ${node}
  assertNotEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
