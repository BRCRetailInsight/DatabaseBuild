
#Number of Shops


nomisunits <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_141_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100", flatten = TRUE)
nomisunits <- as.data.frame(nomisunits$obs)
nomisunits <- nomisunits[c(-1:-5, -7:-8, -10:-20, -23:-29)]

nomisunitsyears <- seq(as.Date("2010-12-31"), length = 9, by = "years")

nomisunitsengland <- subset(nomisunits, geography.description == "England")
nomisunitsenglandtotal <- nomisunitsengland %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))

nomisunitsenglandtotal <- nomisunitsenglandtotal[c(-1)]
nomisunitsenglandtotalxts <- xts(x = nomisunitsenglandtotal, order.by = nomisunitsyears)
colnames(nomisunitsenglandtotalxts) <- "Local Units - England"

nomisunitsuk <- subset(nomisunits, geography.description == "United Kingdom")
nomisunitsuktotal <- nomisunitsuk %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisunitsuktotal <- nomisunitsuktotal[c(-1)]
nomisunitsuktotalxts <- xts(x = nomisunitsuktotal, order.by = nomisunitsyears)
colnames(nomisunitsuktotalxts) <- "Local Units - UK"

nomisunitswales <- subset(nomisunits, geography.description == "Wales")
nomisunitswalestotal <- nomisunitswales %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisunitswalestotal <- nomisunitswalestotal[c(-1)]
nomisunitswalestotalxts <- xts(x = nomisunitswalestotal, order.by = nomisunitsyears)
colnames(nomisunitswalestotalxts) <- "Local Units - Wales"

nomisunitsni <- subset(nomisunits, geography.description == "Northern Ireland")
nomisunitsnitotal <- nomisunitsni %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisunitsnitotal <- nomisunitsnitotal[c(-1)]
nomisunitsnitotalxts <- xts(x = nomisunitsnitotal, order.by = nomisunitsyears)
colnames(nomisunitsnitotalxts) <- "Local Units - Northern Ireland"

nomisunitsscotland <- subset(nomisunits, geography.description == "Scotland")
nomisunitsscotlandtotal <- nomisunitsscotland %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisunitsscotlandtotal <- nomisunitsscotlandtotal[c(-1)]
nomisunitsscotlandtotalxts <- xts(x = nomisunitsscotlandtotal, order.by = nomisunitsyears)
colnames(nomisunitsscotlandtotalxts) <- "Local Units - Scotland"


#Number of Businesses
nomisenterprises <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_142_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100", flatten = TRUE)
nomisenterprises <- as.data.frame(nomisenterprises$obs)
nomisenterprises <- nomisenterprises[c(-1:-5, -7:-8, -10:-20, -23:-29)]

nomisenterprisesengland <- subset(nomisenterprises, geography.description == "England")
nomisenterprisesenglandtotal <- nomisenterprisesengland %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisenterprisesenglandtotal <- nomisenterprisesenglandtotal[c(-1)]
nomisenterprisesenglandtotalxts <- xts(x = nomisenterprisesenglandtotal, order.by = nomisunitsyears)
colnames(nomisenterprisesenglandtotalxts) <- "Businesses - England"

nomisenterprisesuk <- subset(nomisenterprises, geography.description == "United Kingdom")
nomisenterprisesuktotal <- nomisenterprisesuk %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisenterprisesuktotal <- nomisenterprisesuktotal[c(-1)]
nomisenterprisesuktotalxts <- xts(x = nomisenterprisesuktotal, order.by = nomisunitsyears)
colnames(nomisenterprisesuktotalxts) <- "Businesses - UK"

nomisenterpriseswales <- subset(nomisenterprises, geography.description == "Wales")
nomisenterpriseswalestotal <- nomisenterpriseswales %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisenterpriseswalestotal <- nomisenterpriseswalestotal[c(-1)]
nomisenterpriseswalestotalxts <- xts(x = nomisenterpriseswalestotal, order.by = nomisunitsyears)
colnames(nomisenterpriseswalestotalxts) <- "Businesses - Wales"

nomisenterprisesni <- subset(nomisenterprises, geography.description == "Northern Ireland")
nomisenterprisesnitotal <- nomisenterprisesni %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisenterprisesnitotal <- nomisenterprisesnitotal[c(-1)]
nomisenterprisesnitotalxts <- xts(x = nomisenterprisesnitotal, order.by = nomisunitsyears)
colnames(nomisenterprisesnitotalxts) <- "Businesses - Northern Ireland"

nomisenterprisesscotland <- subset(nomisenterprises, geography.description == "Scotland")
nomisenterprisesscotlandtotal <- nomisenterprisesscotland %>%
  dplyr::group_by(time.description) %>%
  dplyr::summarise(Total = sum(obs_value.value))
nomisenterprisesscotlandtotal <- nomisenterprisesscotlandtotal[c(-1)]
nomisenterprisesscotlandtotalxts <- xts(x = nomisenterprisesscotlandtotal, order.by = nomisunitsyears)
colnames(nomisenterprisesscotlandtotalxts) <- "Businesses - Scotland"
