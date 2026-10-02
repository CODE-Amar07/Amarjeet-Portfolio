Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')
$assetsDir = 'd:\Portfolio website\assets'
if (-not (Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir | Out-Null }

function Crop-Image($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $source.Clone($rect, $source.PixelFormat)
    $crop.Save((Join-Path $assetsDir "$name.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Output "Saved $name.png ($x, $y, $w, $h)"
}

# In robin.jpg:
# Width is 736. Left column cards are approximately x=115, width=245.
# Right column cards are approximately x=375, width=245.
# Let's crop Card 1 (Lawyer Alexander monitor mockup):
Crop-Image 115 925 245 145 "project1"

# Card 2 (Trava phone mockup):
Crop-Image 375 955 245 185 "project2"

# Card 3 (Hebrew Marketing laptop):
Crop-Image 115 1175 245 135 "project3"

# Card 4 (Robert Legal tablet):
Crop-Image 375 1245 245 140 "project4"

# Client avatars stack from hero:
Crop-Image 505 435 95 24 "avatars"

$source.Dispose()
