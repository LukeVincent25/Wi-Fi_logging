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
	command="iperf -c $ip"
	tp=$(eval "$command")
}

#-----------------------------
# Main Functions
#-----------------------------
Main(){
	#-----------------------------
	# Setting Variables
	#-----------------------------
	fileName='logging_data2.csv'
	header='Range (m), throughput (Mbps), tx bitrate, rx bitrate, signal (dbm)'
	
	#-----------------------------
	echo "checking if connected to an access point"
	IsConnected connectionStatus
	
	echo "Range?"
	read range
	
	echo "getting connection parameters"
	GetConnectionParameters
	
	touch "./$fileName"
	echo "writing header ${header}"
	sed -i '1d' "./$fileName"
	echo "${header}" | cat - "./$fileName" > temp && mv temp "./$fileName"
	
	
	echo "writing to log file"
	echo "$range, $tp, $txMCS, $rxMCS, $signal" >> "./$fileName"
	
}

Main
