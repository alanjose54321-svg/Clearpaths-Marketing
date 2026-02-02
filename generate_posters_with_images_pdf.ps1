# generate_posters_auto_download.ps1
# Download free office/team images from multiple sources (with retries), create poster SVGs and convert to PDF.
# Run from your site folder, e.g. C:\Users\babyk\OneDrive\Desktop\clearpath
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Force using modern TLS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$now = Get-Date -Format "yyyyMMdd_HHmmss"
$posterDir = Join-Path (Get-Location) 'img\posters'
if (-not (Test-Path $posterDir)) { New-Item -ItemType Directory -Path $posterDir | Out-Null; Write-Output "Created folder: $posterDir" }

# Local paths
$a4Photo = Join-Path $posterDir "a4_photo.jpg"
$sqPhoto = Join-Path $posterDir "sq_photo.jpg"
$a4Svg = Join-Path $posterDir "clearpaths_hiring_poster_a4.svg"
$sqSvg = Join-Path $posterDir "clearpaths_hiring_poster_square.svg"
$a4Pdf = Join-Path $posterDir "clearpaths_hiring_poster_a4.pdf"
$sqPdf = Join-Path $posterDir "clearpaths_hiring_poster_square.pdf"

# Backup existing outputs
function BackupIfExists($p) { if (Test-Path $p) { Copy-Item -Path $p -Destination "$p.bak.$now" -Force; Write-Output "Backed up $p -> $p.bak.$now" } }
BackupIfExists $a4Photo; BackupIfExists $sqPhoto; BackupIfExists $a4Svg; BackupIfExists $sqSvg; BackupIfExists $a4Pdf; BackupIfExists $sqPdf

# Download helper with retries and User-Agent header
function Download-WithRetry {
  param(
    [string]$Url,
    [string]$OutFile,
    [int]$Attempts = 4,
    [int]$InitialDelaySec = 3
  )
  $headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117 Safari/537.36' }
  for ($i=1; $i -le $Attempts; $i++) {
    try {
      Write-Output "Attempt $i: downloading $Url ..."
      # Use -UseBasicParsing for compatibility with older PS (if available)
      Invoke-WebRequest -Uri $Url -OutFile $OutFile -Headers $headers -TimeoutSec 30 -UseBasicParsing
      Write-Output "Saved: $OutFile"
      return $true
    } catch {
      Write-Warning "Attempt $i failed: $($_.Exception.Message)"
      if ($i -lt $Attempts) { Start-Sleep -Seconds ($InitialDelaySec * $i) }
    }
  }
  return $false
}

# Candidate image source URLs (random / free)
# Order: Unsplash random query, LoremFlickr, Picsum, PlaceIMG
$a4Candidates = @(
  "https://source.unsplash.com/2400x1600/?office,team",
  "https://loremflickr.com/2400/1600/office,team",
  "https://picsum.photos/2400/1600",
  "https://placeimg.com/2400/1600/people"
)
$sqCandidates = @(
  "https://source.unsplash.com/1200x1200/?office,team",
  "https://loremflickr.com/1200/1200/office,team",
  "https://picsum.photos/1200/1200",
  "https://placeimg.com/1200/1200/people"
)

# Download function that tries candidates in order
function Try-DownloadFromCandidates {
  param($candidates, $outFile)
  foreach ($u in $candidates) {
    $ok = Download-WithRetry -Url $u -OutFile $outFile -Attempts 4 -InitialDelaySec 4
    if ($ok) { return $true }
    else { Write-Output "Failed to download from: $u - trying next candidate..." }
  }
  return $false
}

# If user already placed images manually, skip downloads
if (Test-Path $a4Photo) { Write-Output "A4 photo already exists: $a4Photo (skipping download)" } else {
  $okA4 = Try-DownloadFromCandidates -candidates $a4Candidates -outFile $a4Photo
  if (-not $okA4) {
    Write-Warning "Could not download an A4 image automatically. Please manually save an image as: $a4Photo and re-run this script."
  }
}
if (Test-Path $sqPhoto) { Write-Output "Square photo already exists: $sqPhoto (skipping download)" } else {
  $okSq = Try-DownloadFromCandidates -candidates $sqCandidates -outFile $sqPhoto
  if (-not $okSq) {
    Write-Warning "Could not download a square image automatically. Please manually save an image as: $sqPhoto and re-run this script."
  }
}

