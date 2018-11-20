#run two files which collate the data
#BUt FIRST check "enddateRSM" in the APIgetSPI file -> it will need manually changing!!
source("APIgetCPI.R")
source("APIgetSPI.R")

library(dygraphs)

#### Plot CPI vs SPI Graphs ####

# Create BRC Colour Palette
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")


All_Inflation <- merge(cpi_all["2006-12-31/"], spi_all["2006-12-31/"], join = "outer")
dygraph(All_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

NonFood_Inflation <- merge(cpi_nonfood["2006-12-31/"], spi_nonfood["2006-12-31/"], join = "outer")
dygraph(NonFood_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Food_Inflation <- merge(cpi_food["2006-12-31/"], spi_food["2006-12-31/"], join = "outer")
dygraph(Food_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Ambient_Inflation <- merge(cpi_ambient["2006-12-31/"], spi_ambient["2006-12-31/"], join = "outer")
dygraph(Ambient_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Fresh_Inflation <- merge(cpi_fresh["2006-12-31/"], spi_fresh["2006-12-31/"], join = "outer")
dygraph(Fresh_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Books_Inflation <- merge(cpi_books["2006-12-31/"], spi_books["2006-12-31/"], join = "outer")
dygraph(Books_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

DIY_Inflation <- merge(cpi_diy["2006-12-31/"], spi_diy["2006-12-31/"], join = "outer")
dygraph(DIY_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Electricals_Inflation <- merge(cpi_electricals["2006-12-31/"], spi_electricals["2006-12-31/"], join = "outer")
dygraph(Electricals_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Furniture_Inflation <- merge(cpi_furniture["2006-12-31/"], spi_furniture["2006-12-31/"], join = "outer")
dygraph(Furniture_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Clothing_Inflation <- merge(cpi_clothing["2006-12-31/"], spi_clothes["2006-12-31/"], join = "outer")
dygraph(Clothing_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

Health_Inflation <- merge(cpi_health["2006-12-31/"], spi_health["2006-12-31/"], join = "outer")
dygraph(Health_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

OthNonFood_Inflation <- merge(cpi_othnonfood["2006-12-31/"], spi_othnonfood["2006-12-31/"], join = "outer")
dygraph(OthNonFood_Inflation) %>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)
