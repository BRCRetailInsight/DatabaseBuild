
#### House Prices ####

# London

#Where to look
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/london> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/london> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPlondon <- SPARQL(endpoint,query)$results

#Create date variable
HPlondon$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPlondon), by="1 month") - 1

#Convert to xts
HPlondon <- xts(x=HPlondon[3:6], order.by=HPlondon$ukhpi_refMonth)
colnames(HPlondon) <- c("House Price Average - London", "House Price Index - London", "House Price YoY - London", "House Price MoM - London")


# Scotland

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/scotland> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/scotland> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPscotland <- SPARQL(endpoint,query)$results

#Create date variable
HPscotland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPscotland), by="1 month") - 1

#Convert to xts
HPscotland <- xts(x=HPscotland[3:6], order.by=HPscotland$ukhpi_refMonth)
colnames(HPscotland) <- c("House Price Average - Scotland", "House Price Index - Scotland", "House Price YoY - Scotland", "House Price MoM - Scotland")


# House Prices - Wales

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/wales> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/wales> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPwales <- SPARQL(endpoint,query)$results

#Create date variable
HPwales$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPwales), by="1 month") - 1

#Convert to xts
HPwales <- xts(x=HPwales[3:6], order.by=HPwales$ukhpi_refMonth)
colnames(HPwales) <- c("House Price Average - Wales", "House Price Index - Wales", "House Price YoY - Wales", "House Price MoM - Wales")


# House Prices - Northern Ireland

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/northern-ireland> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/northern-ireland> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnorthern_ireland <- SPARQL(endpoint,query)$results

#Create date variable
HPnorthern_ireland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPnorthern_ireland), by="1 month") - 1

#Convert to xts
HPnorthern_ireland <- xts(x=HPnorthern_ireland[3:6], order.by=HPnorthern_ireland$ukhpi_refMonth)
colnames(HPnorthern_ireland) <- c("House Price Average - Northern Ireland", "House Price Index - Northern Ireland", "House Price YoY - Northern Ireland", "House Price MoM - Northern Ireland")


# House Prices - England

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/england> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/england> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPengland <- SPARQL(endpoint,query)$results

#Create date variable
HPengland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPengland), by="1 month") - 1

#Convert to xts
HPengland <- xts(x=HPengland[3:6], order.by=HPengland$ukhpi_refMonth)
colnames(HPengland) <- c("House Price Average - England", "House Price Index - England", "House Price YoY - England", "House Price MoM - England")


# House Prices - North East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/north-east> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/north-east> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnortheast <- SPARQL(endpoint,query)$results

#Create date variable
HPnortheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPnortheast), by="1 month") - 1

#Convert to xts
HPnortheast <- xts(x=HPnortheast[3:6], order.by=HPnortheast$ukhpi_refMonth)
colnames(HPnortheast) <- c("House Price Average - North East", "House Price Index - North East", "House Price YoY - North East", "House Price MoM - North East")


# House Prices - North West

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/north-west> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/north-west> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnorthwest <- SPARQL(endpoint,query)$results

#Create date variable
HPnorthwest$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length.out = nrow(HPnorthwest), by="1 month") - 1

#Convert to xts
HPnorthwest <- xts(x=HPnorthwest[3:6], order.by=HPnorthwest$ukhpi_refMonth)
colnames(HPnorthwest) <- c("House Price Average - North West", "House Price Index - North West", "House Price YoY - North West", "House Price MoM - North West")


# House Prices - Yorkshire & the Humber

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/yorkshire-and-the-humber> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/yorkshire-and-the-humber> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPyork <- SPARQL(endpoint,query)$results

#Create date variable
HPyork$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPyork), by="1 month") - 1

#Convert to xts
HPyork <- xts(x=HPyork[3:6], order.by=HPyork$ukhpi_refMonth)
colnames(HPyork) <- c("House Price Average - Yorkshire & the Humber", "House Price Index - Yorkshire & the Humber", "House Price YoY - Yorkshire & the Humber", "House Price MoM - Yorkshire & the Humber")


# House Prices - East Midlands

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/east-midlands> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/east-midlands> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPeastmid <- SPARQL(endpoint,query)$results

#Create date variable
HPeastmid$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPeastmid), by="1 month") - 1

#Convert to xts
HPeastmid <- xts(x=HPeastmid[3:6], order.by=HPeastmid$ukhpi_refMonth)
colnames(HPeastmid) <- c("House Price Average - East Midlands", "House Price Index - East Midlands", "House Price YoY - East Midlands", "House Price MoM - East Midlands")


# House Prices - West Midlands

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/west-midlands> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/west-midlands> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPwestmid <- SPARQL(endpoint,query)$results

#Create date variable
HPwestmid$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length.out = nrow(HPwestmid), by="1 month") - 1

#Convert to xts
HPwestmid <- xts(x=HPwestmid[3:6], order.by=HPwestmid$ukhpi_refMonth)
colnames(HPwestmid) <- c("House Price Average - West Midlands", "House Price Index - West Midlands", "House Price YoY - West Midlands", "House Price MoM - West Midlands")


# House Prices - East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/east-of-england> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/east-of-england> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPeast <- SPARQL(endpoint,query)$results

#Create date variable
HPeast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPeast), by="1 month") - 1

#Convert to xts
HPeast <- xts(x=HPeast[3:6], order.by=HPeast$ukhpi_refMonth)
colnames(HPeast) <- c("House Price Average - East", "House Price Index - East", "House Price YoY - East", "House Price MoM - East")


# House Prices - South East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/south-east> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/south-east> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPsoutheast <- SPARQL(endpoint,query)$results

#Create date variable
HPsoutheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPsoutheast), by="1 month") - 1

#Convert to xts
HPsoutheast <- xts(x=HPsoutheast[3:6], order.by=HPsoutheast$ukhpi_refMonth)
colnames(HPsoutheast) <- c("House Price Average - South East", "House Price Index - South East", "House Price YoY - South East", "House Price MoM - South East")


# House Prices - South West

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/south-west> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/south-west> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPsouthwest <- SPARQL(endpoint,query)$results

#Create date variable
HPsouthwest$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPsouthwest), by="1 month") - 1

#Convert to xts

HPsouthwest <- xts(x=HPsouthwest, order.by=HPsouthwest$ukhpi_refMonth)

