#!/bin/bash

#if [ "$#" -ne 2 ]; then
#    echo "syntax : rdmaserver <hca_id> <index_no>"
#    exit 0
#fi

whichos=$(cat /etc/os-release | grep -i SLES)
if [ -z "$whichos" ]
then
	echo "RHEL OS FOUND"
	yum install -y rdma-* infiniband* perftest* libibverbs* expect
else
	echo "SLES OS FOUND"
	zypper install -y rdma-* infiniband* perftest* libibverbs* expect
fi

echo "Please configure the repo as Dependency packages need to be installed"
echo "Please enter the Server Host IP where RDMA/IWARP should be tested"
read rdmaserverip
echo "Please enter the RDMA/IWARP configured HCA of the $(ibv_devinfo -l)"
read devintf
echo "Please enter the Ethernet GID Index default = 0"
read index

ibvdevinfo=$(ibv_devinfo -d $devintf | grep -i PORT_ACTIVE)
if [ -z "$ibvdevinfo" ]
then
      echo "$devintf is PORT_DOWN"
else
      echo "$devintf is PORT_ACTIVE"
fi
service firewalld stop
echo "ib_send_bw client starting"
echo "ib_send_bw $rdmaserverip --report_gbits -F -d $devintf -x $index"
#> /tmp/clienttest
ib_send_bw $rdmaserverip --report_gbits -F -d $devintf -x $index | grep "\#bytes" -A 1 | awk '{print $1}' #> /tmp/clienttest

#cat > /usr/bin/exp << EOF
##!/usr/bin/expect
#
#set timeout 20
#
#set cmd [lrange \$argv 1 end]
#set password [lindex \$argv 0]
#
#eval spawn \$cmd
#expect "assword:"
#send "\$password\\r";
#interact
#EOF
#chmod +x /usr/bin/exp

#exp dell01 scp -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' root@$rdmaserverip:/tmp/servertest /tmp/servertest
#exp dell01 scp -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' /tmp/clienttest root@$rdmaserverip:/tmp/clienttest

#test "$(md5sum /tmp/clienttest | cut -d' ' -f1)" == "$(md5sum /tmp/servertest | cut -d' ' -f1)" && (echo "rdmaclient"; echo "PASS") || (echo "rdmaclient"; echo "FAIL")




