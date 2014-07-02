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

function diff_str() {
  diff <(echo "${1:-""}") <(echo "${2:-""}")
}

###

function _setup_iptables() {
  {
    generate_iptables_rule   ${node}
    generate_iptables_config ${node}
    force_stop_iptables      ${node}
  } >/dev/null
}

function _teardown_iptables() {
  :
}

function    before_setup_iptables() { :; }
function     after_setup_iptables() { :; }
function before_teardown_iptables() { :; }
function  after_teardown_iptables() { :; }

###

function setup_iptables() {
  before_setup_iptables
        _setup_iptables
   after_setup_iptables
}

function teardown_iptables() {
   before_terdown_iptables
         _terdown_iptables
    after_terdown_iptables
}

###

function oneTimeSetUp() {
  setup_iptables
}

function oneTimeTearDown() {
  setup_iptables
}
