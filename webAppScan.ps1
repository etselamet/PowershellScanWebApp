<#
  Ekrem Talha Selamet 131201015
  Bil 524: Web Application search on network
  Mailto: ekremtalhaselamet@gmail.com
#>
param(
  [int[]]$port = (80,443,8080,8081),
  [Parameter(mandatory=$true)]
  [string]$ipRange
)

#Print text info at terminal
function Display-Info($Info) {
  Write-Host -ForegroundColor GREEN $Info
}

function QueryPort ([string]$HostName, [string]$Port) {

  $socket = New-Object System.Net.Sockets.TCPClient
  $connected = ($socket.BeginConnect( $HostName, $Port, $Null, $Null )).AsyncWaitHandle.WaitOne(300)
  if ($connected -eq "True"){
  $stream = $socket.getStream()
  Start-Sleep -m 500; $text = ""
  $text = "$HostName : port $Port is open"
  $socket.Close()
  #Write-Host "$text"
  return $true
  } else {
    #Write-Host "$HostName : port $Port failed to connect"
    return $false
  }

}

function getHttpBanner($ip, $port){
$body = ""

# Disable certificate validation using certificate policy that ignores all certificates
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;

    public class IDontCarePolicy : ICertificatePolicy {
        public IDontCarePolicy() {}
        public bool CheckValidationResult(
            ServicePoint sPoint, X509Certificate cert,
            WebRequest wRequest, int certProb) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = new-object IDontCarePolicy

$ErrorActionPreference = "SilentlyContinue"
$request = [System.Net.WebRequest]::Create("http://" + $ip + ":" + $port)
$request.ContentType = "application/xml"
$request.Method = "POST"

# $request | Get-Member  for a list of methods and properties

try{
  $request.ServicePoint.MaxIdleTime = 5000;
  $request.ServicePoint.ConnectionLeaseTimeout = 5000;
    $requestStream = $request.GetRequestStream()
    $streamWriter = New-Object System.IO.StreamWriter($requestStream)
    $streamWriter.Write($body)
    $res = $request.GetResponse()
    $text = "Server Info: $($res.Server) `nProtocol Version: $($res.ProtocolVersion) `nLastModified: $($res.LastModified)"
}
catch{
  $text = "    not connect via HTTP"
}
finally{
    if ($null -ne $streamWriter) { $streamWriter.Dispose() }
    if ($null -ne $requestStream) { $requestStream.Dispose() }
}
$request.Abort()
return $text
}

$timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
$outFileName = $timestamp  + ".txt"
$OFS = "`r`n"

#user ipRange parse snand ipRange format is "XXX.XXX.XXX.XXX/XXXX"
$ipStart = $ipRange.Substring(0,$ipRange.LastIndexOf("."))
$range = [int]$ipRange.Substring($ipRange.IndexOf("/") + 1)
$lastElement = [int]$ipRange.Substring($ipRange.LastIndexOf(".") + 1, $ipRange.IndexOf("/") - ($ipRange.LastIndexOf(".") + 1))
$foundServer = 0
Display-Info "Searching start for $ipStart.$($lastElement) to $ipStart.$($lastElement + $range) with port: $port `n"

Get-Date | Out-File $outFileName
"Searching $ipStart.$($lastElement) to $ipStart.$($lastElement + $range) with port: $port `n" | Out-File -append $outFileName
For($i=0; $i -lt $range; $i++){
  $searchIp = "$ipStart.$($lastElement+$i)"
  Foreach ($p in $port){
    #Display-Info "Searching for $ipStart.$($lastElement+$i):$p"
    $TestPort = QueryPort $searchIp $p
    if($TestPort){
      $foundServer = $foundServer + 1
      $text = getHttpBanner $searchIp $p
      Display-Info "$($searchIp):$p is open"
      Display-Info "$text`n"
      "+++    $($searchIp):$p is open" | Out-File -append $outFileName
      "       $text" | Out-File -append $outFileName
    }else{#not active port
      "---    $($searchIp):$p is not open" | Out-File -append $outFileName
    }
  }
}

Display-Info "Search is over:`n$range ip and $($port.Length) port, total $($range * $($port.Length)) searched. `n$foundServer web app found. Look log file for detailed information."
"Search is over:`n$range ip and $($port.Length) port, total $($range * $($port.Length)) searched. `n$foundServer web app found." |Out-File -append $outFileName
