Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile('d:\Portfolio website\robin.jpg')
Write-Output "Dimensions: $($img.Width) x $($img.Height)"
$img.Dispose()
