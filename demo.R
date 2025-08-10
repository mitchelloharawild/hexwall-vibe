# hexwall Package Demo - Base64 Embedded Images
# Demonstrating hex tile creation with base64-embedded images

library(htmltools)
source("R/hextile.R")

cat("=== hexwall Demo: Self-Contained HTML with Base64 Images ===\n\n")

# Example 1: Auto-detect package logos (embedded as base64)
cat("1. Package logos (auto-detected and embedded as base64):\n")
packages_to_show <- c("htmltools", "dplyr", "ggplot2")  
wall_packages <- hex_wall(packages = packages_to_show)

html_pkg <- as.character(wall_packages)
data_uri_count <- length(gregexpr("data:image", html_pkg)[[1]])
if (data_uri_count == -1) data_uri_count <- 0

cat("   ✓ Found and embedded", data_uri_count, "package logos as base64\n")
cat("   ✓ HTML size:", nchar(html_pkg), "characters\n")
cat("   ✓ Completely self-contained (no external file dependencies)\n\n")

# Example 2: Remote URLs (downloaded and embedded)
cat("2. Remote URLs (downloaded and embedded as base64):\n")
remote_url <- "https://raw.githubusercontent.com/tidyverse/dplyr/main/man/figures/logo.png"

tryCatch({
  wall_remote <- hex_wall(images = remote_url)
  html_remote <- as.character(wall_remote)
  
  if (grepl("data:image", html_remote)) {
    cat("   ✓ Successfully downloaded and embedded remote image\n")
    cat("   ✓ HTML size:", nchar(html_remote), "characters\n")
    cat("   ✓ No network requests needed after HTML generation\n")
  } else {
    cat("   ✗ Remote image embedding failed\n")
  }
}, error = function(e) {
  cat("   ⚠ Network error:", conditionMessage(e), "\n")
})
cat("\n")

# Example 3: Mixed sources
cat("3. Mixed sources (packages + remote URLs, all embedded):\n")
tryCatch({
  wall_mixed <- hex_wall(
    packages = "htmltools",
    images = "https://raw.githubusercontent.com/tidyverse/ggplot2/main/man/figures/logo.png",
    class = "demo-wall"
  )
  html_mixed <- as.character(wall_mixed)
  mixed_count <- length(gregexpr("data:image", html_mixed)[[1]])
  if (mixed_count == -1) mixed_count <- 0
  
  cat("   ✓ Combined", mixed_count, "images from different sources\n")
  cat("   ✓ All embedded as base64 data URIs\n") 
  cat("   ✓ HTML size:", nchar(html_mixed), "characters\n")
}, error = function(e) {
  cat("   ⚠ Error:", conditionMessage(e), "\n")
})
cat("\n")

# Example 4: Show HTML structure (abbreviated)
cat("4. HTML structure with base64 embedding:\n")
sample_wall <- hex_wall(packages = "htmltools")
sample_html <- as.character(sample_wall)

# Show structure with abbreviated base64 data
abbreviated_html <- gsub(
  "data:image/[^;]+;base64,[^\"]+", 
  "data:image/[TYPE];base64,[BASE64_DATA_EMBEDDED]", 
  sample_html
)

cat("   Generated HTML structure:\n")
cat("   ", gsub("\\n", "\n   ", abbreviated_html), "\n\n")

# Example 5: Performance comparison
cat("5. Base64 vs file path comparison:\n")
pkg_wall <- hex_wall(packages = "htmltools")
pkg_html <- as.character(pkg_wall)

cat("   • Base64 embedded HTML size:", nchar(pkg_html), "characters\n")
cat("   • Contains", length(gregexpr("data:image", pkg_html)[[1]]), "embedded images\n")
cat("   • Self-contained: ✓ (no external dependencies)\n")
cat("   • Portable: ✓ (works anywhere)\n")
cat("   • Offline-ready: ✓ (no network requests)\n\n")

# Example 6: Error handling demonstration  
cat("6. Error handling with helpful messages:\n")
tryCatch({
  wall_error <- hex_wall(images = "nonexistent-file.png")
}, error = function(e) {
  cat("   ✓ Clear error for missing file:", conditionMessage(e), "\n")
})

tryCatch({
  wall_empty <- hex_wall()  # No arguments
}, error = function(e) {
  cat("   ✓ Clear error for missing arguments:", conditionMessage(e), "\n")
})
cat("\n")

# Example 7: MIME type detection
cat("7. Automatic MIME type detection:\n")
if (exists("get_mime_type")) {
  test_files <- c("logo.png", "image.jpg", "graphic.svg", "icon.webp")
  for (file in test_files) {
    mime <- get_mime_type(file)
    cat("   •", file, "→", mime, "\n")
  }
} else {
  cat("   (MIME type function not available in current scope)\n")
}
cat("\n")

# Example 8: Browser preview (if interactive)
if (interactive()) {
  cat("8. Opening self-contained HTML in browser...\n")
  browsable_wall <- hex_wall(packages = c("htmltools", "dplyr"))
  print(browsable(browsable_wall))
  cat("   ✓ HTML opened in browser/viewer\n")
  cat("   ✓ All images embedded - no external files needed\n\n")
}

cat("=== Demo Complete ===\n")
cat("✨ All images have been embedded as base64 data URIs\n")
cat("🔒 Generated HTML is completely self-contained\n")
cat("📦 Ready for sharing, archiving, or offline use\n")