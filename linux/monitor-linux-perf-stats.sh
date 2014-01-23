#!/bin/bash

SUFFIX="nojournal-1000iops"
# $! - Last run background job

function gatherMachineDef {
	STATSFILE="machine-definition-${SUFFIX}.dat"
	echo "Capturing Machine Stats " > ${STATSFILE}

	cmds=("sudo /sbin/blockdev --report" "cat /proc/mounts"  "/bin/df -h")
	for i in "${cmds[@]}"; do 
		echo "Executing stats gather for -- $i"
		echo "--------- $i ---------" >> $STATSFILE
		$i >> $STATSFILE 2>&1 
	done

	echo "Stats gathered"
	cat $STATSFILE
}

function startSystemMonitors {
	#TODO: Add error checking and cleanup of processes
	nohup iostat -dmtxc 2 >> iostat-${SUFFIX}.dat &
	nohup pidstat -C mongod -dtru 2 >> pidstat-${SUFFIX}.dat &
	nohup sar -o sar-data-${SUFFIX}.dat 5 >> sar-${SUFFIX}.log &
	nohup mpstat -P ALL -u 5 >> mpstat-${SUFFIX}.dat &
	nohup top -b -d 5 >> top-${SUFFIX}.dat &
	nohup vmstat -aftmnwd -SM 2 >> vmstat-${SUFFIX}.dat &
	nohup free -ml -s2 >> free-${SUFFIX}.dat &
}

function startMongoMonitors {
	#TODO: Add error checking and cleanup of processes
	nohup ./bin/mongostat > mongostat-${SUFFIX}.dat 2>&1 &
}

gatherMachineDef

## Base run on a 500-IOPS dbpath
nohup ./bin/mongod --fork --logpath mongod-${SUFFIX}.log --profile 1 --dbpath /mongo/ --cpu

echo "Sleeping for 10 seconds before proceeding for monitoring" && sleep 10
startSystemMonitors

echo "Sleeping for 60 seconds before proceeding for monitoring mongostat" && sleep 60
startMongoMonitors

