

#### Database Merge ####

# merge xts objects into one big dataset and create dataframe for table - Monthly Data
databasemonthly <- merge(spi_all_embargo_xts[,3:14], RSM_embargo_xts[,3:16], FF_embargo_xts[,3:11], REM_embargo_xts[,3:10], DRI_embargo_xts[,3:5], cpi_all, cpi_ambient, cpi_books, cpi_clothing, cpi_diy, cpi_electricals, cpi_food, cpi_fresh, cpi_furniture, cpi_health, cpi_nonfood, cpi_othnonfood, awe, boe_ccards, boe_conscredit, boe_gbp, boe_house, boe_secured, HPengland, HPwales, HPscotland, HPnorthern_ireland, HPlondon, HPeast, HPeastmid, HPwestmid, HPnortheast, HPnorthwest, HPsoutheast, HPsouthwest, HPyork, employ, unemp, GVAmonthly_mom, GVAmonthly_yoy, rsi_val, rsi_vol, all = TRUE, fill = NA)
databasemonthlydf <- data.frame(date=index(databasemonthly), coredata(databasemonthly))

# merge xts objects into one big dataset and create dataframe for table - Quarterly Data
databasequarterly <- merge(GVAquarterly_all, GVAquarterly_retail, output_all, output_retail, empjobsquarterly_all, empjobsquarterly_retail, selfjobsquarterly_all, selfjobsquarterly_retail, gdpquarterly, all = TRUE, fill = NA)
databasequarterlydf <- data.frame(date=index(databasequarterly), coredata(databasequarterly))

# merge xts objects into one big dataset and create dataframe for table - Yearly Data
databaseyearly <- merge(nomiswfjobsenglandcountxts, nomiswfjobsenglandpercentxts, nomiswfjobsgbcountxts, nomiswfjobsgbpercentxts, nomiswfjobsscotlandcountxts, nomiswfjobsscotlandpercentxts, nomiswfjobswalescountxts, nomiswfjobswalespercentxts, nomisenterprisesenglandtotalxts, nomisenterprisesnitotalxts, nomisenterprisesscotlandtotalxts, nomisenterprisesuktotalxts, nomisenterpriseswalestotalxts, nomisunitsenglandtotalxts, nomisunitsnitotalxts, nomisunitsscotlandtotalxts, nomisunitsuktotalxts, nomisunitswalestotalxts, GVAE, GVAEM, GVAengland, GVALondon, GVANE, GVANI, GVANW, GVAscot, GVASE, GVASW, GVAuk, GVAwales, GVAWM, GVAyork, GVAperheadE, GVAperheadEM, GVAperheadengland, GVAperheadLondon, GVAperheadNE, GVAperheadNI, GVAperheadNW, GVAperheadscot, GVAperheadSE, GVAperheadSW, GVAperheaduk, GVAperheadwales, GVAperheadWM, GVAperheadyork, ashe_regionxts, all = TRUE, fill = NA)
databaseyearlydf <- data.frame(date=index(databaseyearly), coredata(databaseyearly))
