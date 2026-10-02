Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

function Save-Crop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $source.Clone($rect, $source.PixelFormat)
    $crop.Save("d:\Portfolio website\assets\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Host "Saved $name.png ($x, $y, $w, $h)"
}

# The 4 cards with their complete containers and watermarks:
Save-Crop 115 892 244 182 "project_alexander"
Save-Crop 377 958 244 182 "project_trava"
Save-Crop 115 1155 244 182 "project_hebrew"
Save-Crop 377 1222 244 182 "project_robert"

# Blistex to Trava full logos strip (start from x=100 so B in Blistex is included!):
Save-Crop 100 812 536 48 "client_logos"

# Avatar stack & review badge:
Save-Crop 496 429 124 78 "review_card"

$source.Dispose()
