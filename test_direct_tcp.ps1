try {
    $c = New-Object System.Net.Sockets.TcpClient
    $c.Connect('127.0.0.1', 3000)
    Write-Host "Connected via IPv4: $($c.Connected)"
    $stream = $c.GetStream()
    $req = "GET /index.html HTTP/1.1`r`nHost: 127.0.0.1:3000`r`nConnection: close`r`n`r`n"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($req)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()
    
    $buf = New-Object byte[] 4096
    $read = $stream.Read($buf, 0, $buf.Length)
    $resp = [System.Text.Encoding]::ASCII.GetString($buf, 0, $read)
    Write-Host "Response received:"
    Write-Host ($resp.Split("`r`n")[0..3] -join "`n")
    $c.Close()
} catch {
    Write-Host "TcpClient error: $($_.Exception.Message)"
}
