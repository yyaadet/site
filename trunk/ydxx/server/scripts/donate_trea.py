#!/usr/local/bin/python

import socket
import struct
import sys


def donate(host, port, uid, trea_id):
	s = socket.socket()
	s.connect((host, port))

	b = struct.pack("!ii", uid, trea_id)
	h = struct.pack("!iiii", 16 + len(b), 901, -1, 0)

	s.sendall(h)
	s.sendall(b)

	resp = s.recv(16)
	(total, code, sid, mid) = struct.unpack("!iiii", resp)

	s.close()

	print "RESP %d" % code
	
	if code == 300:
		return 1

	return 0



if __name__ == '__main__':
	if len(sys.argv) != 5:
		print "Usage: donate_trea.py host port uid trea_id"
		sys.exit()

	host = sys.argv[1]
	port = int(sys.argv[2])
	uid = int(sys.argv[3])
	trea_id = int(sys.argv[4])

	succ = donate(host, port, uid, trea_id)

	if succ == 1:
		print "success."
	else:
		print "failed"
