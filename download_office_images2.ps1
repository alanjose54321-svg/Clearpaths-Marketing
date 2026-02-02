# download_office_images2.ps1
# Run this from the folder that contains index.html.
# Creates ./img if missing, downloads 8 office/marketing photos into img\,
# and prints a final list. Safe and idempotent.

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output "Working folder: $(Get-Location)"

if (-not (Test-Path -Path .\img)) {
  New-Item -ItemType Directory -Path .\img | Out-Null
  Write-Output "Created folder: .\img"
}

$images = @{
  "img/hero.jpg"           = "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1600&q=80"
  "img/team.jpg"           = "https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=1200&q=80"
  "img/sample4.jpg"        = "https://images.unsplash.com/photo-1543269865-cbf427effbad?auto=format&fit=crop&w=1000&q=80"
  "img/canvasser2.jpg"     = "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=1000&q=80"
  "img/event.jpg"          = "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80"
  "img/about.jpg"          = "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1200&q=80"
  "img/careers.jpg"        = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80"
  "img/contact-office.jpg" = "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=1000&q=80"
}

Write-Output ""
foreach ($dest in $images.Keys) {
  $url = $images[$dest]
  Write-Output "Downloading -> $dest"
  try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Output "Saved: $dest"
  } catch {
    Write-Output "ERROR downloading $url -> $dest"
    Write-Output "  $($_.Exception.Message)"
  }
}

Write-Output ""
Write-Output "Final files in ./img:"
Get-ChildItem .\img\* -Name | ForEach-Object { Write-Output " - $_" }

Write-Output ""
Write-Output "Done. Now open index.html and press Ctrl+F5. If anything failed, copy the PowerShell output and paste it here."