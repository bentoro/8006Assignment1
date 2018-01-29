IP="/sbin/iptables"

#flush iptables
$IP -F

#Drop exisiting user-defined chains
$IP -X

#set default policies
$IP -P INPUT ACCEPT
$IP -P FORWARD ACCEPT
$IP -P OUTPUT ACCEPT

#create user-defined chains
$IP -N ACCT
$IP -N TRAFFIC

#allow established connections through
#$IP -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#Drop traffic from port 0
$IP -A INPUT -p tcp -m tcp --sport 0 -j DROP
$IP -A INPUT -p tcp -m tcp --dport 0 -j DROP
$IP -A INPUT -p udp -m udp --sport 0 -j DROP
$IP -A INPUT -p udp -m udp --dport 0 -j DROP
$IP -A OUTPUT -p tcp -m tcp --sport 0 -j DROP
$IP -A OUTPUT -p tcp -m tcp --dport 0 -j DROP
$IP -A OUTPUT -p udp -m udp --sport 0 -j DROP
$IP -A OUTPUT -p udp -m udp --dport 0 -j DROP

#allow DNS
$IP -A INPUT -p tcp --dport 53 -j ACCEPT
$IP -A OUTPUT -p tcp --dport 53 -j ACCEPT
$IP -A INPUT -p udp --dport 53 -j ACCEPT
$IP -A OUTPUT -p udp --dport 53 -j ACCEPT

#allow DHCP
$IP -A OUTPUT -p udp --sport 67:68 -j ACCEPT
$IP -A OUTPUT -p udp --dport 67:68 -j ACCEPT
$IP -A INPUT -p udp --sport 67:68 -j ACCEPT
$IP -A INPUT -p udp --dport 67:68 -j ACCEPT

$IP -A OUTPUT -p tcp --sport 443 -j ACCEPT
$IP -A INPUT -p tcp --dport 443 -j ACCEPT

$IP -A ACCT -j ACCEPT

#allow HTTP
$IP -A INPUT -p tcp -m tcp --dport 80 -j ACCT
$IP -A INPUT -p tcp -m tcp --sport 1024:65535 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --sport 80 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --dport 80 -j ACCT

#allow SSH
$IP -A INPUT -p tcp -m tcp --sport 22 -j ACCT
$IP -A INPUT -p tcp -m tcp --dport 22 -j ACCT
#allow SSH
$IP -A OUTPUT -p tcp -m tcp --sport 22 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --dport 22 -j ACCT


#drop all syn packets
$IP -A INPUT -p tcp --syn -j DROP

$IP -A INPUT -j TRAFFIC
$IP -A OUTPUT -j TRAFFIC
