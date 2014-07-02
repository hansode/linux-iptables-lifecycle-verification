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
    disable_module_unload ${node}
    enable_save_on_restart ${node}
    start_iptables ${node}
  } >/dev/null
}
