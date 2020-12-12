#!/bin/bash
yum install -y rdma-* opa-* *opensm*
yum groupinstall -y "Infiniband Support"
systemctl enable rdma.service
systemctl enable opensm.service
systemctl enable opafm.service
systemctl start rdma.service
systemctl start opensm.service
systemctl start opafm.service
cat > /etc/sysconfig/network-scripts/ifcfg-ib0 << EOF
#!/bin/bash
TYPE=infiniband
DEVICE=ib0
NAME=ib0
IPADDR=100.98.1.2
NETMASK=255.255.255.0
GATEWAY=100.98.1.1
ONBOOT=YES
BOOTPROTO=static
STARTMODE=auto
EOF
chmod +x /etc/sysconfig/network-scripts/ifcfg-ib0

opainfo
ifup ib0
