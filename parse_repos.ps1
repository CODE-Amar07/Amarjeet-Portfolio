$raw = Get-Content 'C:\Users\amarj\.gemini\antigravity-ide\brain\fcac8b94-ead8-4129-ba65-a67dcc36de24\.system_generated\steps\252\content.md'
$jsonText = ($raw[8..($raw.Length - 1)]) -join "`n"
$items = ConvertFrom-Json $jsonText
foreach ($item in $items) {
    Write-Host "Name: $($item.name)"
    Write-Host "Description: $($item.description)"
    Write-Host "Language: $($item.language)"
    Write-Host "HTML URL: $($item.html_url)"
    Write-Host "Updated: $($item.updated_at)"
    Write-Host "---"
}
