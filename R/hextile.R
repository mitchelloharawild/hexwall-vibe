#' Create a hexagon tile pattern
#'
#' Creates a hexagonal tile pattern using hex.css styling. Each image is displayed
#' in a hexagonal shape arranged in a tiling pattern. Images are embedded as base64
#' data URIs for completely self-contained HTML output.
#'
#' @param packages Character vector of package names to automatically find hex logos for.
#'   Logos are searched in the standard location: man/figures/logo.(png|jpg|svg)
#' @param images Character vector of image paths/URLs to display
#' @param class Additional CSS classes to apply to the container
#' @param ... Additional attributes for the container div
#'
#' @return An htmltools tag object
#' @export
#'
#' @examples
#' \dontrun{
#' # Auto-detect logos from installed packages
#' hex_wall(packages = c("dplyr", "ggplot2", "usethis"))
#' 
#' # Use custom image paths
#' hex_wall(images = c("logo1.svg", "logo2.svg", "logo3.svg"))
#'
#' # Combine packages and custom images
#' hex_wall(packages = "dplyr", images = "custom-logo.png")
#' 
#' # With additional CSS classes
#' hex_wall(images = c("img1.png", "img2.png"), class = "my-custom-class")
#' }
hex_wall <- function(packages = NULL, images = NULL, class = NULL, ...) {
  # Collect all image paths
  all_images <- character(0)
  
  # Get logos from packages if specified
  if (!is.null(packages)) {
    if (!is.character(packages) || length(packages) == 0) {
      stop("packages must be a non-empty character vector")
    }
    
    package_logos <- find_package_logos(packages)
    all_images <- c(all_images, package_logos)
  }
  
  # Add custom images if specified
  if (!is.null(images)) {
    if (!is.character(images) || length(images) == 0) {
      stop("images must be a non-empty character vector")
    }
    all_images <- c(all_images, images)
  }
  
  # Check that we have at least one image
  if (length(all_images) == 0) {
    stop("Must provide either 'packages' or 'images' argument")
  }
  
  # Validate that images exist or are URLs
  validate_images(all_images)
  
  # Convert all images to base64 data URIs
  base64_images <- convert_images_to_base64(all_images)
  
  # Create list items for each base64 image
  list_items <- lapply(base64_images, function(img) {
    htmltools::tags$li(
      htmltools::tags$img(src = img)
    )
  })
  
  # Combine base classes with additional classes
  container_class <- "hextile clr"
  if (!is.null(class)) {
    container_class <- paste(container_class, paste(class, collapse = " "))
  }
  
  # Create the main container with dependency
  tag <- htmltools::div(
    class = container_class,
    htmltools::tags$ul(list_items),
    ...
  )
  
  # Attach the CSS dependency
  attach_hex_dependency(tag)
}

#' Convert images to base64 data URIs
#'
#' Converts local image files and remote URLs to base64 data URIs for embedding
#' directly in HTML
#'
#' @param images Character vector of image paths/URLs
#' @return Character vector of base64 data URIs
#' @keywords internal
convert_images_to_base64 <- function(images) {
  base64_images <- character(length(images))
  
  for (i in seq_along(images)) {
    img <- images[i]
    
    tryCatch({
      if (grepl("^https?://", img)) {
        # Handle remote URLs
        base64_images[i] <- url_to_base64(img)
      } else {
        # Handle local files
        base64_images[i] <- file_to_base64(img)
      }
    }, error = function(e) {
      warning(glue::glue("Failed to convert image '{img}' to base64: {conditionMessage(e)}"))
      # Fallback to original path/URL if conversion fails
      base64_images[i] <- img
    })
  }
  
  base64_images
}

#' Convert local file to base64 data URI
#'
#' @param file_path Path to local image file
#' @return Base64 data URI string
#' @keywords internal
file_to_base64 <- function(file_path) {
  # Read file as binary
  file_content <- readBin(file_path, "raw", file.info(file_path)$size)
  
  # Determine MIME type from file extension
  mime_type <- get_mime_type(file_path)
  
  # Convert to base64
  base64_content <- base64enc::base64encode(file_content)
  
  # Create data URI
  paste0("data:", mime_type, ";base64,", base64_content)
}

#' Convert remote URL to base64 data URI
#'
#' @param url Remote image URL
#' @return Base64 data URI string
#' @keywords internal
url_to_base64 <- function(url) {
  # Create temporary file
  temp_file <- tempfile()
  on.exit(unlink(temp_file), add = TRUE)
  
  # Download file
  tryCatch({
    utils::download.file(url, temp_file, mode = "wb", quiet = TRUE)
  }, error = function(e) {
    stop(glue::glue("Failed to download image from URL: {url}"))
  })
  
  # Determine MIME type from URL or downloaded file
  mime_type <- get_mime_type_from_url(url)
  
  # Read and convert to base64
  file_content <- readBin(temp_file, "raw", file.info(temp_file)$size)
  base64_content <- base64enc::base64encode(file_content)
  
  # Create data URI
  paste0("data:", mime_type, ";base64,", base64_content)
}

