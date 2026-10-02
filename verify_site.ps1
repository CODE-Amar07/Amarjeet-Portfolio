$urls = @(
    "http://localhost:3000/",
    "http://localhost:3000/style.css",
    "http://localhost:3000/script.js",
    "http://localhost:3000/assets/project_weather.jpg",
    "http://localhost:3000/assets/project_quiz.jpg",
    "http://localhost:3000/assets/project_ocac.jpg",
    "http://localhost:3000/assets/project_technochanet.jpg",
    "http://localhost:3000/frames/frame_0001.png",
    "http://localhost:3000/frames/frame_0100.png",
    "http://localhost:3000/frames/frame_0192.png"
)

$allOk = $true
foreach ($u in $urls) {
    try {
        $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 5
        Write-Host "OK ($($r.StatusCode)): $u [Size: $($r.Content.Length) bytes]"
    } catch {
        Write-Host "FAIL: $u -> $($_.Exception.Message)"
        $allOk = $false
    }
}

if ($allOk) {
    Write-Host "`nAll tested assets returned successfully with 200 OK!"
} else {
    Write-Host "`nSome assets failed to load!"
}
