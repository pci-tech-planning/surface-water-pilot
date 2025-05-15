# -------------------------------------------------------------------
# Download USGS daily flow for all Oregon stations in your table
# -------------------------------------------------------------------
# This script downloads daily flow data from the USGS NWIS database.
# It uses the dataRetrieval package to access the NWIS API.
# The script assumes you have a list of station IDs in a tab-separated, .csv, or .xlsx file.
# -------------------------------------------------------------------

# 0) If you haven't already, install the "librarian" package to manage your packages.
#    You can install it with: install.packages("librarian")
#    This script uses the "shelf" function to load packages.
#    The "shelf" function will install any missing packages for you.
#    If you don't want to use "librarian", you can manually install and load the packages below.
#    Uncomment the lines below to install the required packages.

# install.packages("librarian")

# 1. Install & load required packages
librarian::shelf(dataRetrieval,# for downloading data from NWIS
                 dplyr,# for data manipulation
                 lubridate,# for date manipulation
                 stringr,# for string manipulation
                 readr,# for reading data
                 purrr,# for functional programming
                 tidyr,# for data tidying
                 here,# for file paths
                 readxl, # for reading Excel files
                 janitor)# for cleaning column names

# 2. Read in your station list
# I use the "here" package to set the working directory to the project root.
# This assumes you have a "data" folder in your project root.
# You can change the path to your station list as needed.
# If you have a .csv file, use read_csv() instead of read_excel().
# If you have a .xlsx file, use read_excel() instead of read_csv().
# If you have a .tsv file, use read.table() with sep = "\t".
# If you have a .txt file, use read.table() with sep = "\t" or sep = " ".


stations <- read_excel(here("2_analytical-engine","data", "HCDN-2009_Station_Info.xlsx"), 
                       sheet = "Sheet1") %>% clean_names()

# 3. Filter to Oregon stations
or_stations <- subset(stations, state == "OR")
site_ids <- or_stations$station_id

# 4) Check for duplicates
duplicates <- site_ids[duplicated(site_ids)]
if (length(duplicates) > 0) {
  message("Duplicate site IDs found: ", paste(duplicates, collapse = ", "))
} else {
  message("No duplicate site IDs found.")
}

# 5. Query USGS metadata for daily discharge availability (00060)
meta <- whatNWISdata(siteNumber = site_ids,
                     service = "dv",
                     parameterCd = "00060")

# 6. Filter for valid records with non-missing dates
meta_clean <- meta[!is.na(meta$begin_date) & !is.na(meta$end_date), ]

# Optional: limit to unique site/parameter combinations
meta_clean <- unique(meta_clean[, c("site_no", "begin_date", "end_date")])

# 7. Download data for each site and save as CSV
output_dir <- here("2_analytical-engine","data", "hdcn-data")

# Create folder if missing
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)


for (i in seq_len(nrow(meta_clean))) {
  site <- meta_clean$site_no[i]
  startDate <- meta_clean$begin_date[i]
  endDate   <- meta_clean$end_date[i]
  
  message(sprintf("Downloading site %s (%s to %s)...", site, startDate, endDate))
  
  tryCatch({
    df <- readNWISdv(siteNumbers = site,
                     parameterCd = "00060",
                     startDate   = startDate,
                     endDate     = endDate)
    
    # Save output to CSV
    out_file <- file.path(output_dir, sprintf("USGS_%s_daily.csv", site))
    write.csv(df, file = out_file, row.names = FALSE)
    message("  → Saved to ", out_file)
  }, error = function(e) {
    warning("  ! Failed for site ", site, ": ", conditionMessage(e))
  })
}

message("✅ All downloads complete.")



  
  
  
  
  
  
  
  
  
  