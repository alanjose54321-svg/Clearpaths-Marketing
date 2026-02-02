# merge_gallery.ps1
# Merge gallery from indexold.html into indexbackup.html
# Run from folder that contains indexold.html and indexbackup.html

$now = Get-Date -Format "yyyyMMdd_HHmmss"

# Verify files exist
if (-not (Test-Path .\indexold.html)) { Write-Error "indexold.html not found in current folder. Aborting."; exit 1 }
if (-not (Test-Path .\indexbackup.html)) { Write-Error "indexbackup.html not found in current folder. Aborting."; exit 1 }

# Create safe backups
Copy-Item -Path .\indexold.html -Destination ".\indexold.html.bak.$now" -Force
Copy-Item -Path .\indexbackup.html -Destination ".\indexbackup.html.bak.$now" -Force
Write-Output "Backups created: indexold.html.bak.$now, indexbackup.html.bak.$now"

# Read source and target
$sourceHtml = Get-Content -Path .\indexold.html -Raw
$targetHtml = Get-Content -Path .\indexbackup.html -Raw

# Try to find a <section aria-label="photos"> block in the source first,
# otherwise fall back to any <section class="...grid..."> block.
$galleryMatch = [regex]::Match($sourceHtml, '<section[^>]*aria-label=["'']?photos["'']?[^>]*>.*?</section>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
if (-not $galleryMatch.Success) {
    $galleryMatch = [regex]::Match($sourceHtml, '<section[^>]*class=["'']?[^"'']*grid[^"'']*["'']?[^>]*>.*?</section>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
}

if (-not $galleryMatch.Success) {
    Write-Error "Could not find a gallery section in indexold.html (no <section ... aria-label='photos' ...> or grid section). No changes made."
    exit 1
}

$galleryHtml = $galleryMatch.Value
Write-Output "Found gallery section in indexold.html (length $($galleryHtml.Length) chars)."

# Try to replace an existing photos section in the target (if present)
if ([regex]::IsMatch($targetHtml, '<section[^>]*aria-label=["'']?photos["'']?[^>]*>.*?</section>', [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
    $patched = [regex]::Replace($targetHtml, '<section[^>]*aria-label=["'']?photos["'']?[^>]*>.*?</section>', $galleryHtml, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $action = "Replaced existing photos section in indexbackup.html"
}
# If no explicit photos section, try replacing the first generic grid section
elseif ([regex]::IsMatch($targetHtml, '<section[^>]*class=["'']?[^"'']*grid[^"'']*["'']?[^>]*>.*?</section>', [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
    $patched = [regex]::Replace($targetHtml, '<section[^>]*class=["'']?[^"'']*grid[^"'']*["'']?[^>]*>.*?</section>', $galleryHtml, [System.Text.RegularExpressions.RegexOptions]::Singleline, 1)
    $action = "Replaced first grid section in indexbackup.html with gallery"
}
# Otherwise insert before the closing </main>
elseif ($targetHtml -match '(?s)</main>') {
    $patched = [regex]::Replace($targetHtml, '(?s)</main>', $galleryHtml + "`n</main>")
    $action = "Inserted gallery into indexbackup.html before </main>"
}
else {
    Write-Error "No place found to insert gallery (no </main> or grid section). No changes made, but backups were created."
    exit 1
}

# Write preview and overwrite target (keeping backups)
Set-Content -Path .\indexbackup_patched.html -Value $patched -Encoding UTF8
Set-Content -Path .\indexbackup.html -Value $patched -Encoding UTF8

Write-Output $action
Write-Output "Wrote preview file: indexbackup_patched.html"
Write-Output "Overwrote indexbackup.html with patched content (original backed up)."
Write-Output ""
Write-Output "Open indexbackup.html (or indexbackup_patched.html) in your browser and press Ctrl+F5 to hard-refresh and view changes."
Write-Output ""
Write-Output "To restore the original indexbackup.html, run (replace $now with the timestamp shown above):"
Write-Output "Copy-Item .\indexbackup.html.bak.$now .\indexbackup.html -Force"