#' Get MIME type from file path
#'
#' @param file_path Path to file
#' @return MIME type string
#' @keywords internal
get_mime_type <- function(file_path) {
  ext <- tolower(tools::file_ext(file_path))
  
  switch(ext,
    "png" = "image/png",
    "jpg" = "image/jpeg",
    "jpeg" = "image/jpeg", 
    "svg" = "image/svg+xml",
    "gif" = "image/gif",
    "webp" = "image/webp",
    "image/png" # Default fallback
  )
}

#' Get MIME type from URL
#'
#' @param url Image URL
#' @return MIME type string
#' @keywords internal
get_mime_type_from_url <- function(url) {
  # Extract extension from URL (ignoring query parameters)
  url_path <- strsplit(url, "\\?")[[1]][1]  # Remove query string
  ext <- tolower(tools::file_ext(url_path))
  
  switch(ext,
    "png" = "image/png",
    "jpg" = "image/jpeg",
    "jpeg" = "image/jpeg",
    "svg" = "image/svg+xml", 
    "gif" = "image/gif",
    "webp" = "image/webp",
    "image/png" # Default fallback
  )
}

#' Find package logos in standard locations
#'
#' Searches for package logos in the man/figures directory following usethis conventions
#'
#' @param packages Character vector of package names
#' @return Character vector of found logo paths
#' @keywords internal
find_package_logos <- function(packages) {
  logo_paths <- character(0)
  
  for (pkg in packages) {
    # Check if package is installed
    if (!requireNamespace(pkg, quietly = TRUE)) {
      warning(glue::glue("Package '{pkg}' is not installed, skipping logo search"))
      next
    }
    
    # Search for logo in standard location
    pkg_path <- system.file(package = pkg)
    if (pkg_path == "") {
      warning(glue::glue("Cannot find installation path for package '{pkg}'"))
      next
    }
    
    # Look for logo files in man/figures/
    logo_files <- list.files(
      file.path(pkg_path, "help", "figures"),
      pattern = "^logo\\.(png|jpg|jpeg|svg)$",
      full.names = TRUE,
      ignore.case = TRUE
    )
    
    if (length(logo_files) > 0) {
      # Use the first found logo
      logo_paths <- c(logo_paths, logo_files[1])
    } else {
      warning(glue::glue("No logo found for package '{pkg}' in {file.path(pkg_path, 'help', 'figures')}"))
    }
  }
  
  logo_paths
}

#' Validate image paths and URLs
#'
#' Checks that local images exist and URLs are properly formatted
#'
#' @param images Character vector of image paths/URLs
#' @keywords internal
validate_images <- function(images) {
  for (img in images) {
    # Check if it's a URL (starts with http:// or https://)
    if (grepl("^https?://", img)) {
      # For URLs, just check basic format - actual validation would require web request
      if (!grepl("^https?://[^\\s]+\\.(png|jpg|jpeg|svg|gif|webp)$", img, ignore.case = TRUE)) {
        warning(glue::glue("URL '{img}' may not point to a valid image format"))
      }
    } else {
      # For local files, check existence
      if (!file.exists(img)) {
        stop(glue::glue("Image file does not exist: {img}"))
      }
      
      # Check file extension
      if (!grepl("\\.(png|jpg|jpeg|svg|gif|webp)$", img, ignore.case = TRUE)) {
        warning(glue::glue("File '{img}' may not be a supported image format"))
      }
    }
  }
}

#' Include hex.css dependency
#'
#' Includes the hex.css file as an HTML dependency
#'
#' @return An htmltools HTML dependency object
#' @export
hex_dependency <- function() {
  # Try to find the package directory
  pkg_dir <- tryCatch({
    system.file("", package = "hexwall")
  }, error = function(e) {
    # If package not installed, look for inst/ directory
    if (file.exists("inst/hex.css")) {
      return("inst")
    } else if (file.exists("hex.css")) {
      return(".")
    } else {
      stop("Cannot find hex.css file")
    }
  })
  
  htmltools::htmlDependency(
    name = "hex-css",
    version = "1.0.0",
    src = pkg_dir,
    stylesheet = "hex.css"
  )
}

#' Attach hex.css dependency to hex_wall
#'
#' @param tag An htmltools tag object
#' @return The tag with hex.css dependency attached
#' @keywords internal
attach_hex_dependency <- function(tag) {
  htmltools::tagList(
    hex_dependency(),
    tag
  )
}

# Keep old function name for backward compatibility
#' @rdname hex_wall
#' @export
hextile <- function(images, class = NULL, ...) {
  .Deprecated("hex_wall", package = "hexwall", 
              msg = "hextile() is deprecated. Use hex_wall(images = ...) instead.")
  hex_wall(images = images, class = class, ...)
}