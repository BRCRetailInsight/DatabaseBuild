
## UK Countries

#import shapefiles
gbcountries <- readOGR(dsn = file.path("Countries_December_2016_Full_Clipped_Boundaries_in_Great_Britain.shp"), stringsAsFactors = F)
nicountries <- readOGR(dsn = file.path("OSNI_Open_Data_Largescale_Boundaries__NI_Outline.shp"), stringsAsFactors = F)

#Prepare shapefile variables for merging
gbcountries <- subset(gbcountries, select = -c(objectid,ctry16cd,ctry16nmw,bng_e,bng_n,long,lat,st_areasha,st_lengths))
nicountries <- subset(nicountries, select = -c(ID,Area_SqKM,OBJECTID))
names(nicountries)[names(nicountries)=="NAME"] <- "ctry16nm"

#merge shapefiles
row.names(nicountries) <- paste("nicountries", row.names(nicountries), sep="_")
row.names(gbcountries) <- paste("gbcountries", row.names(gbcountries), sep="_")
gbcountries <- spTransform(gbcountries, CRS("+proj=longlat +datum=WGS84"))
nicountries <- spTransform(nicountries, CRS("+proj=longlat +datum=WGS84"))
ukcountries <- spRbind(gbcountries,nicountries)

#create country database
countrycalcs <- data.frame("ctry16nm" = c("England", "Scotland", "Wales", "Outline of Northern Ireland"),
                           "Unemployment" = c(tail(unemp$`Unemployment Rate England`, 1), tail(unemp$`Unemployment Rate Scotland`, 1), tail(unemp$`Unemployment Rate Wales`, 1), tail(unemp$`Unemployment Rate Northern Ireland`, 1)),
                           "Employment" = c(tail(employ$`Employment Total England`, 1), tail(employ$`Employment Total Scotland`, 1), tail(employ$`Employment Total Wales`, 1), tail(employ$`Employment Total Northern Ireland`, 1)),
                           "Workforce Jobs" = c(tail(nomiswfjobsenglandcount$obs_value.value, 1), tail(nomiswfjobsscotlandcount$obs_value.value, 1), tail(nomiswfjobswalescount$obs_value.value, 1), NA),
                           "Number of Retailers" = c(tail(nomisenterprisesenglandtotal$Total, 1), tail(nomisenterprisesscotlandtotal$Total, 1), tail(nomisenterpriseswalestotal$Total, 1), tail(nomisenterprisesnitotal$Total, 1)),
                           "Number of Shops" = c(tail(nomisunitsenglandtotal$Total, 1), tail(nomisunitsscotlandtotal$Total, 1), tail(nomisunitswalestotal$Total, 1), tail(nomisunitsnitotal$Total, 1)),
                           "Median Hourly Wage - Whole Economy" = c(AsheEnglandAll$X__4, AsheScotlandAll$X__4, AsheWalesAll$X__4, AsheNorthIreAll$X__4),
                           "Median Hourly Wage - Retail" = c(NA, AsheScotlandRetail$X__4, AsheWalesRetail$X__4, NA),
                           "Average House Price" = c(tail(HPengland$`House Price Average - England`, 1), tail(HPscotland$`House Price Average - Scotland`, 1), tail(HPwales$`House Price Average - Wales`, 1), tail(HPnorthern_ireland$`House Price Average - Northern Ireland`, 1)),
                           "GVA" = c(tail(GVAengland$`GVA - England`, 1), tail(GVAscot$`GVA - Scotland`, 1), tail(GVAwales$`GVA - Wales`, 1), tail(GVANI$`GVA - Northern Ireland`, 1)),
                           "GVA per Head" = c(tail(GVAperheadengland$`GVA per Head - England`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadNI$`GVA per Head - Northern Ireland`, 1)), 
                           stringsAsFactors = TRUE)

#merge variables from excel imported data to spatial dataframe.
ukcountries <- merge(ukcountries, countrycalcs, by.x = "ctry16nm", by.y = "ctry16nm")

#change name of Northern Ireland
ukcountries@data$ctry16nm[4] <- "Northern Ireland"

#Simplify map to reduce memory use
gc()
ukcountries <- rmapshaper::ms_simplify(ukcountries)

