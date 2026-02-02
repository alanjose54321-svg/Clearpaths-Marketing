# apply_card_bg_fixed.ps1
# Read cards from index_old_saved.html, change card #1 -> img/office.jpg and card #4 -> img/money.jpg,
# then insert the modified gallery into index_backup.html and write a preview file.
# Run from the folder that contains index_old_saved.html, index_backup.html and the img\ folder.

$source = ".\index_old_saved.html"
$target = ".\index_backup.html"
$outPreview = ".\index_backup_custom_patched.html"

if (-not (Test-Path $source)) { Write-Error "$source not found. Run Get-ChildItem .\index*.html -Name to check filenames."; exit 1 }
if (-not (Test-Path $target)) { Write-Error "$target not found. Run Get-ChildItem .\index*.html -Name to check filenames."; exit 1 }

# filenames to use (edit here if you already have different images)
$firstImg = "img/office.jpg"
$fourthImg = "img/money.jpg"

# Download sensible images if missing
function FetchIfMissing($path, $query) {
  if (-not (Test-Path $path)) {
    Write-Output "Downloading $path (query: $query) ..."
    try {
      Invoke-WebRequest -Uri $query -OutFile $path -UseBasicParsing -ErrorAction Stop
      Write-Output "Saved $path"
    } catch {
      Write-Warning "Failed to download $path : $($_.Exception.Message)"
    }
  } else {
    Write-Output "Found existing: $path"
  }
}
FetchIfMissing $firstImg "https://source.unsplash.com/1000x700/?office,workspace,team"
FetchIfMissing $fourthImg "https://source.unsplash.com/1000x700/?money,dollars,fundraising"

# Back up originals
$now = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item -Path $source -Destination "$source.bak.$now" -Force
Copy-Item -Path $target -Destination "$target.bak.$now" -Force
Write-Output "Backups: $source.bak.$now , $target.bak.$now"

$srcHtml = Get-Content -Path $source -Raw
$dstHtml = Get-Content -Path $target -Raw

# Find gallery (prefer aria-label="photos", fallback to any grid section)
$galleryRegex = '<section[^>]*aria-label=["'']?photos["'']?[^>]*>.*?</section>'
$gridRegex    = '<section[^>]*class=["'']?[^"'']*grid[^"'']*["'']?[^>]*>.*?</section>'

if ([regex]::IsMatch($srcHtml, $galleryRegex, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
  $galleryMatch = [regex]::Match($srcHtml, $galleryRegex, [System.Text.RegularExpressions.RegexOptions]::Singleline)
} elseif ([regex]::IsMatch($srcHtml, $gridRegex, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
  $galleryMatch = [regex]::Match($srcHtml, $gridRegex, [System.Text.RegularExpressions.RegexOptions]::Singleline)
} else {
  Write-Error "Could not find a gallery/grid section in $source. Aborting."
  exit 1
}

$gallery = $galleryMatch.Value

# Extract card blocks
$cardPattern = '<div\s+class=["'']card["''][\s\S]*?</div>'
$cardMatches = [regex]::Matches($gallery, $cardPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
if ($cardMatches.Count -eq 0) {
  Write-Error "No .card elements found inside gallery. Aborting."
  exit 1
}

# Helper to replace the <img ...> inside a card with a new img src
function ReplaceCardImg($cardHtml, $newImgPath) {
  if ([regex]::IsMatch($cardHtml, '<img\b[^>]*src=["''][^"'']+["''][^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
    $newImgTag = "<img src=`"$newImgPath`" alt=`"image`" style=`"width:100%;height:200px;object-fit:cover;display:block;border-radius:0;`">"
    return [regex]::Replace($cardHtml, '<img\b[^>]*>', $newImgTag, 1, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  } else {
    # If no img tag present, prepend one
    $newImgTag = "<img src=`"$newImgPath`" alt=`"image`" style=`"width:100%;height:200px;object-fit:cover;display:block;border-radius:0;`">"
    return $newImgTag + $cardHtml
  }
}

# Build modified cards array
$modifiedCards = @()
for ($i = 0; $i -lt $cardMatches.Count; $i++) {
  $orig = $cardMatches[$i].Value
  if ($i -eq 0) {
    Write-Output "Modifying card #1 -> $firstImg"
    $modifiedCards += ReplaceCardImg $orig $firstImg
  } elseif ($i -eq 3) {
    Write-Output "Modifying card #4 -> $fourthImg"
    $modifiedCards += ReplaceCardImg $orig $fourthImg
  } else {
    $modifiedCards += $orig
  }
}

# Replace the sequence of cards inside the gallery with modified ones.
# We'll reconstruct the gallery by replacing each original card sequentially (first occurrences).
$galleryModified = $gallery
function ReplaceFirstOccurrence($text, $old, $new) {
  $idx = $text.IndexOf($old)
  if ($idx -lt 0) { return $text }
  return $text.Substring(0,$idx) + $new + $text.Substring($idx + $old.Length)
}

for ($i = 0; $i -lt $cardMatches.Count; $i++) {
  $galleryModified = ReplaceFirstOccurrence $galleryModified $cardMatches[$i].Value $modifiedCards[$i]
}

# Put the modified gallery into the target HTML
$patched = $dstHtml.Replace($gallery, $galleryModified)

# Inject helper CSS for readability (if not present)
$helperCss = @"
  /* Inserted: make gallery background-cards neat */
  .card img{ display:block; width:100%; height:200px; object-fit:cover; border-radius:6px 6px 0 0; }
  .card { overflow:hidden; border-radius:8px; }
"@
if ($patched -match "</style>") {
  $patched = $patched -replace "</style>", $helperCss + "`n</style>"
} elseif ($patched -match "(?i)</head>") {
  $patched = $patched -replace "(?i)</head>", "<style>`n" + $helperCss + "`n</style>`n</head>"
}

# Write preview only
Set-Content -Path $outPreview -Value $patched -Encoding UTF8
Write-Output ""
Write-Output "Preview written to: $outPreview"
Write-Output "Open it (double-click) and press Ctrl+F5 to inspect locally."
Write-Output ""
Write-Output "If preview looks correct, apply it with:"
Write-Output "  Copy-Item .\$outPreview .\$target -Force"
Write-Output "and then (optional) copy to index.html with:"
Write-Output "  Copy-Item .\$target .\index.html -Force"
