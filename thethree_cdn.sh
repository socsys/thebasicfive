sudoPW=""

aws_servers=("15.228.145.251"  "16.170.222.13"  "18.132.192.35"  "35.72.3.229"  "13.236.5.155"  "3.101.29.65"  "44.202.98.59")
aws_servers_names=("SaoPaulo" "Stockholm" "London" "Tokyo" "Sydney" "NorthCalifornia" "NorthVirginia")
ping_duration=36000
hping_duration=1
hping_port=4040
tracrt_cnt=1000
count1=36000
count2=36000
count3=36000
count4=36000
count5=36000
count6=36000

countu1=36000
countu2=36000
countu3=36000
countu4=36000
countu5=36000
countu6=36000

current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
dirname="results".$current_time
mkdir $dirname

echo "1. Start ping at Current Time : $current_time"

for server in ${!aws_servers[@]}; do
  ping -c $ping_duration ${aws_servers[$server]} | while read pong; do echo "$(date -u): $pong" >> ./$dirname/"ping_"${aws_servers_names[$server]}"_"$current_time".log" ; done & 
done


while [ $count1 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[0]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[0]}; sleep 1; ((count1=count1-1)); done &
while [ $count2 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[1]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[1]}; sleep 1; ((count2=count2-1)); done &
while [ $count3 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[2]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[2]}; sleep 1; ((count3=count3-1)); done &
while [ $count4 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[3]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[3]}; sleep 1; ((count4=count4-1)); done &
while [ $count5 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[4]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[4]}; sleep 1; ((count5=count5-1)); done &
while [ $count6 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[5]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[5]}; sleep 1; ((count6=count6-1)); done &
while [ $count7 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[6]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[6]}; sleep 1; ((count7=count7-1)); done &


while [ $countu1 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[0]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[0]}; sleep 1; ((countu1=countu1-1)); done &
while [ $countu2 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[1]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[1]}; sleep 1; ((countu2=countu2-1)); done &
while [ $countu3 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[2]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[2]}; sleep 1; ((countu3=countu3-1)); done &
while [ $countu4 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[3]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[3]}; sleep 1; ((countu4=countu4-1)); done &
while [ $countu5 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[4]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[4]}; sleep 1; ((countu5=countu5-1)); done &
while [ $countu6 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[5]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[5]}; sleep 1; ((countu6=countu6-1)); done &
while [ $countu7 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[6]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[6]}; sleep 1; ((countu7=countu7-1)); done &

#for server in ${!aws_servers[@]}; do
#  while [ $count -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_tcp_sh.sh ${aws_servers[$server]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[$server]}; sleep 1; ((count=count-1)); done &
#done


#for server in ${!aws_servers[@]}; do
#  while [ $count2 -gt 0 ]; do /home/accord/thebasicfive/hping_cdn_udp_sh.sh ${aws_servers[$server]} $hping_duration $dirname $current_time $hping_port ${aws_servers_names[$server]}; sleep 1; ((count2=count2-1)); done &
#done


#current_time=$(date -u "+%Y.%m.%d-%H.%M.%S")
#echo "4. Start Traceroute at Current Time : $current_time"

#echo $sudoPW | sudo -S tcpdump -i wlp6s0 -s 96 -w ./$dirname/"tcpdump_traceroute_"$current_time".pcap" &
#tcpdump_pid=$!

#for server in ${!aws_servers[@]}; do
#  while [ $tracrt_cnt -gt 0 ]; do traceroute ${aws_servers[$server]} >> ./$dirname/"traceroute_"${aws_servers_names[$server]}"_"$current_time".log"; ((tracrt_cnt=tracrt_cnt-1)); done &
#done


#sleep 25000
#echo $sudoPW | sudo -S killall "tcpdump"
