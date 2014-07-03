#!/bin/bash
#
# requires:
#  bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## functions

function test_append_dynamic_rules_cmprule() {
  before_str="$(status_iptables ${node})"
  [[ -n "${before_str}" ]]
  assertEquals "should show iptables rule status" 0 ${?}

  run_in_target ${node} <<-EOS
	sudo iptables -t filter -A INPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT
	EOS
  assertEquals "should append iptables rule" 0 ${?}

  after_str="$(status_iptables ${node})"
  [[ -n "${after_str}" ]]
  assertEquals "should show iptables rule status" 0 ${?}

  diff_str "${before_str}" "${after_str}"
  assertNotEquals "should have difference" 0 ${?}
}

## shunit2

. ${shunit2_file}
