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
  # "reload" depends on iptables running
  force_start_iptables ${node}
}

function test_reload_iptables() {
  reload_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
