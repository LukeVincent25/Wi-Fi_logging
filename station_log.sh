#! /bin/bash
# this file is to log basic data from a station's connection to an access point



#-----------------------------
# Defining Functions
#-----------------------------
IsConnected(){
	
	r=$(iwconfig | grep 'ESSID') > /dev/null
	str="off/any"
	if [[ "$str" == *"$r"* ]]; then
		echo "no connection. Ending Script"
		exit 1
		
	else
		echo "Station is connected to AP"
	fi
	echo $r
}

GetConnectionParameters(){
	# get ap signal strength
	command="iw wlan0 station dump | grep signal: "
	signal=$(eval "$command")
	
	# get tx bitrate MCS
	command="iw wlan0 station dump | grep 'tx bitrate:'"
	txMCS=$(eval "$command")
	
	# get rx bitrate MCS
	command="iw wlan0 station dump | grep 'rx bitrate:'"
	rxMCS=$(eval "$command")
	
	# get throughput
	command="iperf -c $server_ip -t 3 -u -b 100m | grep Mbits/sec"
	tp=$(eval "$command")
}

SetupHeader(){
	touch "./$fileName"
	echo "writing header ${header}"
	sed -i '1d' "./$fileName"
	echo "${header}" | cat - "./$fileName" > temp && mv temp "./$fileName"
}

RunTest(){
	
	for ((i=1; i<=$measurementCount; i++))
	do
		echo "performing test ${i}"
		echo "getting connection parameters"
		GetConnectionParameters
		echo "$range, $tp, $txMCS, $rxMCS, $signal" >> "./$fileName"
		sleep 1
	done
}

#-----------------------------
# Main Functions
#-----------------------------
Main(){
	#-----------------------------
	# Setting Variables
	#-----------------------------
	fileName='test.csv'
	header='Range (m), throughput (Mbps), tx bitrate, rx bitrate, signal (dbm)'
	server_ip='192.168.0.27'
	interval=1
	measurementCount=1
	
	#-----------------------------
	echo "checking if connected to an access point"
	IsConnected connectionStatus
	
	echo "Range?"
	read range
	
	
	SetupHeader
	RunTest	
}

Main
