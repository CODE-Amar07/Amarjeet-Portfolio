Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

# Check Card 2 top:
for ($y = 940; $y -le 962; $y += 2) {
    $c = $img.GetPixel(420, $y)
    Write-Host ("Card 2 top scan y=" + $y + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Check bottom of Card 1:
for ($y = 1045; $y -le 1075; $y += 2) {
    $c = $img.GetPixel(200, $y)
    Write-Host ("Card 1 bot scan y=" + $y + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Check bottom of Card 2:
for ($y = 1115; $y -le 1145; $y += 2) {
    $c = $img.GetPixel(420, $y)
    Write-Host ("Card 2 bot scan y=" + $y + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Check bottom of Card 3:
for ($y = 1315; $y -le 1345; $y += 2) {
    $c = $img.GetPixel(200, $y)
    Write-Host ("Card 3 bot scan y=" + $y + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Check bottom of Card 4:
for ($y = 1380; $y -le 1415; $y += 2) {
    $c = $img.GetPixel(420, $y)
    Write-Host ("Card 4 bot scan y=" + $y + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Check horizontal bounds:
# Card 1 & 3: Left side
for ($x = 110; $x -le 125; $x++) {
    $c = $img.GetPixel($x, 920)
    Write-Host ("Col 1 Left scan x=" + $x + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}
# Card 1 & 3: Right side
for ($x = 350; $x -le 366; $x++) {
    $c = $img.GetPixel($x, 920)
    Write-Host ("Col 1 Right scan x=" + $x + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

# Card 2 & 4: Left side
for ($x = 370; $x -le 385; $x++) {
    $c = $img.GetPixel($x, 990)
    Write-Host ("Col 2 Left scan x=" + $x + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}
# Card 2 & 4: Right side
for ($x = 615; $x -le 630; $x++) {
    $c = $img.GetPixel($x, 990)
    Write-Host ("Col 2 Right scan x=" + $x + " R=" + $c.R + " G=" + $c.G + " B=" + $c.B)
}

$img.Dispose()
