#!/bin/bash

cmds=(
"uname -a"
"whoami"
"cat /etc/redhat-release"
"/lib/libc.so*"
"cat /proc/cpuinfo"
"cat /proc/meminfo"
"dmesg"
"/sbin/sysctl -a"
"cat /proc/net/netstat"
"mount"
"cat /proc/mounts"
"blockdev --report"
"rpcinfo -p"
"top -bc -n 1"
"ulimit -a"
)

for cmd in "${cmds[@]}"; do 
	echo "Running command: $cmd"
	${cmd}
done
