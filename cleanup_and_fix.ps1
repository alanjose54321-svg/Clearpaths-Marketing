# cleanup_and_fix.ps1
# Run from the folder that contains index.html.
# Cleans img\ of stray files and downloads fixed office/marketing images.

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output "Working folder: $(Get-Location)"

# Ensure img folder exists
if (-not (Test-Path -Path .\img)) {
  New-Item -ItemType Directory -Path .\img | Out-Null
  Write-Output "Created folder: .\img"
}

Write-Output "`nCurrent files in ./img (before):"
Get-ChildItem .\img\* -Name | ForEach-Object { Write-Output " - $_" }

# Remove stray files (safe, will skip if not present)
Write-Output "`nRemoving stray files (if any):"
Remove-Item .\img\*.svg -Force -ErrorAction SilentlyContinue
Remove-Item .\img\index.html -Force -ErrorAction SilentlyContinue
Remove-Item .\img\canvasser1.jpg -Force -ErrorAction SilentlyContinue

Write-Output "`nDownloading curated office/marketing images (overwrites existing same-named files):"
$images = @{
  "img/hero.jpg"           = "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1600&q=80"
  "img/team.jpg"           = "https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=1200&q=80"
  "img/sample4.jpg"        = "https://images.unsplash.com/photo-1543269865-cbf427effbad?auto=format&fit=crop&w=1000&q=80"
  "img/canvasser2.jpg"     = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=1000&q=80"
  "img/event.jpg"          = "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80"
  "img/about.jpg"          = "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80"
  "img/careers.jpg"        = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80"
  "img/contact-office.jpg" = "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=1000&q=80"
}

foreach ($dest in $images.Keys) {
  $url = $images[$dest]
  Write-Output " -> $dest"
  try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Output "    Saved: $dest"
  } catch {
    Write-Output "    ERROR downloading $url -> $dest"
    Write-Output "    $($_.Exception.Message)"
  }
}

Write-Output "`nFinal files in ./img:"
Get-ChildItem .\img\* -Name | ForEach-Object { Write-Output " - $_" }

Write-Output "`nDone. Now open index.html in your browser and press Ctrl+F5 to refresh."