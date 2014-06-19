#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

# Do some changes ...

cat <<-'_EOS_' > /etc/sysconfig/iptables
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
	_EOS_
