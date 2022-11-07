#!/bin/bash


echo "1. Start ping "
ping -c $2  $1 | while read pong; do echo "$(date -u): $pong" >> ./$3/"ping_"$4".log" ; done