#create colour palette for continuous colour variation (adjust number to how many intervals you want)
pal1 <- colorBin("Greens", countrycalcs$Unemployment.Rate.England, 9, pretty = TRUE)


## UK NUTS1 Regions

#import shapefiles
ukregions <- readOGR(dsn = file.path("NUTS_Level_1_January_2018_Full_Extent_Boundaries_in_the_United_Kingdom.shp"), stringsAsFactors = F)

#create regional database
regioncalcs <- data.frame("nuts118cd" = c("UKC", "UKD", "UKE", "UKF", "UKG", "UKH", "UKI", "UKJ", "UKK", "UKL", "UKM", "UKN"),
                          "Unemployment" = c(tail(unemp$`Unemployment Rate North East`, 1), tail(unemp$`Unemployment Rate North West`, 1), tail(unemp$`Unemployment Rate Yorkshire & the Humber`, 1), tail(unemp$`Unemployment Rate East Midlands`, 1), tail(unemp$`Unemployment Rate West Midlands`, 1), tail(unemp$`Unemployment Rate East`, 1), tail(unemp$`Unemployment Rate London`, 1), tail(unemp$`Unemployment Rate South East`, 1), tail(unemp$`Unemployment Rate South West`, 1), tail(unemp$`Unemployment Rate Wales`, 1), tail(unemp$`Unemployment Rate Scotland`, 1), tail(unemp$`Unemployment Rate Northern Ireland`, 1)),
                          "Employment" = c(tail(employ$`Employment Total North East`, 1), tail(employ$`Employment Total North West`, 1), tail(employ$`Employment Total Yorkshire & the Humber`, 1), tail(employ$`Employment Total East Midlands`, 1), tail(employ$`Employment Total West Midlands`, 1), tail(employ$`Employment Total East`, 1), tail(employ$`Employment Total London`, 1), tail(employ$`Employment Total South East`, 1), tail(employ$`Employment Total South West`, 1), tail(employ$`Employment Total Wales`, 1), tail(employ$`Employment Total Scotland`, 1), tail(employ$`Employment Total Northern Ireland`, 1)),
                          "Median Hourly Wage - Whole Economy" = c(AsheNorthEastAll$X__4, AsheNorthWestAll$X__4, AsheYorkhumbAll$X__4, AsheEastMidAll$X__4, AsheWestMidAll$X__4, AsheEastAll$X__4, AsheLondonAll$X__4, AsheSouthEastAll$X__4, AsheSouthWestAll$X__4, AsheWalesAll$X__4, AsheScotlandAll$X__4, AsheNorthIreAll$X__4),
                          "Median Hourly Wage - Retail" = c(AsheNorthEastRetail$X__4, AsheNorthWestRetail$X__4, AsheYorkhumbRetail$X__4, AsheEastMidRetail$X__4, AsheWestMidRetail$X__4, AsheEastRetail$X__4, AsheLondonRetail$X__4, AsheSouthEastRetail$X__4, AsheSouthWestRetail$X__4, AsheWalesRetail$X__4, AsheScotlandRetail$X__4, NA),
                          "Average House Price" = c(tail(HPnortheast$`House Price Average - North East`, 1), tail(HPnorthwest$`House Price Average - North West`, 1), tail(HPyork$`House Price Average - Yorkshire & the Humber`, 1), tail(HPeastmid$`House Price Average - East Midlands`, 1), tail(HPwestmid$`House Price Average - West Midlands`, 1), tail(HPeast$`House Price Average - East`, 1), tail(HPlondon$`House Price Average - London`, 1), tail(HPsoutheast$`House Price Average - South East`, 1), tail(HPsouthwest$`House Price Average - South West`, 1), tail(HPwales$`House Price Average - Wales`, 1), tail(HPscotland$`House Price Average - Scotland`, 1), tail(HPnorthern_ireland$`House Price Average - Northern Ireland`, 1)),
                          "GVA" = c(tail(GVANE$`GVA - North East`, 1), tail(GVANW$`GVA - North West`, 1), tail(GVAyork$`GVA - Yorkshire & The Humber`, 1), tail(GVAEM$`GVA - East Midlands`, 1), tail(GVAWM$`GVA - West Midlands`, 1), tail(GVAE$`GVA - East`, 1), tail(GVALondon$`GVA - London`, 1), tail(GVASE$`GVA - South East`, 1), tail(GVASW$`GVA - South West`, 1), tail(GVAwales$`GVA - Wales`, 1), tail(GVAscot$`GVA - Scotland`, 1), tail(GVANI$`GVA - Northern Ireland`, 1)),
                          "GVA per Head" = c(tail(GVAperheadNE$`GVA per Head - North East`, 1), tail(GVAperheadNW$`GVA per Head - North West`, 1), tail(GVAperheadyork$`GVA per Head - Yorkshire & The Humber`, 1), tail(GVAperheadEM$`GVA per Head - East Midlands`, 1), tail(GVAperheadWM$`GVA per Head - West Midlands`, 1), tail(GVAperheadE$`GVA per Head - East`, 1), tail(GVAperheadLondon$`GVA per Head - London`, 1), tail(GVAperheadSE$`GVA per Head - South East`, 1), tail(GVAperheadSW$`GVA per Head - South West`, 1), tail(GVAperheadwales$`GVA per Head - Wales`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadNI$`GVA per Head - Northern Ireland`, 1)),
                          stringsAsFactors = FALSE)

