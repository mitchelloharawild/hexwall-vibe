# Example usage of hextile function
library(htmltools)

# Source the function
source("R/hextile.R")

# Create sample hexagon tile with placeholder images
sample_images <- c(
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/usethis.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/roxygen2.svg", 
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/testthat.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/pkgdown.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/vctrs.svg"
)

# Create the hextile
hex_tile <- hextile(sample_images)

# Save as HTML file to view
save_html(hex_tile, "hexagon_example.html")

# Print the HTML structure
print(hex_tile)