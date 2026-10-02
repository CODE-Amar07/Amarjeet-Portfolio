try {
    $l = [System.Net.Sockets.TcpListener]::Create(3005)
    $l.Start()
    Write-Host "Create(3005) works! DualMode: $($l.Server.DualMode)"
    $l.Stop()
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
