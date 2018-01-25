$I = /sbin/iptables

#save iptables
/sbin/service iptables save



#clear iptables
$I -F


#drop all default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP

#Drop SSH PORT 22
iptables -A INPUT

#Drop HTTP PORT 80

#Drop HTTP

#Drop all INBOUDN Syns

#Allow DNS & DHCP at the TOP

#443 should be open
