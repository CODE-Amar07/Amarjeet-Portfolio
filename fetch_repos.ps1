$headers = @{ 'User-Agent' = 'Mozilla/5.0' }
try {
    $repos = Invoke-RestMethod -Uri 'https://api.github.com/users/amarjeetrout/repos' -Headers $headers
    foreach ($r in $repos) {
        Write-Host "REPO: $($r.name)"
        Write-Host "DESC: $($r.description)"
        Write-Host "LANG: $($r.language)"
        Write-Host "URL: $($r.html_url)"
        Write-Host "FORK: $($r.fork)"
        Write-Host "STARS: $($r.stargazers_count)"
        Write-Host "---"
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
