library(SPARQL)
library(xts)

#Where to look
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

#### House Prices - London ####

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
HPlondon$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPlondon <- xts(x=HPlondon, order.by=HPlondon$ukhpi_refMonth)


#### House Prices - Scotland ####

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
HPscotland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPscotland <- xts(x=HPscotland, order.by=HPscotland$ukhpi_refMonth)


#### House Prices - Wales ####

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
HPwales$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPwales <- xts(x=HPwales, order.by=HPwales$ukhpi_refMonth)


#### House Prices - Northern Ireland ####

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
HPnorthern_ireland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPnorthern_ireland <- xts(x=HPnorthern_ireland, order.by=HPnorthern_ireland$ukhpi_refMonth)


#### House Prices - England ####

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
HPengland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPengland <- xts(x=HPengland, order.by=HPengland$ukhpi_refMonth)


#### House Prices - North East ####

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
HPnortheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length=318, by="1 month") - 1

#Convert to xts
HPnortheast <- xts(x=HPnortheast, order.by=HPnortheast$ukhpi_refMonth)


#### House Prices - North West ####

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
HPnorthwest$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length=285, by="1 month") - 1

#Convert to xts
HPnorthwest <- xts(x=HPnorthwest, order.by=HPnorthwest$ukhpi_refMonth)


#### House Prices - Yorkshire & the Humber ####

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
HPyork$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPyork <- xts(x=HPyork, order.by=HPyork$ukhpi_refMonth)


#### House Prices - East Midlands ####

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
HPeastmid$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPeastmid <- xts(x=HPeastmid, order.by=HPeastmid$ukhpi_refMonth)


#### House Prices - West Midlands ####

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
HPwestmid$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length=285, by="1 month") - 1

#Convert to xts
HPwestmid <- xts(x=HPwestmid, order.by=HPwestmid$ukhpi_refMonth)


#### House Prices - East ####

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
HPeast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length=318, by="1 month") - 1

#Convert to xts
HPeast <- xts(x=HPeast, order.by=HPeast$ukhpi_refMonth)


#### House Prices - South East ####

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
HPsoutheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length=318, by="1 month") - 1

#Convert to xts
HPsoutheast <- xts(x=HPsoutheast, order.by=HPsoutheast$ukhpi_refMonth)


#### House Prices - South West ####

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
HPsouthwest$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length=345, by="1 month") - 1

#Convert to xts
HPsouthwest <- xts(x=HPsouthwest, order.by=HPsouthwest$ukhpi_refMonth)

