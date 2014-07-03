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

function test_run_in_target() {
  run_in_target ${node} "hostname"
  assertEquals 0 ${?}

  run_in_target ${node} <<-EOS
	hostname
	EOS
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
