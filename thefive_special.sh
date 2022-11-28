#!/bin/bash
sudoPW="snuc"

server="starsurrey.duckdns.org"		#Google Server London
ping_duration=1200
hping_duration=1
hping_port=4040
tracrt_cnt=300
iperf_duration=300
count=1200
output_cc_change_request=""

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname


echo "1. Start ping at Current Time : $current_time"

ping -c $ping_duration $server | while read pong; do echo "$(date): $pong" >> ./$dirname/"ping_"$current_time".log" ; done &

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "2. Start hping at Current Time : $current_time"

#echo $sudoPW | sudo -S hping3 -S $server -p $hping_port -c $hping_duration >> ./$dirname/"hping_"$current_time".log" &

while [ $count -gt 0 ]; do /home/snuc/thebasicfive/hping_sh.sh $server $hping_duration $dirname $current_time $hping_port; sleep 1; ((count=count-1)); done &
hping_pid=$!

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "3. Start Traceroute at Current Time : $current_time"

while [ $tracrt_cnt -gt 0 ]; do traceroute $server >> ./$dirname/"traceroute_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done &

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "4. Start iperf UDP at current Time:".$current_time

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_udp_"$current_time".pcap" &
tcpdump_pid=$!

iperf3 -c $server -i1 -t 100 -u -b300Mb -R >> ./$dirname/"iperf_udp_"$current_time".log"

#echo $sudoPW | sudo -S kill -9 $tcpdump_pid
echo $sudoPW | sudo -S killall "tcpdump"

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "5. Start iperf TCP CUBIC at current Time: ".$current_time
echo ".... Send request to the server to change the congestion control "

while [ "$output_cc_change_request" != "cubic" ]; do output_cc_change_request="$(python2.7 /home/snuc/thebasicfive/change_cc_client.py cubic)"; done

echo ".... The congestion control on the server side is successfully change."$output_cc_change_request

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_tcp_cubic_"$current_time".pcap" &
tcpdump_pid=$!

echo $sudoPW | sudo -S sysctl -w net.ipv4.tcp_congestion_control=$output_cc_change_request
iperf3 -c $server -i1 -t $iperf_duration -R >> ./$dirname/"iperf_tcp_cubic_"$current_time".log"

#echo $sudoPW | sudo -S kill -9 $tcpdump_pid
echo $sudoPW | sudo -S killall "tcpdump"

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "6. Start iperf TCP BBR at current Time:".$current_time
echo ".... Send request to the server to change the congestion control "

while [ "$output_cc_change_request" != "bbr" ]; do output_cc_change_request="$(python2.7 /home/snuc/thebasicfive/change_cc_client.py bbr)"; done

echo ".... The congestion control on the server side is successfully change."$output_cc_change_request

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_tcp_bbr_"$current_time".pcap" &
tcpdump_pid=$!

echo $sudoPW | sudo -S sysctl -w net.ipv4.tcp_congestion_control=$output_cc_change_request
iperf3 -c $server -i1 -t $iperf_duration -R >> ./$dirname/"iperf_tcp_bbr_"$current_time".log"

#echo $sudoPW | sudo -S kill -9 $tcpdump_pid
echo $sudoPW | sudo -S killall "tcpdump"

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "7. Start iperf TCP Illinois at current Time:".$current_time
echo ".... Send request to the server to change the congestion control "

while [ "$output_cc_change_request" != "illinois" ]; do output_cc_change_request="$(python2.7 /home/snuc/thebasicfive/change_cc_client.py illinois)"; done

echo ".... The congestion control on the server side is successfully change."$output_cc_change_request

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_tcp_illinois_"$current_time".pcap" &
tcpdump_pid=$!

echo $sudoPW | sudo -S sysctl -w net.ipv4.tcp_congestion_control=$output_cc_change_request
iperf3 -c $server -i1 -t $iperf_duration -R >> ./$dirname/"iperf_tcp_illinois_"$current_time".log"

#echo $sudoPW | sudo -S kill -9 $tcpdump_pid
echo $sudoPW | sudo -S killall "tcpdump"

echo "ship the data to the server ...."
zip -r $dirname".zip" $dirname
scp -r $dirname".zip" snuc@starsurrey.duckdns.org:/home/snuc/results_alan
echo $sudoPW | rm -r $dirname".zip"

echo "......................................................................"
current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "..... We are done now .. See you next hour. Time now is : $current_time"
#echo $sudoPW | sudo -S kill $hping_pid
