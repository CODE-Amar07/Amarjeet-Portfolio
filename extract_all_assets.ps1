Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

$cropTop = $source.Clone((New-Object System.Drawing.Rectangle(0, 0, 736, 650)), $source.PixelFormat)
$cropTop.Save('d:\Portfolio website\assets\hero_section.png', [System.Drawing.Imaging.ImageFormat]::Png)
$cropTop.Dispose()

# Now let's crop the exact 4 project cards cleanly:
# Card 1 image (top-left white card):
# x: 115, y: 931, w: 244, h: 156
$c1 = $source.Clone((New-Object System.Drawing.Rectangle(116, 931, 243, 156)), $source.PixelFormat)
$c1.Save('d:\Portfolio website\assets\project_alexander.png', [System.Drawing.Imaging.ImageFormat]::Png)
$c1.Dispose()

# Card 2 image (top-right white card):
# x: 377, y: 1007, w: 244, h: 156
$c2 = $source.Clone((New-Object System.Drawing.Rectangle(377, 1007, 243, 156)), $source.PixelFormat)
$c2.Save('d:\Portfolio website\assets\project_trava.png', [System.Drawing.Imaging.ImageFormat]::Png)
$c2.Dispose()

# Card 3 image (bottom-left white card):
# x: 115, y: 1184, w: 244, h: 156
$c3 = $source.Clone((New-Object System.Drawing.Rectangle(116, 1184, 243, 156)), $source.PixelFormat)
$c3.Save('d:\Portfolio website\assets\project_hebrew.png', [System.Drawing.Imaging.ImageFormat]::Png)
$c3.Dispose()

# Card 4 image (bottom-right white card):
# x: 377, y: 1260, w: 244, h: 156
$c4 = $source.Clone((New-Object System.Drawing.Rectangle(377, 1260, 243, 156)), $source.PixelFormat)
$c4.Save('d:\Portfolio website\assets\project_robert.png', [System.Drawing.Imaging.ImageFormat]::Png)
$c4.Dispose()

# Client logos bar crop:
# y: ~810 to 860, x: 110 to 626
$cLogos = $source.Clone((New-Object System.Drawing.Rectangle(110, 810, 516, 50)), $source.PixelFormat)
$cLogos.Save('d:\Portfolio website\assets\client_logos.png', [System.Drawing.Imaging.ImageFormat]::Png)
$cLogos.Dispose()

$source.Dispose()
Write-Output "Cropped all assets successfully!"
