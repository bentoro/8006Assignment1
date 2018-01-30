IP="/sbin/iptables"

TCPD='0'
TCPA='53, 443, 80, 22'
UDPD='0'
UDPA='53, 67:68, 80, 22'

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
$IP -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

$IP -A INPUT -p tcp -m tcp --sport 1024:65535 -j ACCT

$IP -A INPUT -p tcp -m tcp --sport 22 -j ACCT
$IP -A INPUT -p tcp -m tcp --dport 22 -j ACCT
$IP -A INPUT -p tcp -m tcp --sport 80 -j ACCT
$IP -A INPUT -p tcp -m tcp --dport 80 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --sport 22 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --dport 22 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --sport 80 -j ACCT
$IP -A OUTPUT -p tcp -m tcp --dport 80 -j ACCT

$IP -A INPUT -p all -j TRAFFIC
$IP -A INPUT -p all -j TRAFFIC

IFS=',' read -ra DROP <<< "$TCPD"
for i in "${DROP[@]}"; do
	$IP -A ACCT -p tcp -m tcp --sport $i -j DROP
	$IP -A ACCT -p tcp -m tcp --dport $i -j DROP
	$IP -A TRAFFIC -p tcp -m tcp --sport $i -j DROP
	$IP -A TRAFFIC -p tcp -m tcp --dport $i -j DROP
done

IFS=',' read -ra ACCEPT <<< "$TCPA"
for i in "${ACCEPT[@]}"; do
    $IP -A ACCT -p tcp -m tcp --sport $i -j ACCEPT
    $IP -A ACCT -p tcp -m tcp --dport $i -j ACCEPT
    $IP -A TRAFFIC -p tcp -m tcp --sport $i -j ACCEPT
    $IP -A TRAFFIC -p tcp -m tcp --dport $i -j ACCEPT
done

IFS=',' read -ra DROP <<< "$UDPD"
for i in "${DROP[@]}"; do
    $IP -A ACCT -p udp -m udp --sport $i -j DROP
    $IP -A ACCT -p udp -m udp --dport $i -j DROP
    $IP -A TRAFFIC -p udp -m udp --sport $i -j DROP
    $IP -A TRAFFIC -p udp -m udp --dport $i -j DROP
done

IFS=',' read -ra ACCEPT <<< "$UDPA"
for i in "${ACCEPT[@]}"; do
    $IP -A ACCT -p udp -m udp --sport $i -j ACCEPT
    $IP -A ACCT -p udp -m udp --dport $i -j ACCEPT
    $IP -A TRAFFIC -p udp -m udp --sport $i -j ACCEPT
    $IP -A TRAFFIC -p udp -m udp --dport $i -j ACCEPT
done
