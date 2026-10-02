Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

# Let's crop exact white card containers (w: 244, h: ~135)
function Save-Clean-Card($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $source.Clone($rect, $source.PixelFormat)
    $crop.Save("d:\Portfolio website\assets\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
}

Save-Clean-Card 116 931 243 138 "project_alexander"
Save-Clean-Card 377 1007 243 138 "project_trava"
Save-Clean-Card 116 1184 243 138 "project_hebrew"
Save-Clean-Card 377 1260 243 138 "project_robert"

$source.Dispose()
Write-Output "Clean cards saved!"
