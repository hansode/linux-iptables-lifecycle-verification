# -*-Shell-script-*-
#
# requires:
#   bash
#

## system variables

## include files

. ${BASH_SOURCE[0]%/*}/../helper_shunit2.sh

## group variables

## group functions

function oneTimeSetUp() {
  generate_iptables_rule   ${node}
  generate_iptables_config ${node}
  force_stop_iptables      ${node}
}

function setUp() {
  disable_unload_module ${node}
}
