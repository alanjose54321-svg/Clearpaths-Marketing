# replace_images.ps1
# Replaces the site images in ./img with new office/sales/team photos.
# Makes timestamped backups first, safe & idempotent.
# Run from the folder that contains index.html (clearpath).

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output "Working folder: $(Get-Location)"
if (-not (Test-Path -Path .\img)) {
  New-Item -ItemType Directory -Path .\img | Out-Null
  Write-Output "Created folder: .\img"
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# List of image files the site uses that we'll replace (logo.png kept unchanged).
$targets = @(
  "img/hero.jpg",
  "img/team.jpg",
  "img/sample1.jpg",
  "img/sample2.jpg",
  "img/sample3.jpg",
  "img/sample4.jpg",
  "img/canvasser2.jpg",
  "img/event.jpg",
  "img/about.jpg",
  "img/careers.jpg",
  "img/contact-office.jpg"
)

# Backup existing targets (if present)
foreach ($t in $targets) {
  if (Test-Path $t) {
    $bak = "$t.bak.$timestamp"
    Copy-Item -Path $t -Destination $bak -Force
    Write-Output "Backed up $t -> $bak"
  }
}

# Map each target to an Unsplash image query (office / sales / team oriented)
$images = @{
  "img/hero.jpg"           = "https://source.unsplash.com/1600x900/?office,team,sales"
  "img/team.jpg"           = "https://source.unsplash.com/1200x800/?sales,team,meeting"
  "img/sample1.jpg"        = "https://source.unsplash.com/800x600/?team,meeting"
  "img/sample2.jpg"        = "https://source.unsplash.com/800x600/?brainstorm,team"
  "img/sample3.jpg"        = "https://source.unsplash.com/800x600/?office,coworking"
  "img/sample4.jpg"        = "https://source.unsplash.com/800x600/?marketing,team"
  "img/canvasser2.jpg"     = "https://source.unsplash.com/1000x800/?field,sales,door-to-door"
  "img/event.jpg"          = "https://source.unsplash.com/1200x800/?conference,event,team"
  "img/about.jpg"          = "https://source.unsplash.com/1200x800/?workspace,people,collaboration"
  "img/careers.jpg"        = "https://source.unsplash.com/800x600/?careers,office,team"
  "img/contact-office.jpg" = "https://source.unsplash.com/1000x800/?reception,office,desk"
}

Write-Output ""
foreach ($dest in $images.Keys) {
  $url = $images[$dest]
  Write-Output "Downloading -> $dest  (query: $url)"
  try {
    # source.unsplash.com returns redirects; Invoke-WebRequest will follow and save the final image.
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
Write-Output "Done. Open index.html and press Ctrl+F5 (or open in Incognito) to view locally."
Write-Output "Backups are available as *.bak.$timestamp in the img/ folder."
Write-Output ""
Write-Output "Notes:"
Write-Output " - These Unsplash queries return a fresh image per download. If you prefer a specific image, provide a local path or a direct image URL and I will give the exact copy command."
Write-Output " - I did NOT overwrite logo.png. If you want to replace the logo as well, run the extra command at the end of these instructions."