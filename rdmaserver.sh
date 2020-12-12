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
echo "ib_send_bw server starting"
#> /tmp/servertest
ib_send_bw -d $devintf -x $index | grep "\#bytes" -A 1 | awk '{print $1}' #> /tmp/servertest


#test "$(md5sum /tmp/clienttest | cut -d' ' -f1)" == "$(md5sum /tmp/servertest | cut -d' ' -f1)" && (echo "rdmaserver"; echo "PASS") || (echo "rdmaserver"; echo "FAIL")





