param([int]$Port = 3000)

try {
    $ip = [System.Net.IPAddress]::Loopback
    $tcpListener = New-Object System.Net.Sockets.TcpListener($ip, $Port)
    $tcpListener.Start()
    Write-Output "TcpListener started successfully on port $Port"
    $tcpListener.Stop()
} catch {
    Write-Error $_
}
