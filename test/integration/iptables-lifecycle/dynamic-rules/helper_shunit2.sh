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

function after_setup_iptables() {
  {
    start_iptables ${node}
  } >/dev/null
}
