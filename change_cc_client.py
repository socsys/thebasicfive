import socket
import sys
import json
import re

UDP_IP = "starsurrey-es.duckdns.org"
UDP_PORT = 1501

changeRequest = {"sTerminal":"bcn's Node", "cc":str(sys.argv[1])}
changeRequest_ = json.dumps(changeRequest)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.sendto(changeRequest_, (UDP_IP, UDP_PORT))

while True:
    data, addr = sock.recvfrom(1024)
    #print("received message: %s" % data)

    d = re.split('= |  ', data)
    if d[1].strip() == changeRequest["cc"]:
	print d[1].strip()
    	exit()
