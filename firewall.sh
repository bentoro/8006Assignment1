IP="/sbin/iptables"

#flush iptables
$IP -F

#set default policies
$IP -P INPUT DROP
$IP -P FORWARD DROP
$IP -P OUTPUT DROP

#create user-defined chains
$IP -N OUT
$IP -N IN

#allow DHCP
$IP -A INPUT -p udp -m udp --sport 67 -j ACCEPT
$IP -A INPUT -p udp -m udp --dport 68 -j ACCEPT
#allow from source ports 1024-65535
$IP -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
$IP -A INPUT -p tcp -m tcp --sport 1024:65535 -j ACCEPT
#allow SSH
$IP -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
$IP -A INPUT -p tcp -m tcp --sport 22 -j ACCEPT

#allow DHCP
$IP -A OUTPUT -p udp -m udp --dport 68 -j ACCEPT
$IP -A OUTPUT -p udp -m udp --sport 68 -j ACCEPT

#allow DNS
$IP -A OUTPUT -p tcp --dport 53 -j ACCEPT
$IP -A OUTPUT -p udp --dport 53 -j ACCEPT

#allow HTTP
$IP -A OUTPUT -p tcp -m tcp --sport 80 -j ACCEPT
$IP -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

#allow SSH
$IP -A OUTPUT -p tcp -m tcp --sport 22 -j ACCEPT
$IP -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT

