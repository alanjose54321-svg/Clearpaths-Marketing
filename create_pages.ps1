# create_pages.ps1
# Safe: only creates files if they do not already exist.
# Run this script from inside your 'cleapths' folder.

$files = @{
"about.html" = @'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>About — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head>
<body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page">
    <section class="page-hero"><h1>About Clearpaths</h1><p>We create clear, measurable marketing plans that grow businesses predictably.</p></section>
    <section class="content"><h2>Our Story</h2><p>We bring strategy, creative and execution together to help small and growing businesses win online.</p>
    <div class="center"><a class="btn" href="contact.html">Start a Conversation</a></div></section>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong><p>Helping businesses find repeatable paths to growth.</p></div></div></footer>
</body>
</html>
'@

"services.html" = @'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Services — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head>
<body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page">
    <section class="page-hero"><h1>Services</h1><p>Services tailored to your goals.</p></section>
    <section class="content">
      <article class="service-item"><h2><a href="service-digital-marketing.html">Digital Marketing</a></h2><p>Paid, organic, email and more.</p></article>
      <article class="service-item"><h2>Website & eCommerce</h2><p>Modern sites built to convert.</p></article>
      <div class="center"><a class="btn" href="contact.html">Request a Proposal</a></div>
    </section>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body>
</html>
'@

"service-digital-marketing.html" = @'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Digital Marketing — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head>
<body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page">
    <section class="page-hero"><h1>Digital Marketing</h1><p>Campaigns focused on measurable growth and ROI.</p></section>
    <section class="content"><h3>What we do</h3><ul><li>Paid search & social</li><li>Email automation</li><li>Reporting & optimisation</li></ul><div class="center"><a class="btn" href="contact.html">Get a Marketing Audit</a></div></section>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body>
</html>
'@

"portfolio.html" = @'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Our Work — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head>
<body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page">
    <section class="page-hero"><h1>Selected Projects</h1><p>Case snapshots of client work.</p></section>
    <section class="gallery">
      <div class="project"><img src="img/sample1.jpg" alt=""><h4>Urban Eats — Growth</h4><p>Local SEO & social → more bookings.</p></div>
      <div class="project"><img src="img/sample2.jpg" alt=""><h4>Summit Tech — Rebrand</h4><p>Identity & messaging.</p></div>
    </section>
    <div class="center"><a class="btn" href="contact.html">Discuss Your Project</a></div>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body>
</html>
'@

"contact.html" = @'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Contact — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head>
<body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page">
    <section class="page-hero"><h1>Contact Us</h1><p>Tell us about your goals.</p></section>
    <section class="content contact-grid">
      <div class="contact-info"><h3>Get in touch</h3><p>Email: info@clearpathsmarketing.com</p><p>Phone: (123) 456-7890</p></div>
      <form class="contact-form" action="#" method="post"><input type="text" name="name" placeholder="Your name" required><input type="email" name="email" placeholder="Your email" required><textarea name="message" placeholder="Message" rows="6" required></textarea><button class="btn" type="submit">Send Message</button></form>
    </section>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body>
</html>
'@

"testimonials.html" = @'
<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Testimonials — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head><body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page"><section class="page-hero"><h1>What clients say</h1><p>Short excerpts from clients.</p></section>
    <section class="testimonials"><div class="testimonial"><p>"Great results in months."</p><strong>— Client A</strong></div><div class="testimonial"><p>"Very professional."</p><strong>— Client B</strong></div></section>
    <div class="center"><a class="btn" href="contact.html">Share Your Story</a></div>
  </main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body></html>
'@

"faq.html" = @'
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>FAQ — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head><body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page"><section class="page-hero"><h1>FAQ</h1><p>Answers to common questions.</p></section><section class="content"><h3>How long to see results?</h3><p>Depends on service; PPC is faster, SEO takes longer.</p></section></main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body></html>
'@

"industries.html" = @'
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Industries — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head><body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page"><section class="page-hero"><h1>Industries</h1><p>We work with restaurants, retail, professional services, tech and more.</p></section></main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body></html>
'@

"blog.html" = @'
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><title>Insights — Clearpaths Marketing</title><link rel="stylesheet" href="styles.css"/></head><body>
  <header><nav class="nav"><div class="brand"><img src="img/logo.png" class="logo" alt="Logo"><span>Clearpaths Marketing</span></div></nav></header>
  <main class="page"><section class="page-hero"><h1>Insights</h1><p>Tips and short articles to help you grow online.</p></section><section class="content blog-list"><article class="post"><h3>Boost Local SEO</h3><p>Simple steps to improve local visibility.</p></article></section></main>
  <footer class="site-footer"><div class="footer-inner"><div><strong>Clearpaths Marketing</strong></div></div></footer>
</body></html>
'@
}  # <- end of $files hashtable

# Create each file only if it does not already exist
foreach ($name in $files.Keys) {
  if (-not (Test-Path $name)) {
    $files[$name] | Out-File -FilePath $name -Encoding UTF8
    Write-Host "Created $name"
  } else {
    Write-Host "$name already exists — skipped"
  }
}

# Create zip on Desktop (only the contents of the current folder)
$zipPath = Join-Path $env:USERPROFILE "Desktop\cleapths.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path (Join-Path (Get-Location) "*") -DestinationPath $zipPath -Force

Write-Host ""
Write-Host "Done."
Write-Host "The pages were created (if they did not already exist)."
Write-Host "Zip created on your Desktop: $zipPath"
Write-Host "Double-click index.html inside this folder to preview locally."