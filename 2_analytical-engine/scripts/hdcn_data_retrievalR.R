# -------------------------------------------------------------------
# Download USGS daily flow for all Oregon stations in your table
# -------------------------------------------------------------------

# 1) Install & load required packages
librarian::shelf(dataRetrieval,
                 dplyr,
                 lubridate,
                 stringr,
                 readr,
                 purrr,
                 tidyr)

# 2) Read in your station list
#    Adjust the path and sep if your file is elsewhere or uses commas.
stations <- read.table("stations.tsv",
                       sep     = "\t",
                       header  = TRUE,
                       stringsAsFactors = FALSE)

# 3) Filter to Oregon
or_stations <- subset(stations, STATE == "OR")

# 4) Loop over each site, download daily flow, and save to CSV
#    You can change startDate/endDate as needed.
startDate <- "1900-01-01"
endDate   <- format(Sys.Date(), "%Y-%m-%d")

for (i in seq_len(nrow(or_stations))) {
  site <- or_stations$STATION.ID[i]  # or STATION_ID depending on your column name
  
  message("Downloading site ", site, " (", i, " of ", nrow(or_stations), ")...")
  
  # Wrap in tryCatch so one failure doesn't stop the loop
  tryCatch({
    flow_df <- readNWISdv(siteNumbers = site,
                          parameterCd = "00060",
                          startDate   = startDate,
                          endDate     = endDate)
    
    # Standardize column names if you wish:
    # names(flow_df) <- c("agency_cd", "site_no", "Date", "Flow_cfs", "Flow_cd")
    
    # Build output filename
    out_fname <- paste0("USGS_", site, "_daily.csv")
    
    # Write to CSV (no row names)
    write.csv(flow_df,
              file      = out_fname,
              row.names = FALSE)
    
    message("  → Saved to ", out_fname)
    
  }, error = function(e) {
    warning("  ! Failed for site ", site, ": ", conditionMessage(e))
  })
}

message("All done.")
