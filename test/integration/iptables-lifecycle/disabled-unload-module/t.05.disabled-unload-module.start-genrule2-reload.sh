#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_disable_unload_start_genrule2_reload() {
  generate_iptables_rule2 ${node}
  assertEquals 0 ${?}

  status_iptables ${node}
  assertEquals 0 ${?}

  reload_iptables ${node}
  assertEquals 0 ${?}

  status_iptables ${node}
  assertEquals 0 ${?}
}

## shunit2

. ${shunit2_file}
