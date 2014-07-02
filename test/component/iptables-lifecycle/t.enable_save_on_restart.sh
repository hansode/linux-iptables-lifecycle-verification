#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_enable_save_on_restart() {
  enable_save_on_restart ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
