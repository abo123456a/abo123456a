# jan/17/2025 06:27:43 by RouterOS 6.49.17
# software id = 68H0-PCE6
#
# model = RB941-2nD
# serial number = D1130D39D1D3
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no mode=ap-bridge \
    ssid=UKK_32
/interface vlan
add interface=ether2 name=VLAN-10 vlan-id=10
add interface=ether2 name=VLAN-20 vlan-id=20
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=portalsmk.sch.id hotspot-address=192.168.40.1 name=hsprof1
/ip hotspot user profile
add name="kepala sekolah" rate-limit=512k
add name=guru rate-limit=456k
add name=siswa rate-limit=128k
/ip pool
add name=dhcp_pool0 ranges=192.168.10.10-192.168.10.50
add name=dhcp_pool2 ranges=192.168.30.2
add name=hs-pool-6 ranges=192.168.40.10-192.168.40.50
add name=dhcp_pool4 ranges=192.168.20.10-192.168.20.50
add name=dhcp_pool5 ranges=192.168.30.2
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=VLAN-10 name=dhcp1
add address-pool=hs-pool-6 disabled=no interface=wlan1 lease-time=1h name=\
    dhcp4
add address-pool=dhcp_pool4 disabled=no interface=VLAN-20 name=dhcp2
add address-pool=dhcp_pool5 disabled=no interface=ether3 name=dhcp3
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=wlan1 name=hotspot1 profile=\
    hsprof1
/ip address
add address=192.168.10.1/24 interface=VLAN-10 network=192.168.10.0
add address=192.168.20.1/24 interface=VLAN-20 network=192.168.20.0
add address=192.168.30.1/30 interface=ether3 network=192.168.30.0
add address=192.168.40.1/24 interface=wlan1 network=192.168.40.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 domain=VLAN-10 gateway=192.168.10.1
add address=192.168.20.0/24 domain=VLAN-20 gateway=192.168.20.1
add address=192.168.30.0/30 gateway=192.168.30.1
add address=192.168.40.0/30 gateway=192.168.40.1
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
add action=masquerade chain=srcnat out-interface=ether1
/ip hotspot user
add name=admin
add name=kepalasekolah password=123 profile="kepala sekolah"
add name=guru password=456 profile=guru
add name=siswa password=789 profile=siswa
