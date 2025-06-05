#' @importFrom magrittr %<>% %>%
#' @rawNamespace import(data.table, except = c(month, year))
#' @author Michael Jensen
NULL

# Suppress specific warnings for this function
utils::globalVariables(c(
  "year","schoolyear", "schoolyear_autumn", ".", "County", "esdname", "districtname",
  "measurevalue", "numerator", "denominator", "measure", "organizationlevel",
  "html_elements", "html_attr", "read.wa.Socrata"
))

#' Fetch OSPI Kindergarten readiness scores
#'
#' @param schoolyears vector of initial years of schoolyears, i.e. `c(2023, 2024, 2025)` for multiple years
#' @return data table with combined results from all requested school years
#'
#' @import RSocrata
#' @export
get_k_readiness <- function(schoolyears) {

  # Filter URLs for the requested school years
  selected_urls <- kready_urls[schoolyear_autumn %in% get(schoolyears)]

  # Define ESD query parameters
  esd_params <- c(
    "Northwest%20Educational%20Service%20District%20189",
    "Puget%20Sound%20Educational%20Service%20District%20121",
    "Olympic%20Educational%20Service%20District%20114"
  )

  # Helper function to fetch data for one URL-ESD combination
  fetch_esd_data <- function(url, year, esd_param) {
    query_url <- paste0(url, "?organizationlevel=District&esdname=", esd_param)

    tryCatch({
      data <- read.wa.Socrata(query_url)
      if (nrow(data) > 0) {
        data$schoolyear_autumn <- year
        return(data)
      } else {
        return(NULL)
      }
    }, error = function(e) {
      warning(paste("Failed to fetch data for school year", year, "and ESD", esd_param, ":", e$message))
      return(NULL)
    })
  }

  # Fetch data for all URL-ESD combinations
  all_reported <- mapply(
    function(url, year) {
      lapply(esd_params, function(esd) fetch_esd_data(url, year, esd))
    },
    selected_urls$kready_url,
    selected_urls$schoolyear_autumn,
    SIMPLIFY = FALSE
  )

  # Flatten the nested list structure and remove NULL elements
  all_reported <- unlist(all_reported, recursive = FALSE)
  all_reported <- all_reported[!sapply(all_reported, is.null)]

  # Check if we have any data
  if (length(all_reported) == 0) {
    warning("No data retrieved for any of the requested school years")
    return(data.table())
  }

  # Combine all results and process
  reported <- rbindlist(all_reported, use.names = TRUE, fill = TRUE) %>%
    .[, c("numerator", "denominator") := lapply(.SD, as.integer), .SDcols = c("numerator", "denominator")] %>%
    .[, County := fcase(
      grepl("121$", esdname) & grepl(county_schooldist_rgx$King,      districtname),  "King",
      grepl("114$", esdname) & grepl(county_schooldist_rgx$Kitsap,    districtname),  "Kitsap",
      grepl("121$", esdname) & grepl(county_schooldist_rgx$Pierce,    districtname),  "Pierce",
      grepl("189$", esdname) & grepl(county_schooldist_rgx$Snohomish, districtname),  "Snohomish"
    )] %>%
    .[!is.na(County)] %>%
    .[measure == "NumberofDomainsReadyforKindergarten" & measurevalue == "6"] %>%
    .[, c("esdname", "organizationlevel") := NULL] %>%
    setorder(schoolyear, County)

  return(reported)
}
