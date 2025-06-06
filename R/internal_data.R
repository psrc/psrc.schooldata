#' @importFrom magrittr %<>% %>%
#' @rawNamespace import(data.table, except = c(month, year))
#' @author Michael Jensen
NULL

# # Create district-to-county regex lookup
# county_schooldist_rgx <- list()
# county_schooldist_rgx$King <- paste(
#   "Auburn", "Bellevue", "Enumclaw", "Federal Way", "Highline", "Issaquah",
#   "Kent", "Lake Washington", "Mercer Island", "Northshore", "Renton",
#   "Riverview", "Seattle", "Shoreline", "Skykomish", "Snoqualmie Valley",
#   "Tahoma", "Tukwila", "Vashon Island", sep="|"
#   )
# county_schooldist_rgx$Kitsap <- paste(
#   "Bainbridge Island", "Central Kitsap", "North Kitsap", "South Kitsap", sep="|"
#   )
# county_schooldist_rgx$Pierce <- paste(
#   "Bethel", "Carbonado", "Clover Park", "Dieringer", "Eatonville", "Fife",
#   "Franklin Pierce", "Orting", "Peninsula", "Puyallup", "Steilacoom West",
#   "Sumner", "Tacoma", "University Place", "White River", sep="|"
#   )
# county_schooldist_rgx$Snohomish <- paste(
#   "Arlington","Darrington", "Edmonds", "Everett", "Granite Falls", "Index",
#   "Lake Stevens", "Lakewood","Marysville", "Monroe", "Mukilteo", "Snohomish",
#   "Stanwood", "Sultan", sep="|"
#   )
#
# # Kindergarten readiness API targets
#
# kready_urls <- data.frame(
#   schoolyear_autumn = c(2011:2019,2021:2024),                    # -- Not collected SY 2020-21
#   kready_url = c("https://data.wa.gov/resource/59cw-kpf6.json",  # 2011-12 first year available via API
#                  "https://data.wa.gov/resource/sedr-qag9.json",  # 2012-13
#                  "https://data.wa.gov/resource/rjgh-459t.json",  # 2013-14
#                  "https://data.wa.gov/resource/yaag-7vv4.json",  # 2014-15
#                  "https://data.wa.gov/resource/8ewp-xtgm.json",  # 2015-16
#                  "https://data.wa.gov/resource/2x4x-bzqs.json",  # 2016-17
#                  "https://data.wa.gov/resource/huwq-t84x.json",  # 2017-18
#                  "https://data.wa.gov/resource/p4sv-js2m.json",  # 2018-19
#                  "https://data.wa.gov/resource/26rj-f9wn.json",  # 2019-20
#                  "https://data.wa.gov/resource/rzgf-vi75.json",  # 2021-22
#                  "https://data.wa.gov/resource/3ji8-ykgj.json",  # 2022-23
#                  "https://data.wa.gov/resource/vumg-9sgs.json",  # 2023-24
#                  "https://data.wa.gov/resource/35cj-2iym.json"   # 2024-25
#   )
# ) %>% setDT()

# usethis::use_data(kready_urls, county_schooldist_rgx, internal=TRUE, overwrite=TRUE) # Makes part of the package; push this to repo
