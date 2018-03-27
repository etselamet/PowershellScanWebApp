# PowershellScanWebApp
Powershell script for scanning web application on given ip range.

# Usage
This script is compatible Powershell 2.0 and higher versions. You can run with powershell like usual way.
```
PS C:\user> .\webAppScan.ps1 -ipRange XXX.XXX.XXX.XXX/XX -port XX,XX,XX
```
Example command:
```
PS C:\user> .\webAppScan.ps1 -ipRange 192.168.10.100/50 -port 80,81,443,8080
```
You can by-pass execution policy with
```
PS C:\user> PowerShell.exe -ExecutionPolicy Bypass -File .\webAppScan.ps1
```
Script takes two argument: ipRange and port. 

ipRange specifies the IP addresses to be scanned.
For example: "-ipRange 192.168.10.100/50" means scan with range of 192.168.10.100 to 192.168.10.150 .

port is optional. Default scan ports are 80, 443, 8080 and 8081. If you give "-port 80". Script will scan only 80 port, or "-port 80, 1010 and 445", then script only will scan 80, 1010 and 445 ports.

After scanning, script creates (timestamp).txt file for detailed information about process. Log file consist of open or close information about scanning IP and port adress and if there is a web application running on this port, script will exract server information, protocol version and last modified date otomatically.
