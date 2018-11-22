# Load Previous script for data collation
source("APIgetOUTPUT.R")

library(dygraphs)
library(plm)

# Create BRC Colour Palette
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")

#### Create Output Graph ####

# Merge xts files
All_Output <- merge(output_all, output_retail, join = "outer")

# Create Index of series at starting point
All_Outputyoy <- (All_Output - lag(All_Output, k = 4)) / lag(All_Output, k = 4) * 100

#Plot Graph
dygraph(All_Outputyoy) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

#### Create GVA Graph ####

# Merge xts files
All_GVA <- merge(gva_all, gva_retail, join = "outer")

# Create Index of series at starting point
All_GVAyoy <- (All_GVA - lag(All_GVA, k = 4)) / lag(All_GVA, k = 4) * 100

#Plot Graph
dygraph(All_GVAyoy) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

