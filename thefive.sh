#!/bin/bash
sudoPW="snuc"

server="35.242.187.72"
ping_duration=600
hping_duration=300
hping_port=4040
tracrt_cnt=100
iperf_duration=300
output_cc_change_request=""

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname

echo "1. Start ping at Current Time : $current_time"

ping -c $ping_duration $server | while read pong; do echo "$(date): $pong" >> ./$dirname/"ping_"$current_time".log" ; done

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "2. Start hping at Current Time : $current_time"

echo $sudoPW | sudo -S hping3 -S $server -p $hping_port -c $hping_duration >> ./$dirname/"hping_"$current_time".log"

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "3. Start Traceroute at Current Time : $current_time"

while [ $tracrt_cnt -gt 0 ]; do traceroute $server >> ./$dirname/"traceroute_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "4. Start iperf UDP at Current Time : $current_time"

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_udp_"$current_time".pcap" &
tcpdump_pid=$!

iperf3 -c $server -i1 -t $iperf_duration -u -b300Mb -R >> ./$dirname/"iperf_udp_"$current_time".log"

echo $sudoPW | sudo -S kill $tcpdump_pid

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "5. Start iperf TCP CUBIC at Current Time : $current_time"
echo ".... Send request to the server to change the congestion control "

while [ "$output_cc_change_request" != "cubic" ]; do output_cc_change_request="$(python2.7 change_cc_client.py cubic)"; done

echo ".... The congestion control on the server side is successfully change."$output_cc_change_request

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_tcp_cubic_"$current_time".pcap" &
tcpdump_pid=$!

echo $sudoPW | sudo -S sysctl -w net.ipv4.tcp_congestion_control=$output_cc_change_request
iperf3 -c $server -i1 -t $iperf_duration -R >> ./$dirname/"iperf_tcp_cubic_"$current_time".log"

echo $sudoPW | sudo -S kill $tcpdump_pid

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "6. Start iperf TCP BBR at Current Time : $current_time"
echo ".... Send request to the server to change the congestion control "

while [ "$output_cc_change_request" != "bbr" ]; do output_cc_change_request="$(python2.7 change_cc_client.py bbr)"; done

echo ".... The congestion control on the server side is successfully change."$output_cc_change_request

echo $sudoPW | sudo -S tcpdump -i eno1 -s 96 -w ./$dirname/"iperf_tcp_bbr_"$current_time".pcap" &
tcpdump_pid=$!

echo $sudoPW | sudo -S sysctl -w net.ipv4.tcp_congestion_control=$output_cc_change_request
iperf3 -c $server -i1 -t $iperf_duration -R >> ./$dirname/"iperf_tcp_bbr_"$current_time".log"

echo $sudoPW | sudo -S kill $tcpdump_pid

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
echo "..... We are done now .. See you next hour. Time now is : $current_time"
