
# load all required packages

packages=c("pdfetch",
          "xts",
          "readxl",
          "bsts",
          "nomisr",
          "jsonlite",
          "httr",
          "SPARQL",
          "utils",
          "tframePlus",
          "rgdal",
          "maptools",
          "rmapshaper",
          "leaflet",
          "reshape",
          "dplyr",
          "extrafont",
          "shiny",
          "dygraphs",
          "shinydashboard",
          "DT",
          "leaflet.extras",
          "timevis",
          "bindrcpp")
          
lapply(packages, require, character.only = TRUE)        

source("BoEdata.R") # yes
source("ONSGDPdata.R")# yes
source("ONSAWEdata.R")# yes
source("ONSLabourMarketData.R") #yes
source("NomisWFJobsData.R") # yes
source("ONSShopsData.R") # yes
require(dplyr)
source("ASHEData.R") #yes
source("LandRegistryHPData.R") #yes
source("ONSCPIData.R")#yes
source("ProductivityData.R")#yes
source("ONSRetailJobsData.R")#yes
source("ONSRegionalGVAData.R") #yes
source("ONSRSIData.R")

#BRC data series

source("BRCRSMData.R") #yes
source("BRCFootfallData.R") #yes
source("BRCREMData.R") #YES
source("BRCSPIData.R")# YES
source("BRCDRIData.R")

#File merge
source("FileMerge.R")

#prepare data for maps
source("MapData.R")

#add release dates of monitors
source("ReleaseCalendar.R")
