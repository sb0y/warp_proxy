#!/bin/sh
#external_ip4_addr=`wget -q -O - ipinfo.io/ip | xargs`
local_ip4_addr=`ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p' | xargs`

dns_str=''
for i in `echo ${proxy_dns:-'8.8.8.8,1.1.1.1'} | sed "s/,/ /g"`
do
    dns_str="${dns_str}nserver ${i}\n"
done
# remove all 'nserver' records
sed -i -E '/nserver[^\n]*/d' /usr/local/3proxy/conf/3proxy.cfg
# add from docker-compose.yml
sed -i "1s/^/${dns_str}/" /usr/local/3proxy/conf/3proxy.cfg
# debug
#cat /usr/local/3proxy/conf/3proxy.cfg

sed -i "s#.*users .*#users ${proxy_username:-'warp_proxy'}:CL:${proxy_password:-'changeme'}#g" /usr/local/3proxy/conf/3proxy.cfg

#tunnel_server_ip4_addr='193.0.203.203'
#tunnel_ttl=255
#tunnel_mtu=1480
#tunnel_client_ip6_addr='2a03:e2c0:47a8::2/64'
#tunnel_server_ip6_addr='2a03:e2c0:47a8::1/64'
#tunnel_route_add_cmd_ip6='ip -6 route add ::/0 dev ipv6'
if [ "${enable_ipv6_tunnel}" == true ];
then
	tunnel_server_ip4_addr='95.213.189.133'
	tunnel_ttl=255
	tunnel_mtu=1480
	tunnel_client_ip6_addr='2a06:1301:4725::48a/127'
	tunnel_server_ip6_addr='2a06:1301:4725::48b/127'
	tunnel_route_add_cmd_ip6='ip -6 route add 2000::/3 dev ipv6'

	ip -6 route del 0/0
	#ip -6 route flush 0/0

	ip -6 route add ::1/128 dev lo

	ip tunnel add ipv6 mode sit remote ${tunnel_server_ip4_addr} local ${local_ip4_addr} ttl ${tunnel_ttl}
	ip link set ipv6 up mtu ${tunnel_mtu}
	ip addr add ${tunnel_client_ip6_addr} dev ipv6
	eval "${tunnel_route_add_cmd_ip6}"
	#ip -6 route add ::/0 dev ipv6
fi

/bin/3proxy /etc/3proxy/3proxy.cfg

if [ "${enable_ipv6_tunnel}" == true ];
then
	ip link set ipv6 down
	ip tunnel del ipv6
fi

exit 0