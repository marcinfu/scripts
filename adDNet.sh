#!/bin/bash
echo -e '####################\nadDNet version 0.1\n by marcinfu\n####################\n'
echo "Podaj adres ip"
read adres_ip
touch /tmp/tmp.txt
echo "$adres_ip" >> /tmp/tmp.txt

#################
####interfaces###
#################
cat > /etc/network/interfaces << EOF

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address $adres_ip
netmask 255.255.224.0
gateway 172.16.224.1
dns-search otlabs.local otlabs.loal
dns-nameservers 172.16.224.1 8.8.8.8

EOF

#################
#####hostname####
#################
zmienna=`sed 's/\./\-/g' /tmp/tmp.txt`
echo "ip-$zmienna" > /etc/hostname

#################
######hosts######
#################

cat > /etc/hosts << EOF

127.0.0.1               localhost
127.0.1.1               ip-$zmienna
# The following lines are desirable for IPv6 capable hosts
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
10.122.66.20            puppetmaster PLLDVM20SPAYUTIL01
10.122.66.21            PLLDVM21SPAYAPP1
10.122.66.22            PLLDVM22SPAYAPP2
10.122.66.23            PLLDVM23SPAYCASS1
10.122.66.24            PLLDVM24SPAYCASS2
10.122.66.25            PLLDVM25SPAYCASS3
10.122.66.26            PLLDVM26SPAYMARIADB1
10.122.66.27            PLLDVM27SPAYMARIADB2
10.122.66.28            spay-pprod-cc.ldz.pl PLLDVM28SPAYFRONT1 spay-pprod-samsung.ldz.pl spay-pprod-static.ldz.pl spay-pprod-banks.ldz.pl
10.122.66.29            PLLDVM29SPAYHSA1
10.122.66.31            PLLDVM31SPAYAPP3
10.122.66.32            PLLDVM32SPAYAPP4
10.122.66.33            enrollment-app-lb hce-usm-lb hce-se-manager-lb
10.122.66.35            issuers-out-lb samsung-out-lb
10.122.66.36            PLLDVM36SPAYREDIS1
10.122.66.37            PLLDVM37SPAYREDIS2
10.122.66.38            PLLDVM38SPAYREDIS3
172.16.205.14           ip-172-16-205-14
172.16.205.15           ip-172-16-205-15
172.16.205.16           ip-172-16-205-16
172.16.205.37           tsmsp-puppetmaster ip-172-16-205-37
172.16.220.136          ip-172-16-220-136
172.16.224.28           ip-172-16-224-28
172.16.224.29           ip-172-16-224-29 salt-master
172.16.224.36           ip-172-16-224-36 htz-puppetmaster
172.16.224.37           ip-172-16-224-37
172.16.224.38           ip-172-16-224-38
172.16.224.39           ip-172-16-224-39
172.16.224.40           ip-172-16-224-40
172.16.224.41           ip-172-16-224-41
172.16.224.42           ip-172-16-224-42
172.16.224.43           ip-172-16-224-43
172.16.224.44           ip-172-16-224-44
172.16.224.45           ip-172-16-224-45
172.16.224.46           ip-172-16-224-46
172.16.224.47           ip-172-16-224-47
172.16.224.48           ip-172-16-224-48
172.16.224.54           ip-172-16-224-54
172.16.224.55           ip-172-16-224-55
172.16.224.56           ip-172-16-224-56
172.16.224.57           ip-172-16-224-57
172.16.224.58           ip-172-16-224-58
172.16.224.59           ip-172-16-224-59
172.16.224.67           ip-172-16-224-67
172.16.224.68           ip-172-16-224-68
172.16.224.69           ip-172-16-224-69
172.16.224.101          smsrdocker
172.16.224.108          smdpdocker

EOF

rm /tmp/tmp.txt

echo -e '\e[32mDodano: \n  interfaces \n  hostname \n  hosts \e[0m'
echo -e '\e[31mDodac sprawdzanie i zabezpieczenie\e[0m'
