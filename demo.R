# hexwall Package Demo
# Demonstrating hex tile creation with package logos and custom images

library(htmltools)
source("R/hextile.R")

# Example 1: Auto-detect package logos
cat("=== Example 1: Package logos ===\n")
packages_to_show <- c("htmltools", "base")  # Use commonly available packages
wall_packages <- hex_wall(packages = packages_to_show)
print(wall_packages)

# Example 2: Custom image URLs
cat("\n=== Example 2: Custom URLs ===\n")
custom_urls <- c(
  "https://github.com/tidyverse/dplyr/raw/main/man/figures/logo.png",
  "https://github.com/tidyverse/ggplot2/raw/main/man/figures/logo.png"
)
wall_urls <- hex_wall(images = custom_urls)
print(wall_urls)

# Example 3: Mixed packages and custom images
cat("\n=== Example 3: Mixed sources ===\n")
wall_mixed <- hex_wall(
  packages = "htmltools",
  images = "https://github.com/tidyverse/dplyr/raw/main/man/figures/logo.png",
  class = "demo-wall"
)
print(wall_mixed)

# Example 4: Custom CSS classes
cat("\n=== Example 4: With custom CSS ===\n")
wall_custom <- hex_wall(
  packages = "htmltools",
  class = c("large-hexes", "custom-theme")
)
print(wall_custom)

# Example 5: Error handling demonstration
cat("\n=== Example 5: Error handling ===\n")
tryCatch({
  wall_error <- hex_wall(images = "nonexistent-file.png")
}, error = function(e) {
  cat("Caught expected error:", conditionMessage(e), "\n")
})

# Example 6: View in browser (if interactive)
if (interactive()) {
  cat("\n=== Opening in browser ===\n")
  browsable_wall <- hex_wall(packages = "htmltools")
  print(browsable(browsable_wall))
}

cat("\n=== Demo complete ===\n")