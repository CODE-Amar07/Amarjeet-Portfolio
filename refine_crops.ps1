Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

function Save-Crop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $source.Clone($rect, $source.PixelFormat)
    $crop.Save("d:\Portfolio website\assets\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Output "Saved $name.png"
}

# Clean project crops (avoid text below card)
Save-Crop 116 931 243 147 "project_alexander"
Save-Crop 377 1007 243 147 "project_trava"
Save-Crop 116 1184 243 147 "project_hebrew"
Save-Crop 377 1260 243 147 "project_robert"

# Review card widget
Save-Crop 496 429 124 78 "review_card"

$source.Dispose()
