source("APIgetGDP.R")

#### Graph GDP ####

# Create BRC Colour Palette
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")

#Monthly Graphs
dygraph(GDP_mom) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

dygraph(GDP_yoy) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

