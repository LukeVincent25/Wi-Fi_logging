#! /bin/ash
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
	command="iw wlan0 station dump | grep signal: -m 1"
	signal=$(eval "$command")
	
	# get tx bitrate MCS
	command="iw wlan0 station dump | grep 'tx bitrate:'"
	txMCS=$(eval "$command")
	
	# get rx bitrate MCS
	command="iw wlan0 station dump | grep 'rx bitrate:'"
	rxMCS=$(eval "$command")
	
	# tcp get throughput
	command="iperf -c $server_ip -t 3 | grep Mbits/sec"
	tcp_tp=$(eval "$command")
	
	# udp get throughput
	command="iperf -c $server_ip -t 3 -u -b 100m | grep Mbits/sec -m 1"
	udp_tp=$(eval "$command")
	
	# get tx power level
	command="iwconfig wlan0 | grep -E -o '.{0,0}Tx-Power.{0,8}'"
	txpower=$(eval "$command")
}

SetupHeader(){
	touch "./$fileName"
	echo "writing header ${header}"
	sed -i '1d' "./$fileName"
	echo "${header}" | cat - "./$fileName" > temp && mv temp "./$fileName"
}

RunTest(){
	
	echo "performing test ${i}"
	echo "getting connection parameters"
	GetConnectionParameters
	echo "$range, $tcp_tp, $udp_tp, $txpower, $txMCS, $rxMCS, $signal" >> "./$fileName"
	
}

#-----------------------------
# Main Functions
#-----------------------------
Main(){
	#-----------------------------
	# Setting Variables
	#-----------------------------
	fileName='txpower_test1.csv'
	header='Range (m), TCP throughput (Mbps), UDP throughput (Mbps) max 100 Mbps, TX Power (dbm), tx bitrate, rx bitrate, signal (dbm), , '
	server_ip='192.168.0.28'
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
