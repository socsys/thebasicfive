#!/bin/bash
sudoPW=""

server="starsurrey-es.duckdns.org"		#Google Server Madrid
ping_duration=1500
hping_duration=1
hping_port=4040
tracrt_cnt=350
iperf_duration=3
count=1500
output_cc_change_request=""

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname


echo "1. Start ping at Current Time : $current_time"

ping -c $ping_duration $server | while read pong; do echo "$(date -u): $pong" >> ./$dirname/"ping_"$current_time".log" ; done &

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "2. Start hping at Current Time : $current_time"

#echo $sudoPW | sudo -S hping3 -S $server -p $hping_port -c $hping_duration >> ./$dirname/"hping_"$current_time".log" &

while [ $count -gt 0 ]; do /home/accord/thebasicfive/hping_sh.sh $server $hping_duration $dirname $current_time $hping_port; sleep 1; ((count=count-1)); done &
hping_pid=$!

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "3. Start Traceroute at Current Time : $current_time"

while [ $tracrt_cnt -gt 0 ]; do traceroute $server >> ./$dirname/"traceroute_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done &


echo "......................................................................"
current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "..... We are done now .. See you next hour. Time now is : $current_time"
#echo $sudoPW | sudo -S kill $hping_pid
