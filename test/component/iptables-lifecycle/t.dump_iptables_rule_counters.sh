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
  # depends on iptables running
  force_start_iptables ${node}
}

function test_dump_iptables_rule_counters() {
  dump_iptables_rule_counters ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
