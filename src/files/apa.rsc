# February 19, 2025 - Script Configuration for RouterOS 6.49.13
# Software ID: 25LA-1ZC3
#
# Model: RB941-2nD
# Serial Number: HF0092BEW6A

# Wireless Configuration - Setting AP mode and SSID
/interface wireless
set [ find default-name=wlan1 ] disabled=no mode=ap-bridge ssid=UKK- hotspot-address=192.168.40.1

# VLAN Configuration
/interface vlan
add interface=ether2 name=VLAN10 vlan-id=10
add interface=ether2 name=VLAN20 vlan-id=20

# Wireless Security Profile
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

# Hotspot Profile Configuration
/ip hotspot profile
add dns-name=portalsmk.sch.id hotspot-address=192.168.40.1 login-by=http-chap name=hsprof1

# Hotspot User Profiles (Speed Limits)
/ip hotspot user profile
add name=kepalasekola rate-limit=512k
add name=guru rate-limit=256k
add name=siswa rate-limit=128k

# DHCP Pool Configuration
/ip pool
add name=hs-pool-6 ranges=192.168.40.10-192.168.40.50
add name=dhcp_pool1 ranges=192.168.10.10-192.168.10.50
add name=dhcp_pool2 ranges=192.168.20.10-192.168.20.50

# DHCP Server Setup
/ip dhcp-server
add address-pool=hs-pool-6 disabled=no interface=wlan1 lease-time=1h name=dhcp1
add address-pool=dhcp_pool1 disabled=no interface=VLAN10 name=dhcp2
add address-pool=dhcp_pool2 disabled=no interface=VLAN20 name=dhcp3

# Hotspot Configuration
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=wlan1 name=hotspot1 profile=hsprof1

# IP Address Configuration
/ip address
add address=192.168.10.1/24 interface=VLAN10 network=192.168.10.0
add address=192.168.20.1/24 interface=VLAN20 network=192.168.20.0
add address=192.168.30.1/24 interface=ether3 network=192.168.30.0
add address=192.168.40.1/24 interface=wlan1 network=192.168.40.0

# DHCP Client on ether1 (Receiving IP from ISP)
# Make sure DHCP client is correctly receiving IP address from the ISP.
# If this interface is connected to the internet, it should be enabled.
# Disable this client if you have static IP or another interface serving the internet connection.
/ip dhcp-client
add disabled=no interface=ether1

# DHCP Server Networks
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.20.0/24 gateway=192.168.20.1
add address=192.168.40.0/24 comment="Hotspot network" gateway=192.168.40.1

# DNS Configuration
/ip dns
set allow-remote-requests=yes

# Firewall Rules: Make sure the hotspot and masquerade rules are correctly configured for security
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment="Place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment="Place hotspot rules here" disabled=yes

# NAT Configuration: Proper masquerade for hotspot and internet access
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment="Place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment="Place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="Masquerade hotspot network" src-address=192.168.40.0/24
add action=masquerade chain=srcnat out-interface=ether1

# Hotspot User Configuration
/ip hotspot user
add name=kepalasekola profile=kepalasekola
add name=guru profile=guru
add name=siswa profile=siswa

# System Time and Identity Settings
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=UKK
