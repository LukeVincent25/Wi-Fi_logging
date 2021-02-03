#! /bin/bash
# this file is to log basic data from a station's connection to an access point

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
	command="iw wlan0 station dump | grep signal: "
	result=$(eval "$command")
	echo $result
}



Main(){
	echo "checking if connected to an access point"
	IsConnected connectionStatus
	
	echo "Range?"
	read range
	
	echo "getting connection parameters"
	GetConnectionParameters
	
	echo "this is a csv file" >> logging_data1.csv
}

Main
