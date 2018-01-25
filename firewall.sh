#save iptables
/sbin/service iptables save

#clear iptables
iptables -F


#drop all default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

#
