## enum4linux
```
Scan for shares
enum4linux -A 10.11.1.5 > output file
```
## smbmap
```
Check OS version and patch
smbmap -H $IP -v
```
## crackmapexec
```
Check Hostname, domain, and OS
crackmapexec smb $IP
```
## impacket-smbserver
```
Create share that can be added using "net use * \\$AttackIP\Share"
impacket-smbserver $ShareName $LocalDir(can be .)
```