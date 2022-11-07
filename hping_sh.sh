#!/bin/bash

sudoPW="snuc"

echo "2. hping started"
echo $sudoPW | sudo -S hping3 -S $1 -p $5 -c $2 | while read pong; do echo "$(date -u): $pong" >> ./$3/"hping_"$4".log" ; done
