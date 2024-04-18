###############################################################################
### R script for cleaning the original dataset retrieved from GBIF database ###
### https://www.gbif.org/occurrence/download/0190555-240321170329656        ###
### The downloaded dataset has 1049411 observations across Canada           ###
### 0189800-240321170329656.csv (Size: 575 MB) is the name of the dataset   ###
### Use random sampling without replacement to filter out 5000 data points  ### 
###############################################################################
library(tidyverse)
library(vroom)
library(sf)
library(polyCub)

set.seed(105)
# Reading in the occurrences data
occurrence_eagles <- vroom("0190555-240321170329656.csv", quote="") |>
  filter(stateProvince == 'British Columbia') |>
  select(species, decimalLatitude, decimalLongitude) |>
  drop_na(decimalLatitude, decimalLongitude)

# Clean the data to remove duplicates and points lie outside the window
occurrence_eagles <- st_as_sf(occurrence_eagles, coords = c("decimalLongitude", "decimalLatitude")) # Convert the occurence dataset into a sf object to transform the coordinate system
st_crs(occurrence_eagles) <- st_crs("+proj=longlat +datum=WGS84") # Set the original coordinate system for the sf object 
occurrence_eagles <- st_transform(occurrence_eagles, st_crs("+proj=aea +lat_0=45 +lon_0=-126 +lat_1=50 +lat_2=58.5 +x_0=1000000 +y_0=0 +datum=NAD83 +units=m +no_defs")) # Convert it to the new system 
coords <- st_coordinates(occurrence_eagles) # Gather the new longitude and latitude data
occurrence_eagles <- cbind(occurrence_eagles, coords) # Join the longitude and latitude back to the dataset 

load("BC_Covariates.Rda")
window <- as.owin(DATA$Window) # Create an owin object with the window in the covariates dataset so it can be used to create the ppp object later
occurrence_eagles_clean <- unique(occurrence_eagles[inside.owin(occurrence_eagles$X, occurrence_eagles$Y, w = window), ]) # Check which points lie inside the window and subset the occurrence_eagles dataset to keep only points inside the window

# Random sampling without replacement to filter out 5000 data points
occurrence_eagles_clean |>
  sample_n(5000, replace=F) |>
  write_csv("eagles_bc.csv")
