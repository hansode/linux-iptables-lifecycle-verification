# -*-Shell-script-*-
#
# requires:
#   bash
#

## system variables

readonly abs_dirname=$(cd ${BASH_SOURCE[0]%/*} && pwd)
readonly shunit2_file=${abs_dirname}/../../shunit2

## include files

. ${abs_dirname}/../../../functions/iptables-lifecycle.sh

## group variables

node=node01

## group functions

function oneTimeSetUp() {
  generate_iptables_rule   ${node}
  generate_iptables_config ${node}
 #show_iptables_rule       ${node}
  force_stop_iptables      ${node}
}
