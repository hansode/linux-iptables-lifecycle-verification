#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function oneTimeSetUp() {
  :
}

function test_render_iptables_config() {
  render_iptables_config
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
