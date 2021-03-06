#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function setUp() {
  # "status" depends on iptables running
  force_start_iptables ${node}
}

function test_status_iptables() {
  status_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
