# feb/17/2025 10:02:09 by RouterOS 6.49.17
# software id = LKC4-15KU
#
# model = 951Ui-2HnD
# serial number = DE3B0D1FB6B8
/interface wireless
set [ find default-name=wlan1 ] disabled=no mode=ap-bridge ssid=UKK-
/interface vlan
add interface=ether2 name=VLAN10 vlan-id=10
add interface=ether2 name=VLAN20 vlan-id=20
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=portalsmk.sch.id hotspot-address=192.168.40.1 login-by=http-chap \
    name=hsprof1
/ip hotspot user profile
add name=kepalasekola rate-limit=512k
add name=guru rate-limit=256k
add name=siswa rate-limit=128k
/ip pool
add name=hs-pool-6 ranges=192.168.40.2-192.168.40.250
add name=dhcp_pool1 ranges=192.168.10.2-192.168.10.254
add name=dhcp_pool2 ranges=192.168.20.2-192.168.20.254
add name=dhcp_pool3 ranges=192.168.30.2-192.168.30.254
/ip dhcp-server
add address-pool=hs-pool-6 disabled=no interface=wlan1 lease-time=1h name=\
    dhcp1
add address-pool=dhcp_pool1 disabled=no interface=VLAN10 name=dhcp2
add address-pool=dhcp_pool2 disabled=no interface=VLAN20 name=dhcp3
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=wlan1 name=hotspot1 profile=\
    hsprof1
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/tool user-manager profile
add name=2K name-for-users="" override-shared-users=off owner=admin price=\
    2000 starts-at=logon validity=10h
add name=50K name-for-users="" override-shared-users=off owner=admin price=\
    50000 starts-at=logon validity=4w2d
/tool user-manager profile limitation
add address-list="" download-limit=0B group-name=cipung12 ip-pool="" \
    ip-pool6="" name=rafi owner=admin transfer-limit=10485760B upload-limit=\
    0B uptime-limit=1d
/ip address
add address=192.168.10.1/24 interface=VLAN10 network=192.168.10.0
add address=192.168.20.1/24 interface=VLAN20 network=192.168.20.0
add address=192.168.30.1/24 interface=ether3 network=192.168.30.0
add address=192.168.40.1/24 interface=wlan1 network=192.168.40.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.20.0/24 gateway=192.168.20.1
add address=192.168.30.0/24 gateway=192.168.30.1
add address=192.168.40.0/24 comment="hotspot network" gateway=192.168.40.1
/ip dns
set allow-remote-requests=yes
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.40.0/24
/ip hotspot user
add name=admin
add name=kepalasekola password=123 profile=kepalasekola
add name=guru password=123 profile=guru
add name=siswa password=123 profile=siswa
/system clock
set time-zone-name=Asia/Makassar
/system identity
set name=UKK
/tool user-manager database
set db-path=user-manager
/tool user-manager profile profile-limitation
add from-time=0s limitation=rafi profile=2K till-time=23h59m59s weekdays=\
    sunday,monday,tuesday,wednesday,thursday,friday,saturday
/tool user-manager router
add coa-port=1700 customer=admin disabled=no ip-address=172.16.50.121 log=\
    auth-fail name=cipung shared-secret=123 use-coa=no
/tool user-manager user
add customer=admin disabled=no ipv6-dns=:: password=bebvd6 shared-users=1 \
    username=bebvd6 wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
add customer=admin disabled=no ipv6-dns=:: password=bebayz shared-users=1 \
    username=bebayz wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
add customer=admin disabled=no ipv6-dns=:: password=bebje4 shared-users=1 \
    username=bebje4 wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
add customer=admin disabled=no ipv6-dns=:: password=bebgd9 shared-users=1 \
    username=bebgd9 wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
add customer=admin disabled=no ipv6-dns=:: password=bebcy3 shared-users=1 \
    username=bebcy3 wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
add customer=admin disabled=no ipv6-dns=:: password=beb3gv shared-users=1 \
    username=beb3gv wireless-enc-algo=none wireless-enc-key="" wireless-psk=\
    ""
