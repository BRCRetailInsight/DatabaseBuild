
#Workforce Jobs
nomiswfjobs <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_189_1.data.json?geography=2092957699,2092957698,2092957701,2092957700&industry=146800687&employment_status=1&measure=1,2&measures=20100", flatten = TRUE)
nomiswfjobs <- as.data.frame(nomiswfjobs$obs)
nomiswfjobs <- nomiswfjobs[c(-1:-5, -7:-12, -14:-19, -21, -23:-29)]

nomisyears <- seq(as.Date("2015-12-31"), length = 3, by = "years")

nomiswfjobsengland <- subset(nomiswfjobs, geography.description == "England")
nomiswfjobsenglandcount <- subset(nomiswfjobsengland, measure.description == "Count")
nomiswfjobsenglandpercent <- subset(nomiswfjobsengland, measure.description == "Industry percentage")
nomiswfjobsenglandcount <- nomiswfjobsenglandcount[c(-1:-3)]
nomiswfjobsenglandpercent <- nomiswfjobsenglandpercent[c(-1:-3)]
nomiswfjobsenglandcountxts <- xts(x = nomiswfjobsenglandcount, order.by = nomisyears)
nomiswfjobsenglandpercentxts <- xts(x = nomiswfjobsenglandpercent, order.by = nomisyears)
colnames(nomiswfjobsenglandcountxts) <- "WF Jobs count - England"
colnames(nomiswfjobsenglandpercentxts) <- "WF Jobs % - England"

nomiswfjobsgb <- subset(nomiswfjobs, geography.description == "Great Britain")
nomiswfjobsgbcount <- subset(nomiswfjobsgb, measure.description == "Count")
nomiswfjobsgbcount <- nomiswfjobsgbcount[c(-1:-3)]
nomiswfjobsgbpercent <- subset(nomiswfjobsgb, measure.description == "Industry percentage")
nomiswfjobsgbpercent <- nomiswfjobsgbpercent[c(-1:-3)]
nomiswfjobsgbcountxts <- xts(x = nomiswfjobsgbcount, order.by = nomisyears)
nomiswfjobsgbpercentxts <- xts(x = nomiswfjobsgbpercent, order.by = nomisyears)
colnames(nomiswfjobsgbcountxts) <- "WF Jobs count - Great Britain"
colnames(nomiswfjobsgbpercentxts) <- "WF Jobs % - Great Britain"

nomiswfjobswales <- subset(nomiswfjobs, geography.description == "Wales")
nomiswfjobswalescount <- subset(nomiswfjobswales, measure.description == "Count")
nomiswfjobswalespercent <- subset(nomiswfjobswales, measure.description == "Industry percentage")
nomiswfjobswalescount <- nomiswfjobswalescount[c(-1:-3)]
nomiswfjobswalespercent <- nomiswfjobswalespercent[c(-1:-3)]
nomiswfjobswalescountxts <- xts(x = nomiswfjobswalescount, order.by = nomisyears)
nomiswfjobswalespercentxts <- xts(x = nomiswfjobswalespercent, order.by = nomisyears)
colnames(nomiswfjobswalescountxts) <- "WF Jobs count - Wales"
colnames(nomiswfjobswalespercentxts) <- "WF Jobs % - Wales"

nomiswfjobsscotland <- subset(nomiswfjobs, geography.description == "Scotland")
nomiswfjobsscotlandcount <- subset(nomiswfjobsscotland, measure.description == "Count")
nomiswfjobsscotlandpercent <- subset(nomiswfjobsscotland, measure.description == "Industry percentage")
nomiswfjobsscotlandcount <- nomiswfjobsscotlandcount[c(-1:-3)]
nomiswfjobsscotlandpercent <- nomiswfjobsscotlandpercent[c(-1:-3)]
nomiswfjobsscotlandcountxts <- xts(x = nomiswfjobsscotlandcount, order.by = nomisyears)
nomiswfjobsscotlandpercentxts <- xts(x = nomiswfjobsscotlandpercent, order.by = nomisyears)
colnames(nomiswfjobsscotlandcountxts) <- "WF Jobs count - Scotland"
colnames(nomiswfjobsscotlandpercentxts) <- "WF Jobs % - Scotland"
