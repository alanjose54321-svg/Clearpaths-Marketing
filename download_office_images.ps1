# download_office_images.ps1
# Run in your project folder (where index.html is).
# Creates ./img if missing and downloads office/marketing photos into:
# img\hero.jpg, img\team.jpg, img\sample4.jpg, img\canvasser2.jpg, img\event.jpg, img\about.jpg, img\contact-office.jpg

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not (Test-Path -Path .\img)) {
  New-Item -ItemType Directory -Path .\img | Out-Null
  Write-Output "Created folder: .\img"
}

$images = @{
  "img/hero.jpg"       = "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1600&q=80"    # office planning / team
  "img/team.jpg"       = "https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=1200&q=80"    # meeting / training
  "img/sample4.jpg"    = "https://images.unsplash.com/photo-1543269865-cbf427effbad?auto=format&fit=crop&w=1000&q=80"    # laptop / strategy
  "img/canvasser2.jpg" = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=1000&q=80"    # one-on-one discussion
  "img/event.jpg"      = "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80"    # workplace event
  "img/about.jpg"      = "https://images.unsplash.com/photo-1532614338840-ab30cf10ed35?auto=format&fit=crop&w=1200&q=80"    # collaborative desk work
  "img/contact-office.jpg" = "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=1000&q=80" # reception/office desk
}

foreach ($dest in $images.Keys) {
  $url = $images[$dest]
  Write-Output "Downloading -> $dest"
  try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Output "Saved: $dest"
  } catch {
    Write-Output "ERROR downloading $url -> $dest"
    Write-Output $_.Exception.Message
  }
}

Write-Output ""
Write-Output "Downloaded files in ./img:"
Get-ChildItem .\img\* -Name | ForEach-Object { Write-Output " - $_" }