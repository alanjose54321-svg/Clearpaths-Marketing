# download_images.ps1
# Run this inside your project folder (the folder that contains index.html).
# It will create ./img if missing and download 5 curated images into:
#   img\hero.jpg, img\team.jpg, img\sample4.jpg, img\canvasser2.jpg, img\event.jpg
#
# NOTE:
# - This script uses Unsplash's Source URLs which return a suitable image for the query.
# - Each download may return a different image each time you run the script (randomized by query).
# - You need internet access. If you prefer fixed images, provide direct image URLs and I can update the script.

if (-not (Test-Path -Path .\img)) {
  New-Item -ItemType Directory -Path .\img | Out-Null
}

$images = @{
  "img/hero.jpg"       = "https://source.unsplash.com/1600x900/?community,outreach,people"
  "img/team.jpg"       = "https://source.unsplash.com/1200x800/?team,meeting,training"
  "img/sample4.jpg"    = "https://source.unsplash.com/800x600/?strategy,planning,marketing"
  "img/canvasser2.jpg" = "https://source.unsplash.com/800x600/?canvassing,volunteer,conversation"
  "img/event.jpg"      = "https://source.unsplash.com/1200x800/?community,event,activation"
}

foreach ($dest in $images.Keys) {
  $url = $images[$dest]
  Write-Output "Downloading: $url -> $dest"
  try {
    # Follow redirects and save
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Output "Saved $dest"
  } catch {
    Write-Output "Failed to download $url : $_"
  }
}

Write-Output "Done. Open index.html in your browser and press Ctrl+F5 to refresh."