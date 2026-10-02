Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Bitmap]::FromFile('d:\Portfolio website\robin.jpg')

# Let's crop full cards:
# Card 1 container:
$rect1 = New-Object System.Drawing.Rectangle(114, 605, 246, 120) # wait, let's find the exact card
# Let's crop vertical slices to find exact y of projects:
$crop1 = $source.Clone((New-Object System.Drawing.Rectangle(110, 600, 520, 850)), $source.PixelFormat)
$crop1.Save('d:\Portfolio website\assets\projects_section.png', [System.Drawing.Imaging.ImageFormat]::Png)
$crop1.Dispose()
$source.Dispose()
Write-Output "Saved projects_section.png"
