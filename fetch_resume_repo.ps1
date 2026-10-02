$headers = @{ 'User-Agent' = 'Mozilla/5.0' }
try {
    $contents = Invoke-RestMethod -Uri 'https://api.github.com/repos/AMARJEETROUT/Resume/contents' -Headers $headers
    foreach ($c in $contents) {
        Write-Host "FILE: $($c.name) -> $($c.download_url)"
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