#merge variables from excel imported data to spatial dataframe. 
ukregions <- merge(ukregions, regioncalcs, by.x = "nuts118cd", by.y = "nuts118cd")

#Simplify map to reduce memory use
gc()
ukregions <- rmapshaper::ms_simplify(ukregions)

#create colour palette for continuous colour variation (adjust number to how many intervals you want)
pal2 <- colorBin("Greens", regioncalcs$Unemployment.Rate.North.East, 9, pretty = TRUE)

#Create nation data for download button (map tab)
englanddata <- merge(to.yearly(unemp$`Unemployment Rate England`, OHLC = FALSE), to.yearly(employ$`Employment Total England`, OHLC = FALSE), nomiswfjobsenglandcountxts$`WF Jobs count - England`, nomisenterprisesenglandtotalxts$`Businesses - England`, nomisunitsenglandtotalxts$`Local Units - England`, GVAengland$`GVA - England`, GVAperheadengland$`GVA per Head - England`, all = TRUE, fill = NA)
englanddata <- data.frame(date=index(englanddata), coredata(englanddata))
walesdata <- merge(to.yearly(unemp$`Unemployment Rate Wales`, OHLC = FALSE), to.yearly(employ$`Employment Total Wales`, OHLC = FALSE), nomiswfjobswalescountxts$`WF Jobs count - Wales`, nomisenterpriseswalestotalxts$`Businesses - Wales`, nomisunitswalestotalxts$`Local Units - Wales`, GVAwales$`GVA - Wales`, GVAperheadwales$`GVA per Head - Wales`, all = TRUE, fill = NA)
walesdata <- data.frame(date=index(walesdata), coredata(walesdata))
scotlanddata <- merge(to.yearly(unemp$`Unemployment Rate Scotland`, OHLC = FALSE), to.yearly(employ$`Employment Total Scotland`, OHLC = FALSE), nomiswfjobsscotlandcountxts$`WF Jobs count - Scotland`, nomisenterprisesscotlandtotalxts$`Businesses - Scotland`, nomisunitsscotlandtotalxts$`Local Units - Scotland`, GVAscot$`GVA - Scotland`, GVAperheadscot$`GVA per Head - Scotland`, all = TRUE, fill = NA)
scotlanddata <- data.frame(date=index(scotlanddata), coredata(scotlanddata))
nidata <- merge(to.yearly(unemp$`Unemployment Rate Northern Ireland`, OHLC = FALSE), to.yearly(employ$`Employment Total Northern Ireland`, OHLC = FALSE), nomisenterprisesnitotalxts$`Businesses - Northern Ireland`, nomisunitsnitotalxts$`Local Units - Northern Ireland`, GVANI$`GVA - Northern Ireland`, GVAperheadNI$`GVA per Head - Northern Ireland`, all = TRUE, fill = NA)
nidata <- data.frame(date=index(nidata), coredata(nidata))

