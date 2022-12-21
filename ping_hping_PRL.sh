#!/bin/bash

sudoPW=""

server="35.242.187.72"		#Google Server London

ping_duration=1
hping_duration=1
hping_port=4040
iteration=1
tracrt_cnt=100000
current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname

while [ $tracrt_cnt -gt 0 ]; do traceroute $server >> ./$dirname/"traceroute_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done &

while :
do
	current_time1=$(date -u "+%Y.%m.%d-%H.%M.%S")
	echo "--------------------->"."the current time ".$current_time1
	echo "1. Start ping and hping"
	bash ping_sh.sh $server $ping_duration $dirname $current_time &
	bash hping_sh.sh $server $hping_duration $dirname $current_time $hping_port &

	sleep 1
done
