# HRU Spatial Analysis for Oregon (Region 17)

# 1. Loading packages needed
# Run the line below if you don't have the package "librarian" installed

#install.packages("librarian")

librarian::shelf(
  sf,        # For spatial data handling
  leaflet,   # For interactive maps
  dplyr,     # For data manipulation
  readr      # For reading data files
)