# Create region data for download button (map tab)
nedata <- merge(to.yearly(unemp$`Unemployment Rate North East`, OHLC = FALSE), to.yearly(employ$`Employment Total North East`, OHLC = FALSE), GVANE$`GVA - North East`, GVAperheadNE$`GVA per Head - North East`, ashe_regionxts$`North East Total Median_OBS_VALUE`, ashe_regionxts$`North East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
nedata <- data.frame(date=index(nedata), coredata(nedata))
nwdata <- merge(to.yearly(unemp$`Unemployment Rate North West`, OHLC = FALSE), to.yearly(employ$`Employment Total North West`, OHLC = FALSE), GVANW$`GVA - North West`, GVAperheadNW$`GVA per Head - North West`, ashe_regionxts$`North West Total Median_OBS_VALUE`, ashe_regionxts$`North West Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
nwdata <- data.frame(date=index(nwdata), coredata(nwdata))
yorkdata <- merge(to.yearly(unemp$`Unemployment Rate Yorkshire & the Humber`, OHLC = FALSE), to.yearly(employ$`Employment Total Yorkshire & the Humber`, OHLC = FALSE), GVAyork$`GVA - Yorkshire & The Humber`, GVAperheadyork$`GVA per Head - Yorkshire & The Humber`, ashe_regionxts$`Yorkshire and The Humber Total Median_OBS_VALUE`, ashe_regionxts$`Yorkshire and The Humber Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
yorkdata <- data.frame(date=index(yorkdata), coredata(yorkdata))
emdata <- merge(to.yearly(unemp$`Unemployment Rate East Midlands`, OHLC = FALSE), to.yearly(employ$`Employment Total East Midlands`, OHLC = FALSE), GVAEM$`GVA - East Midlands`, GVAperheadEM$`GVA per Head - East Midlands`, ashe_regionxts$`East Midlands Total Median_OBS_VALUE`, ashe_regionxts$`East Midlands Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
emdata <- data.frame(date=index(emdata), coredata(emdata))
wmdata <- merge(to.yearly(unemp$`Unemployment Rate West Midlands`, OHLC = FALSE), to.yearly(employ$`Employment Total West Midlands`, OHLC = FALSE), GVAWM$`GVA - West Midlands`, GVAperheadWM$`GVA per Head - West Midlands`, ashe_regionxts$`West Midlands Total Median_OBS_VALUE`, ashe_regionxts$`West Midlands Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
wmdata <- data.frame(date=index(wmdata), coredata(wmdata))
edata <- merge(to.yearly(unemp$`Unemployment Rate East`, OHLC = FALSE), to.yearly(employ$`Employment Total East`, OHLC = FALSE), GVAE$`GVA - East`, GVAperheadE$`GVA per Head - East`, ashe_regionxts$`East Total Median_OBS_VALUE`, ashe_regionxts$`East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
edata <- data.frame(date=index(edata), coredata(edata))
londondata <- merge(to.yearly(unemp$`Unemployment Rate London`, OHLC = FALSE), to.yearly(employ$`Employment Total London`, OHLC = FALSE), GVALondon$`GVA - London`, GVAperheadLondon$`GVA per Head - London`, ashe_regionxts$`London Total Median_OBS_VALUE`, ashe_regionxts$`London Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
londondata <- data.frame(date=index(londondata), coredata(londondata))
sedata <- merge(to.yearly(unemp$`Unemployment Rate South East`, OHLC = FALSE), to.yearly(employ$`Employment Total South East`, OHLC = FALSE), GVASE$`GVA - South East`, GVAperheadSE$`GVA per Head - South East`, ashe_regionxts$`South East Total Median_OBS_VALUE`, ashe_regionxts$`South East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
sedata <- data.frame(date=index(sedata), coredata(sedata))
swdata <- merge(to.yearly(unemp$`Unemployment Rate South West`, OHLC = FALSE), to.yearly(employ$`Employment Total South West`, OHLC = FALSE), GVASW$`GVA - South West`, GVAperheadSW$`GVA per Head - South West`, ashe_regionxts$`South West Total Median_OBS_VALUE`, ashe_regionxts$`South West Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
swdata <- data.frame(date=index(swdata), coredata(swdata))
