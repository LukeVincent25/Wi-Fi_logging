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
}

#-----------------------------
# Main Functions
#-----------------------------
Main(){
	#-----------------------------
	# Setting Variables
	#-----------------------------
	fileName='logging_data1.csv'
	header='Range (m), tx bitrate, signal (dbm)'
	
	#-----------------------------
	echo "checking if connected to an access point"
	IsConnected connectionStatus
	
	echo "Range?"
	read range
	
	echo "getting connection parameters"
	GetConnectionParameters
	
	echo "writing header"
	sed -i '1d' "./$fileName"
	sed -i '1s/^/"$header"/' "./$fileName"
	
	
	echo "writing to log file"
	echo "$range, $txMCS, $signal" >> "./$fileName"
	
}

Main
