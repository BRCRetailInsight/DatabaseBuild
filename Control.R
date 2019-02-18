
### load all required packages

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
          "bindrcpp",
          "DataCombine")
          
lapply(packages, require, character.only = TRUE)        

###load embargo dates

embargoes=read.csv("embargodates.csv")


### Run files for different dataseries

    source("BoEdata.R")
    source("ONSGDPdata.R")
    source("ONSAWEdata.R")
    source("ONSLabourMarketData.R")
    source("NomisWFJobsData.R")
    source("ONSShopsData.R")
    
    require(dplyr)
    source("ASHEData.R") 
    source("LandRegistryHPData.R") 
    source("ONSCPIData.R")
    source("ProductivityData.R")
    
    #set latest quarter for jobs file e.g. "sep2018" - data comes out with a 3 month lag and is only produced quarterly
    jobs_quarter="dec2018"
    source("ONSRetailJobsData.R")
    source("ONSRegionalGVAData.R") 
    source("ONSRSIData.R")
    
    #BRC data series
    
    source("BRCRSMData.R")
    source("BRCFootfallData.R")
    source("BRCREMData.R") 
    source("BRCSPIData.R")
    source("BRCDRIData.R")
    
    #File merge
    source("FileMerge.R")
    
    #prepare data for maps
    source("MapData.R")
    
    #add release dates of monitors
    source("ReleaseCalendar.R")




