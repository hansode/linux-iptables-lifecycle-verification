#!/bin/bash
#
# requires:
#  bash
#

# functions

## common

function run_in_target() {
  local node=${1}; shift
  vagrant ssh ${node} -c "${@}"
}

function show_ipaddr() {
  local node=${1}
  shift; eval local "${@}"
  run_in_target ${node} "ip addr show ${ifname} | grep -w inet"
}

## iptables-rule

function show_iptables_rule() {
  local node=${1}
  run_in_target ${node} "sudo cat /etc/sysconfig/iptables"
}

function generate_iptables_rule() {
  local node=${1}
  run_in_target ${node} "sudo tee /etc/sysconfig/iptables" <<-'_RULE_'
	*nat
	:PREROUTING ACCEPT [0:0]
	:POSTROUTING ACCEPT [0:0]
	:OUTPUT ACCEPT [0:0]
	-A POSTROUTING -o eth0 -s 172.16.2.0/24 -j MASQUERADE
	COMMIT

	*filter
	:INPUT ACCEPT [0:0]
	:FORWARD ACCEPT [0:0]
	:OUTPUT ACCEPT [0:0]
	-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	-A INPUT -p icmp -j ACCEPT
	-A INPUT -i lo -j ACCEPT
	-A INPUT -m state --state NEW -m tcp -p tcp --dport   22 -j ACCEPT
	-A INPUT -j REJECT --reject-with icmp-host-prohibited
	-A FORWARD -j REJECT --reject-with icmp-host-prohibited
	COMMIT
	_RULE_
}

## iptables

function force_stop_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables stop || :"
}

function stop_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables stop"
}

function force_start_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables start || :"
}

function start_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables start"
}

function status_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables status"
}
