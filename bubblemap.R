#!/usr/bin/env Rscript
#Author Sean Donnellan (modified from data2vis original)
# get filename to work on
# test if there is at least one argument: if not, return an error
if (interactive()) {
  interactive <- interactive()
  interactive
  #probably running on my laptop so set these manually for testing through gui (rstudio)
  filename <- "rtr-geo.csv"
  setwd("/Users/donnels/overview/Chapter-R/data")
} else {
  #probably running in a docker or similar
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args)==0) {
    stop("At least one argument must be supplied (input file)", call.=FALSE)
  } else {
    filename <- args[1]
  }
}
# Load libraries
library(leaflet)

#because the example is to read a csv instead of creating its own data
data_rtr <- read.csv(
  filename,
  header = TRUE,
  sep = ",",
  strip.white = TRUE,
  stringsAsFactors = FALSE
  )

#data_rtr$LAT <- jitter(data_rtr$LAT, factor = 0.0001)
#data_rtr$LON <- jitter(data_rtr$LON, factor = 0.0001)

# Initialize the leaflet map:
m <- leaflet() %>%
  #setView(lng=8.58783973, lat=50.097930, zoom=17) %>%
  # Add two tiles
  addProviderTiles(
    "Esri.WorldImagery",
    group = "Satelite",
    options = providerTileOptions(noWrap = TRUE)
    ) %>%
  addTiles(
    options = providerTileOptions(noWrap = TRUE),
    group = "Infrastructure"
    ) %>%
  # Add router marker group
  addCircleMarkers(
    data = data_rtr,
    lng = ~LON,
    lat = ~LAT,
    popup = ~IP,
    label = ~NAME,
    radius = 16,
    color = "black",
    fillColor = "green",
    stroke = TRUE,
    fillOpacity = 0.8,
    group = "Routers",
    clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier = 4)
    ) %>%
  # Add the control widget
  addLayersControl(
    overlayGroups = c("Routers"),
    baseGroups = c("Infrastructure" , "Satelite"),
    options = layersControlOptions(collapsed = FALSE)
    )

m

# save the widget in a html file if needed.
library(htmlwidgets)
saveWidget(
  m,
  selfcontained = TRUE,
  title = "GNPP Routers",
  file=paste0( getwd(), "/rtr-geo.html")
  )
