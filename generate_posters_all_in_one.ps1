<# 
generate_posters_all_in_one.ps1
Place this file in: C:\Users\babyk\OneDrive\Desktop\clearpath

What it does:
- Ensures img\posters exists
- If a4_photo.jpg / sq_photo.jpg are missing it attempts to download free office/team images
  from multiple public sources (with retries and a browser-like User-Agent)
- Creates two SVG posters (A4 print + square social) embedding the images
- Converts the SVGs to PDFs using Inkscape (preferred) or ImageMagick (fallback)
- Opens the generated PDFs when finished
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Use TLS 1.2 for downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$now = (Get-Date).ToString('yyyyMMdd_HHmmss')
$root = (Get-Location)
$posterDir = Join-Path $root 'img\posters'
if (-not (Test-Path $posterDir)) { New-Item -ItemType Directory -Path $posterDir | Out-Null; Write-Output "Created: $posterDir" }

# Local filenames
$a4Photo = Join-Path $posterDir 'a4_photo.jpg'
$sqPhoto = Join-Path $posterDir 'sq_photo.jpg'
$a4Svg   = Join-Path $posterDir 'clearpaths_hiring_poster_a4.svg'
$sqSvg   = Join-Path $posterDir 'clearpaths_hiring_poster_square.svg'
$a4Pdf   = Join-Path $posterDir 'clearpaths_hiring_poster_a4.pdf'
$sqPdf   = Join-Path $posterDir 'clearpaths_hiring_poster_square.pdf'

# Backup existing outputs
function Backup-IfExists($path) {
  if (Test-Path $path) {
    Copy-Item -Path $path -Destination "$path.bak.$now" -Force
    Write-Output "Backed up $path -> $path.bak.$now"
  }
}
Backup-IfExists $a4Photo; Backup-IfExists $sqPhoto; Backup-IfExists $a4Svg; Backup-IfExists $sqSvg; Backup-IfExists $a4Pdf; Backup-IfExists $sqPdf

# Download helper with retries and browser-like User-Agent
function Download-WithRetry {
  param(
    [Parameter(Mandatory=$true)] [string]$Url,
    [Parameter(Mandatory=$true)] [string]$OutFile,
    [int]$Attempts = 4,
    [int]$InitialDelaySec = 3
  )
  $headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117 Safari/537.36' }
  for ($i = 1; $i -le $Attempts; $i++) {
    try {
      Write-Output "Attempt $i: downloading $Url ..."
      Invoke-WebRequest -Uri $Url -OutFile $OutFile -Headers $headers -TimeoutSec 30 -UseBasicParsing
      if (Test-Path $OutFile) { Write-Output "Saved: $OutFile"; return $true }
    } catch {
      Write-Warning "Attempt $i failed: $($_.Exception.Message)"
      if ($i -lt $Attempts) { Start-Sleep -Seconds ($InitialDelaySec * $i) }
    }
  }
  return $false
}

# Candidate image sources (public/free)
$a4Candidates = @(
  'https://source.unsplash.com/2400x1600/?office,team',
  'https://loremflickr.com/2400/1600/office,team',
  'https://picsum.photos/2400/1600',
  'https://placeimg.com/2400/1600/people'
)
$sqCandidates = @(
  'https://source.unsplash.com/1200x1200/?office,team',
  'https://loremflickr.com/1200/1200/office,team',
  'https://picsum.photos/1200/1200',
  'https://placeimg.com/1200/1200/people'
)

function Try-DownloadCandidates {
  param([string[]]$Candidates, [string]$OutFile)
  foreach ($u in $Candidates) {
    if (Download-WithRetry -Url $u -OutFile $OutFile -Attempts 4 -InitialDelaySec 4) { return $true }
    Write-Output "Failed from $u — trying next source..."
  }
  return $false
}

# Download only if files are missing (user can pre-place images to skip downloading)
if (-not (Test-Path $a4Photo)) {
  Write-Output "A4 image not found locally. Attempting to download..."
  if (-not (Try-DownloadCandidates -Candidates $a4Candidates -OutFile $a4Photo)) {
    Write-Warning "Automatic A4 download failed. Place a high-res image named 'a4_photo.jpg' in $posterDir and re-run."
  }
} else {
  Write-Output "Using existing file: $a4Photo"
}
if (-not (Test-Path $sqPhoto)) {
  Write-Output "Square image not found locally. Attempting to download..."
  if (-not (Try-DownloadCandidates -Candidates $sqCandidates -OutFile $sqPhoto)) {
    Write-Warning "Automatic square download failed. Place a square image named 'sq_photo.jpg' in $posterDir and re-run."
  }
} else {
  Write-Output "Using existing file: $sqPhoto"
}

# Stop if images still missing
if (-not (Test-Path $a4Photo) -or -not (Test-Path $sqPhoto)) {
  Write-Output ""; Write-Output "One or both images are missing. Please save images as:"
  Write-Output "  $a4Photo"
  Write-Output "  $sqPhoto"
  Write-Output "Then re-run this script. (You can get free images from Unsplash/Pexels/Pixabay.)"
  exit 1
}

