try {
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:3005/")
    $listener.Start()
    Write-Output "HttpListener works on localhost!"
    $listener.Stop()
} catch {
    Write-Output ("HttpListener failed: " + $_.Exception.Message)
}
