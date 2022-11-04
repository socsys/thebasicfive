#!/bin/bash

sudoPW="snuc"

server="35.242.187.72"		#Google Server London

ping_duration=2
hping_duration=2
hping_port=4040
tracrt_cnt=2

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname

while :
do
	current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
	echo "1. Start ping at Current Time : $current_time"
	ping -c $ping_duration $server | while read pong; do echo "$(date -u): $pong" >> ./$dirname/"ping_"$current_time".log" ; done

	current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
	echo "2. Start hping at Current Time : $current_time"
	echo $sudoPW | sudo -S hping3 -S $server -p $hping_port -c $hping_duration >> ./$dirname/"hping_"$current_time".log"

	tracrt_cnt=2
	current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
	echo "3. Start Traceroute at Current Time : $current_time"
	while [ $tracrt_cnt -gt 0 ]; do traceroute $server >> ./$dirname/"traceroute_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done

	sleep 1
	echo "--------------------->"
done
