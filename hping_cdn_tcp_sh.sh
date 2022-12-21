#!/bin/bash

sudoPW=""

#echo "2. hping TCP started"
echo $sudoPW | sudo -S hping3 -S $1 -p $5 -c $2 | while read pong; do echo "$(date -u): $pong" >> ./$3/"hping_TCP_"$6"_"$4".log" 2>&1 ; done
