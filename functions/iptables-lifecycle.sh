#!/bin/bash
#
# requires:
#  bash
#

# functions

## common

function run_in_target() {
  local node=${1}; shift

  if [[ "${#}" == 0 ]]; then
    vagrant ssh ${node}
  else
    vagrant ssh ${node} -c "${@}"
  fi
}

function show_ipaddr() {
  local node=${1}
  shift; eval local "${@}"
  local addr=$(
    run_in_target ${node} "ip addr show ${ifname} | grep -w inet" | awk '{print $2}'
  )
  echo ${addr%%/*}
}

## iptables-rule

function show_iptables_rule() {
  local node=${1}
  run_in_target ${node} "sudo cat /etc/sysconfig/iptables"
}

function show_iptables_rule_counters() {
  local node=${1}
  run_in_target ${node} "sudo iptables-save -c | egrep -v '^#'"
}

function generate_iptables_rule() {
  local node=${1}
  run_in_target ${node} "sudo tee /etc/sysconfig/iptables" < <(render_iptables_rule) >/dev/null
}

function render_iptables_rule() {
  cat <<-'_RULE_'
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

function generate_iptables_rule2() {
  local node=${1}
  run_in_target ${node} "sudo tee /etc/sysconfig/iptables" < <(render_iptables_rule2) >/dev/null
}

function render_iptables_rule2() {
  cat <<-'_RULE_'
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
	-A INPUT -m state --state NEW -m tcp -p tcp --dport   80 -j ACCEPT
	-A INPUT -m state --state NEW -m tcp -p tcp --dport  443 -j ACCEPT
	-A INPUT -j REJECT --reject-with icmp-host-prohibited
	-A FORWARD -j REJECT --reject-with icmp-host-prohibited
	COMMIT
	_RULE_
}

function generate_iptables_config() {
  local node=${1}
  run_in_target ${node} "sudo tee /etc/sysconfig/iptables-config" <<-'_CONFIG_' >/dev/null
	# Load additional iptables modules (nat helpers)
	#   Default: -none-
	# Space separated list of nat helpers (e.g. 'ip_nat_ftp ip_nat_irc'), which
	# are loaded after the firewall rules are applied. Options for the helpers are
	# stored in /etc/modprobe.conf.
	IPTABLES_MODULES=""
	
	# Unload modules on restart and stop
	#   Value: yes|no,  default: yes
	# This option has to be 'yes' to get to a sane state for a firewall
	# restart or stop. Only set to 'no' if there are problems unloading netfilter
	# modules.
	IPTABLES_MODULES_UNLOAD="yes"
	
	# Save current firewall rules on stop.
	#   Value: yes|no,  default: no
	# Saves all firewall rules to /etc/sysconfig/iptables if firewall gets stopped
	# (e.g. on system shutdown).
	IPTABLES_SAVE_ON_STOP="no"
	
	# Save current firewall rules on restart.
	#   Value: yes|no,  default: no
	# Saves all firewall rules to /etc/sysconfig/iptables if firewall gets
	# restarted.
	IPTABLES_SAVE_ON_RESTART="no"
	
	# Save (and restore) rule and chain counter.
	#   Value: yes|no,  default: no
	# Save counters for rules and chains to /etc/sysconfig/iptables if
	# 'service iptables save' is called or on stop or restart if SAVE_ON_STOP or
	# SAVE_ON_RESTART is enabled.
	IPTABLES_SAVE_COUNTER="no"
	
	# Numeric status output
	#   Value: yes|no,  default: yes
	# Print IP addresses and port numbers in numeric format in the status output.
	IPTABLES_STATUS_NUMERIC="yes"
	
	# Verbose status output
	#   Value: yes|no,  default: yes
	# Print info about the number of packets and bytes plus the "input-" and
	# "outputdevice" in the status output.
	IPTABLES_STATUS_VERBOSE="no"
	
	# Status output with numbered lines
	#   Value: yes|no,  default: yes
	# Print a counter/number for every rule in the status output.
	IPTABLES_STATUS_LINENUMBERS="yes"
	
	# Reload sysctl settings on start and restart
	#   Default: -none-
	# Space separated list of sysctl items which are to be reloaded on start.
	# List items will be matched by fgrep.
	#IPTABLES_SYSCTL_LOAD_LIST=".nf_conntrack .bridge-nf"
	_CONFIG_
}

function lsmod_iptables() {
  local node=${1}
  run_in_target ${node} "lsmod | egrep '^ipt|^nf_|^xt_'"
}

function disable_unload_module() {
  local node=${1}
  run_in_target ${node} <<-'EOS'
	sudo cp /etc/sysconfig/iptables-config /etc/sysconfig/iptables-config.0
	sudo sed -i "s,^IPTABLES_MODULES_UNLOAD=.*,IPTABLES_MODULES_UNLOAD=no," /etc/sysconfig/iptables-config
	sudo diff /etc/sysconfig/iptables-config.0 /etc/sysconfig/iptables-config || :
	EOS
}

## iptables

### ignore exit status code

function force_start_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables start || :"
}

function force_stop_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables stop || :"
}

### regular command

function start_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables start"
}

function stop_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables stop"
}

function restart_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables restart"
}

function reload_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables reload"
}

function condrestart_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables condrestart"
}

function panic_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables panic"
}

function save_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables save"
}

function status_iptables() {
  local node=${1}
  run_in_target ${node} "sudo service iptables status"
}
