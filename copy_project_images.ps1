$brain = 'C:\Users\amarj\.gemini\antigravity-ide\brain\fcac8b94-ead8-4129-ba65-a67dcc36de24'
$assets = 'd:\Portfolio website\assets'

Copy-Item (Join-Path $brain 'project_weather_1790941680737.jpg') (Join-Path $assets 'project_weather.jpg') -Force
Copy-Item (Join-Path $brain 'project_quiz_1790941743982.jpg') (Join-Path $assets 'project_quiz.jpg') -Force
Copy-Item (Join-Path $brain 'project_ocac_1790941908357.jpg') (Join-Path $assets 'project_ocac.jpg') -Force
Copy-Item (Join-Path $brain 'project_technochanet_1790942153128.jpg') (Join-Path $assets 'project_technochanet.jpg') -Force

Write-Host "Copied all 4 project images to assets successfully!"
Get-ChildItem $assets | Select-Object Name, Length
