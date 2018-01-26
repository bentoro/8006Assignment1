IP="/sbin/iptables"

#flush iptables
$IP -F

#set default policies
$IP -P INPUT DROP
$IP -P OUTPUT DROP

#create user-defined chains
$IP -N OUT
$IP -N IN

# Allow localhost
$IP -A INPUT -p ALL -i lo -j ACCEPT

#allow DHCP
$IP -A INPUT -p UDP -s 0/0 --sport 67 --dport 68 -j ACCEPT

#allow from source ports 1024-65535
$IP -A IN -p TCP -s 0/0 --dport 80 --sport 1024:65535 -j ACCEPT

#allow SSH
$IP -A IN -p TCP -s 0/0 --dport 22 -j ACCEPT

#allow DHCP
$IP -A OUTPUT -p UDP --dport 68 -m state --state NEW -j ACCEPT

#allow DNS
$IP -A OUTPUT -p TCP --dport 53 -j ACCEPT
$IP -A OUTPUT -p UDP --dport 53 -j ACCEPT

#allow HTTP
$IP -A OUT -p TCP --sport 80 -j ACCEPT
$IP -A OUT -p TCP --dport 80 -j ACCEPT

#allow SSH
$IP -A OUT -p TCP --sport 22 -j ACCEPT
$IP -A OUT -p TCP --dport 22 -j ACCEPT

