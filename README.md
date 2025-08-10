# hexwall

An R package for creating hexagonal tile patterns using htmltools and CSS transforms.

## Installation

```r
# Install from local source
devtools::install_local(".")

# Or if developing
devtools::load_all(".")
```

## Usage

### Basic Usage

```r
library(hexwall)

# Create hexagon tiles from image paths
images <- c(
  "path/to/image1.svg",
  "path/to/image2.svg", 
  "path/to/image3.svg"
)

hex_tiles <- hextile(images)
```

### With Additional CSS Classes

```r
# Add custom CSS classes
hex_tiles <- hextile(images, class = "my-custom-class")
```

### Complete Example

```r
library(htmltools)
library(hexwall)

# Sample hex sticker URLs
sample_images <- c(
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/usethis.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/roxygen2.svg", 
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/testthat.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/pkgdown.svg",
  "https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/vctrs.svg"
)

# Create hexagon tile pattern
hex_display <- hextile(sample_images)

# View in browser
browsable(hex_display)

# Or save to file  
save_html(hex_display, "my_hexagons.html")
```

## HTML Structure

The function generates HTML with this structure:

```html
<div class="hextile clr">
  <ul>
    <li><img src="image1.svg"></li>
    <li><img src="image2.svg"></li>
    <li><img src="image3.svg"></li>
  </ul>
</div>
```

The CSS dependency is automatically included to provide the hexagonal styling and tiling layout.

## CSS Classes

- `hextile`: Main container class for hexagon layout
- `clr`: Clearfix class for proper floating behavior

Additional classes can be added using the `class` parameter.