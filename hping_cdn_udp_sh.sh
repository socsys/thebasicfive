#!/bin/bash

sudoPW=""

#echo "2. hping UDP started"
echo $sudoPW | sudo -S hping3 --udp $1 -p $5 -c $2 | while read pong; do echo "$(date -u): $pong" >> ./$3/"hping_UDP_"$6"_"$4".log" 2>&1 ; done
