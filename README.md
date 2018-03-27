# PowershellScanWebApp
Powershell script for scanning web application on given ip range.

## Usage
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

Script scans given IP and port adresses and if port is open, script try to connect with a web-request. After scanning, script creates (timestamp).txt file for detailed information about process. Report file consist of open or close information about scanning IP and port adress and if there is a web application running on this port, script will exract server information, protocol version and last modified date otomatically.

## Example report file format

```
27 March 2018 Salı 16:21:43
Searching 192.168.61.125 to 192.168.61.150 with port: 80 443 8080 8081
---    192.168.61.129:8081 is not open
+++    192.168.61.130:80 is open
       Server Info: Apache/2.4.29 (Debian) 
       Protocol Version: 1.1 
       LastModified: 11/09/2017 16:39:36
---    192.168.61.130:443 is not open
---    192.168.61.130:8080 is not open
Search is over: 25 ip and 4 port, total 100 searched. 1 web app found.
```
