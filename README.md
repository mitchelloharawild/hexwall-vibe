# hexwall

An R package providing htmltools extensions for creating hexagonal tile patterns using hex.css styling. Perfect for displaying package logos and creating visual hex walls with **embedded base64 images** for completely self-contained HTML output.

## Installation

```r
# Install development version from GitHub
devtools::install_github("your-username/hexwall")

# Or install locally
devtools::install()
```

## Key Features

- **🔒 Self-contained HTML**: All images are embedded as base64 data URIs - no external file dependencies
- **📦 Automatic logo detection**: Finds hex logos from installed R packages
- **🌐 Remote image support**: Downloads and embeds images from URLs
- **🎨 CSS integration**: Automatically includes hex.css dependency  
- **🛡️ Error handling**: Robust validation with clear error messages
- **🔧 Flexible input**: Supports local files, URLs, or package auto-detection

## Usage

### Automatic Package Logo Detection

The main feature is automatic detection and embedding of hex logos from installed packages:

```r
library(hexwall)

# Create hex wall from package logos - all images embedded as base64
hex_wall(packages = c("dplyr", "ggplot2", "readr", "tidyr"))
```

This searches for logos in the standard `man/figures/logo.(png|jpg|svg)` location used by `usethis::use_logo()` and embeds them directly in the HTML.

### Custom Images (Local Files)

Local image files are automatically converted to base64 and embedded:

```r
# Local image files - converted to base64 data URIs
hex_wall(images = c("logo1.png", "logo2.svg", "logo3.jpg"))
```

### Remote URLs

Remote images are downloaded and converted to base64 for embedding:

```r
# Remote URLs - downloaded and embedded as base64
hex_wall(images = c(
  "https://raw.githubusercontent.com/tidyverse/dplyr/main/man/figures/logo.png",
  "https://raw.githubusercontent.com/tidyverse/ggplot2/main/man/figures/logo.png"
))
```

### Combining Sources

Mix package logos, local files, and remote URLs:

```r
# All sources combined - everything embedded as base64
hex_wall(
  packages = c("dplyr", "ggplot2"), 
  images = c("custom-logo.png", "https://example.com/logo.svg")
)
```

### Custom CSS Classes

Add your own CSS classes for additional styling:

```r
hex_wall(
  packages = c("tidyverse", "shiny"),
  class = c("custom-style", "large-hexes")
)
```

## Base64 Embedding

All images are automatically converted to base64 data URIs, which means:

- ✅ **No external dependencies** - HTML is completely self-contained
- ✅ **Works offline** - No network requests needed after generation  
- ✅ **Portable** - Share HTML files without worrying about missing images
- ✅ **Secure** - No external image loading in restricted environments

### Example Output

Instead of:
```html
<img src="/path/to/logo.png"/>
```
```r
# Old way (deprecated) 
hextile(c("logo1.png", "logo2.png"))

# New way (with base64 embedding)
hex_wall(images = c("logo1.png", "logo2.png"))
```

## Performance Notes

- **File size**: Base64 encoding increases HTML size by ~33% compared to file references
- **Memory**: Large images will create large HTML files - consider image optimization
- **Loading**: Self-contained HTML loads faster than external image requestsHTML Structure

The function generates clean HTML following the hex.css pattern:

```html
<div class="hextile clr">
  <ul>
    <li><img src="data:image/png;base64,[BASE64_DATA]"/></li>
    <li><img src="data:image/svg+xml;base64,[BASE64_DATA]"/></li>
    <li><img src="data:image/jpeg;base64,[BASE64_DATA]"/></li>
  </ul>
</div>
```

## Error Handling

The package provides robust error handling:

- **Missing files**: Clear errors for non-existent local files
- **Network issues**: Graceful handling of failed URL downloads  
- **Invalid formats**: Warnings for unsupported image types
- **Missing packages**: Helpful messages for uninstalled packages

## Requirements

- **R packages**: `htmltools`, `glue`, `base64enc`, `tools`, `utils`
- **CSS file**: `inst/hex.css` (hex styling)

## Backward Compatibility

The original `hextile()` function is still available but deprecated:

```r
# Old way (deprecated)
hextile(c("logo1.png", "logo2.png"))

# New way
hex_wall(images = c("logo1.png", "logo2.png"))
```