# If we don't have both images, stop and instruct the user
if (-not (Test-Path $a4Photo) -or -not (Test-Path $sqPhoto)) {
  Write-Output ""
  Write-Output "One or both images are missing. To continue, open the following URLs in your browser and Save As into this folder:"
  Write-Output "A4 candidates (open until you like one):"
  $a4Candidates | ForEach-Object { Write-Output "  $_" }
  Write-Output "Square candidates:"
  $sqCandidates | ForEach-Object { Write-Output "  $_" }
  Write-Output ""
  Write-Output "Save them as 'a4_photo.jpg' and 'sq_photo.jpg' in $posterDir, then re-run this script."
  exit 1
}

# Create SVGs embedding the local images (A4 & square)
$a4SvgContent = @"
<?xml version='1.0' encoding='UTF-8'?>
<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 2480 3508' width='2480' height='3508'>
  <defs>
    <linearGradient id='g-grad' x1='0' x2='0' y1='0' y2='1'>
      <stop offset='0' stop-color='#f7fdf9'/>
      <stop offset='1' stop-color='#e9f7f1'/>
    </linearGradient>
    <linearGradient id='overlay' x1='0' x2='0' y1='0' y2='1'>
      <stop offset='0' stop-color='#000' stop-opacity='0.10'/>
      <stop offset='1' stop-color='#000' stop-opacity='0.12'/>
    </linearGradient>
    <style><![CDATA[
      .title { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#ffffff; }
      .brand { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#042a28; }
      .copy { font-family: Roboto, Arial, sans-serif; fill:#324b47; }
    ]]></style>
  </defs>

  <rect width='100%' height='100%' fill='url(#g-grad)'/>
  <rect x='0' y='60' width='2480' height='260' fill='#0A7A57'/>
  <text x='1240' y='220' font-size='120' text-anchor='middle' class='title' letter-spacing='4'>WE'RE HIRING</text>

  <g transform='translate(150,360)'>
    <image href='$($a4Photo -replace "\\","/")' x='1100' y='0' width='930' height='680' preserveAspectRatio='xMidYMid slice' />
    <rect x='1100' y='0' width='930' height='680' fill='url(#overlay)'/>
    <text x='20' y='120' font-size='86' class='brand'>CLEARPATHS MARKETING</text>
    <text x='20' y='170' font-size='34' class='copy'>Ethical, people‑first fundraising & outreach that scales</text>
  </g>

  <g transform='translate(150,620)'>
    <rect x='0' y='0' width='2080' height='1220' rx='18' fill='#ffffff' stroke='#e6f3ef' stroke-width='2' />
    <text x='40' y='110' font-size='54' class='brand'>JOB: Brand Ambassador — Sales Associate</text>
    <text x='40' y='170' font-size='28' class='copy'>We hire friendly, trained ambassadors to represent mission-led partners across public and event locations.</text>

    <g transform='translate(40,220)'>
      <g transform='translate(0,0)'>
        <circle cx='32' cy='32' r='28' fill='#0A7A57'/>
        <text x='76' y='42' font-size='30' class='copy'>Locations: Multiple (specify availability)</text>
      </g>
      <g transform='translate(0,110)'>
        <rect x='0' y='0' width='64' height='64' rx='12' fill='#FF7A50'/>
        <text x='76' y='42' font-size='30' class='copy'>Hours: Mon–Fri • 12:30 PM – 8:30 PM</text>
      </g>
      <g transform='translate(0,220)'>
        <rect x='0' y='0' width='64' height='64' rx='12' fill='#0A7A57'/>
        <text x='76' y='42' font-size='30' class='copy'>$800 – $1,200+ / week (base + uncapped incentives)</text>
      </g>
    </g>

    <g transform='translate(40,520)'>
      <text x='0' y='0' font-size='40' class='brand'>WHY JOIN US?</text>
      <g transform='translate(0,40)' font-size='30' class='copy'>
        <text x='0' y='60'>• Guaranteed base pay + uncapped incentives</text>
        <text x='0' y='110'>• Paid weekly (every Friday)</text>
        <text x='0' y='160'>• Paid training and on-site supervisors</text>
        <text x='0' y='210'>• Paid travel opportunities and gas allowance</text>
        <text x='0' y='260'>• Free on-site parking where available</text>
      </g>
    </g>

    <g transform='translate(40,980)'>
      <rect x='0' y='0' width='1980' height='200' rx='12' fill='#f3f8f6' />
      <text x='32' y='70' font-size='34' class='brand'>TO APPLY</text>
      <text x='32' y='120' font-size='30' class='copy'>Email resume to <tspan font-weight='700'>marketingclearpaths@gmail.com</tspan></text>
      <text x='32' y='160' font-size='28' class='copy'>Or visit: <tspan font-weight='700'>clearpathsmarketing.com</tspan> • Call: <tspan font-weight='700'>705‑888‑2065</tspan></text>
    </g>
  </g>

  <rect x='0' y='3200' width='2480' height='200' fill='#042a28'/>
  <text x='1240' y='3340' font-size='40' text-anchor='middle' fill='#fff'>Visit: clearpathsmarketing.com  •  Email: marketingclearpaths@gmail.com</text>
</svg>
"@

$sqSvgContent = @"
<?xml version='1.0' encoding='UTF-8'?>
<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 1200' width='1200' height='1200'>
  <defs>
    <linearGradient id='sq-grad' x1='0' x2='0' y1='0' y2='1'>
      <stop offset='0' stop-color='#f7fdf9'/>
      <stop offset='1' stop-color='#e9f7f1'/>
    </linearGradient>
    <linearGradient id='sq-overlay' x1='0' x2='0' y1='0' y2='1'>
      <stop offset='0' stop-color='#000' stop-opacity='0.10'/>
      <stop offset='1' stop-color='#000' stop-opacity='0.12'/>
    </linearGradient>
    <style><![CDATA[
      .title { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#ffffff; }
      .brand { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#042a28; }
      .copy { font-family: Roboto, Arial, sans-serif; fill:#324b47; }
    ]]></style>
  </defs>

  <rect width='100%' height='100%' fill='url(#sq-grad)'/>
  <rect x='0' y='0' width='1200' height='140' fill='#0A7A57'/>
  <text x='600' y='100' font-size='56' text-anchor='middle' fill='#fff' font-family='Poppins, Arial, sans-serif' font-weight='700'>WE'RE HIRING</text>

  <text x='70' y='210' font-size='44' class='brand'>CLEARPATHS MARKETING</text>
  <text x='70' y='260' font-size='20' class='copy'>Ethical, people-first fundraising & outreach</text>

  <image href='$($sqPhoto -replace "\\","/")' x='600' y='300' width='520' height='520' preserveAspectRatio='xMidYMid slice' />
  <rect x='600' y='300' width='520' height='520' fill='url(#sq-overlay)'/>

  <rect x='60' y='300' width='520' height='480' rx='12' fill='#fff' stroke='#e6f3ef'/>
  <text x='90' y='360' font-size='28' class='brand'>Brand Ambassador — Sales Associate</text>
  <text x='90' y='400' font-size='20' class='copy'>Hours: Mon–Fri • 12:30 PM – 8:30 PM</text>
  <text x='90' y='430' font-size='20' class='copy'>$800 – $1,200+ / week (base + uncapped incentives)</text>

  <text x='90' y='500' font-size='24' class='brand'>Why join?</text>
  <g transform='translate(90,520)' font-size='18' class='copy'>
    <text y='28'>• Paid weekly (every Friday)</text>
    <text y='58'>• Paid training & supervision</text>
    <text y='88'>• Travel allowance & free parking (where available)</text>
  </g>

  <rect x='90' y='760' width='1020' height='90'*