# Build SVG contents (variables expand inside the here-strings)
$a4PhotoUri = ($a4Photo -replace '\\','/')
$sqPhotoUri = ($sqPhoto -replace '\\','/')

$a4SvgContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2480 3508" width="2480" height="3508">
  <defs>
    <linearGradient id="g-grad" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0" stop-color="#f7fdf9"/>
      <stop offset="1" stop-color="#e9f7f1"/>
    </linearGradient>
    <linearGradient id="overlay" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0" stop-color="#000000" stop-opacity="0.10"/>
      <stop offset="1" stop-color="#000000" stop-opacity="0.12"/>
    </linearGradient>
    <style>
      <![CDATA[
        .title { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#ffffff; }
        .brand { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#042a28; }
        .copy { font-family: Roboto, Arial, sans-serif; fill:#324b47; }
      ]]>
    </style>
  </defs>

  <rect width="100%" height="100%" fill="url(#g-grad)"/>
  <rect x="0" y="60" width="2480" height="260" fill="#0A7A57"/>
  <text x="1240" y="220" font-size="120" text-anchor="middle" class="title" letter-spacing="4">WE'RE HIRING</text>

  <g transform="translate(150,360)">
    <image href="$a4PhotoUri" x="1100" y="0" width="930" height="680" preserveAspectRatio="xMidYMid slice" />
    <rect x="1100" y="0" width="930" height="680" fill="url(#overlay)"/>
    <text x="20" y="120" font-size="86" class="brand">CLEARPATHS MARKETING</text>
    <text x="20" y="170" font-size="34" class="copy">Ethical, people‑first fundraising & outreach that scales</text>
  </g>

  <g transform="translate(150,620)">
    <rect x="0" y="0" width="2080" height="1220" rx="18" fill="#ffffff" stroke="#e6f3ef" stroke-width="2" />
    <text x="40" y="110" font-size="54" class="brand">JOB: Brand Ambassador — Sales Associate</text>
    <text x="40" y="170" font-size="28" class="copy">We hire friendly, trained ambassadors to represent mission-led partners at events and public touchpoints.</text>

    <g transform="translate(40,220)">
      <g transform="translate(0,0)">
        <circle cx="32" cy="32" r="28" fill="#0A7A57"/>
        <text x="76" y="42" font-size="30" class="copy">Locations: Multiple — specify availability</text>
      </g>
      <g transform="translate(0,110)">
        <rect x="0" y="0" width="64" height="64" rx="12" fill="#FF7A50"/>
        <text x="76" y="42" font-size="30" class="copy">Hours: Mon–Fri • 12:30 PM – 8:30 PM</text>
      </g>
      <g transform="translate(0,220)">
        <rect x="0" y="0" width="64" height="64" rx="12" fill="#0A7A57"/>
        <text x="76" y="42" font-size="30" class="copy">$800 – $1,200+ / week (base + uncapped incentives)</text>
      </g>
    </g>

    <g transform="translate(40,520)">
      <text x="0" y="0" font-size="40" class="brand">WHY JOIN US?</text>
      <g transform="translate(0,40)" font-size="30" class="copy">
        <text x="0" y="60">• Guaranteed base pay + uncapped incentives</text>
        <text x="0" y="110">• Paid weekly (every Friday)</text>
        <text x="0" y="160">• Paid training and on-site supervisors</text>
        <text x="0" y="210">• Paid travel & gas allowance</text>
        <text x="0" y="260">• Free on-site parking where available</text>
      </g>
    </g>

    <g transform="translate(40,980)">
      <rect x="0" y="0" width="1980" height="200" rx="12" fill="#f3f8f6" />
      <text x="32" y="70" font-size="34" class="brand">TO APPLY</text>
      <text x="32" y="120" font-size="30" class="copy">Email resume to <tspan font-weight="700">marketingclearpaths@gmail.com</tspan></text>
      <text x="32" y="160" font-size="28" class="copy">Visit: <tspan font-weight="700">clearpathsmarketing.com</tspan> • Call: <tspan font-weight="700">705‑888‑2065</tspan></text>
    </g>
  </g>

  <rect x="0" y="3200" width="2480" height="200" fill="#042a28"/>
  <text x="1240" y="3340" font-size="40" text-anchor="middle" fill="#fff">clearpathsmarketing.com  •  marketingclearpaths@gmail.com</text>
</svg>
"@

$sqSvgContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 1200" width="1200" height="1200">
  <defs>
    <linearGradient id="sq-grad" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0" stop-color="#f7fdf9"/>
      <stop offset="1" stop-color="#e9f7f1"/>
    </linearGradient>
    <linearGradient id="sq-overlay" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0" stop-color="#000" stop-opacity="0.10"/>
      <stop offset="1" stop-color="#000" stop-opacity="0.12"/>
    </linearGradient>
    <style>
      <![CDATA[
        .brand { font-family: Poppins, Arial, sans-serif; font-weight:700; fill:#042a28; }
        .copy { font-family: Roboto, Arial, sans-serif; fill:#324b47; }
      ]]>
    </style>
  </defs>

  <rect width="100%" height="100%" fill="url(#sq-grad)"/>
  <rect x="0" y="0" width="1200" height="140" fill="#0A7A57"/>
  <text x="600" y="100" font-size="56" text-anchor="middle" fill="#fff" font-family="Poppins, Arial, sans-serif" font-weight="700">WE'RE HIRING</text>

  <text x="70" y="210" font-size="44" class="brand">CLEARPATHS MARKETING</text>
  <text x="70" y="260" font-size="20" class="copy">Ethical, people-first fundraising & outreach</text>

  <image href="$sqPhotoUri" x="600" y="300" width="520" height="520" preserveAspectRatio="xMidYMid slice" />
  <rect x="600" y="300" width="520" height="520" fill="url(#sq-overlay)"/>

  <rect x="60" y="300" width="520" height="480" rx="12" fill="#fff" stroke="#e6f3ef"/>
  <text x="90" y="360" font-size="28" class="brand">Brand Ambassador — Sales Associate</text>
  <text x="90" y="400" font-size="20" class="copy">Hours: Mon–Fri • 12:30 PM – 8:30 PM</text>
  <text x="90" y="430" font-size="20" class="copy">$800 – $1,200+ / week (base + uncapped incentives)</text>

  <text x="90" y="500" font-size="24" class="brand">Why join?</text>
  <g transform="translate(90,520)" font-size="18" class="copy">
    <text y="28">• Paid weekly (every Friday)</text>
    <text y="58">• Paid training & supervision</text>
    <text y="88">• Travel allowance & free parking (where available)</text>
  </g>

  <rect x="90" y="760" width="1020" height="90" rx="8" fill="#f3f8f6"/>
  <text x="120" y="820" font-size="22" class="copy">Apply: marketingclearpaths@gmail.com  •  clearpathsmarketing.com</text>

  <rect x="0" y="1100" width="1200" height="100" fill="#042a28"/>
  <text x="600" y="1170" font-size="20" fill="#fff" text-anchor="middle" font-family="Poppins, Arial, sans-serif" font-weight="700">Call: 705‑888‑2065</text>
</svg>
"@

# Write SVG files
Set-Content -Path $a4Svg -Value $a4SvgContent -Encoding UTF8
Write-Output "Wrote SVG: $a4Svg"
Set-Content -Path $sqSvg -Value $sqSvgContent -Encoding UTF8
Write-Output "Wrote SVG: $sqSvg"

# Convert SVG -> PDF (Inkscape preferred, ImageMagick fallback)
function Convert-SvgToPdf {
  param([string]$SvgPath, [string]$PdfPath)
  $inkPaths = @(
    "$Env:ProgramFiles\Inkscape\inkscape.com",
    "$Env:ProgramFiles\Inkscape\inkscape.exe",
    "$Env:ProgramFiles(x86)\Inkscape\inkscape.com",
    "inkscape"
  )
  foreach ($p in $inkPaths) {
    if (Get-Command $p -ErrorAction SilentlyContinue) {
      try {
        Write-Output "Using Inkscape: $p"
        & $p --export-type=pdf --export-filename="$PdfPath" "$SvgPath"
        return (Test-Path $PdfPath)
      } catch {
        Write-Warning "Inkscape conversion failed: $($_.Exception.Message)"
      }
    }
  }
  if (Get-Command magick -ErrorAction SilentlyContinue) {
    try {
      Write-Output "Using ImageMagick (magick) to convert (raster PDF)."
      & magick convert -density 300 "$SvgPath" "$PdfPath"
      return (Test-Path $PdfPath)
    } catch {
      Write-Warning "ImageMagick conversion failed: $($_.Exception.Message)"
    }
  }
  Write-Warning "No conversion tool found (Inkscape or ImageMagick). SVGs were created and can be opened/printed with Inkscape/Illustrator."
  return $false
}

$ok1 = Convert-SvgToPdf -SvgPath $a4Svg -PdfPath $a4Pdf
$ok2 = Convert-SvgToPdf -SvgPath $sqSvg -PdfPath $sqPdf

if ($ok1) { Write-Output "PDF created: $a4Pdf" } else { Write-Warning "A4 PDF not created; SVG available at $a4Svg" }
if ($ok2) { Write-Output "PDF created: $sqPdf" } else { Write-Warning "Square PDF not created; SVG available at $sqSvg" }

# Open created PDFs if present
if (Test-Path $a4Pdf) { Start-Process $a4Pdf }
if (Test-Path $sqPdf) { Start-Process $sqPdf }

Write-Output "Finished. Files are in: $posterDir"