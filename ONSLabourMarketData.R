
#### Unemployment & Employment Data ####

#Time Series - Unemployment Definitions
# "MGSX" = Unemployment Rate UK (SA)
# "ZSFB" = Unemployment Rate Northern Ireland (SA)
# "YCNM" = Unemployment Rate Wales (SA)
# "YCNL" = Unemployment Rate England (SA)
# "YCNN" = Unemployment Rate Scotland (SA)
# "YCNE" = Unemployment Rate Yorkshire & the Humber (SA)
# "YCND" = Unemployment Rate North West (SA)
# "YCNC" = Unemployment Rate North East (SA)
# "YCNG" = Unemployment Rate West Midlands (SA)
# "YCNF" = Unemployment Rate East Midlands (SA)
# "YCNI" = Unemployment Rate London (SA)
# "YCNH" = Unemployment Rate East (SA)
# "YCNK" = Unemployment Rate South West (SA)
# "YCNJ" = Unemployment Rate South East (SA)

unemp <- pdfetch_ONS(c("MGSX", "YCNC", "ZSFB", "YCNM", "YCNL", "YCNN", "YCNE", "YCND", "YCNG", "YCNF", "YCNI", "YCNH", "YCNK", "YCNJ"), "lms")

colnames(unemp) <- c("Unemployment Rate UK", "Unemployment Rate Northern Ireland", "Unemployment Rate Wales",
                     "Unemployment Rate England", "Unemployment Rate Scotland", "Unemployment Rate Yorkshire & the Humber",
                     "Unemployment Rate North West", "Unemployment Rate North East", "Unemployment Rate West Midlands",
                     "Unemployment Rate East Midlands", "Unemployment Rate London", "Unemployment Rate East",
                     "Unemployment Rate South West", "Unemployment Rate South East")

#Time Series - Employment Definitions
# "YCBE" = Employment Total UK (SA)
# "YCJP" = Employment Total North East (SA)
# "YCJQ" = Employment Total North West (SA)
# "YCJR" = Employment Total Yorkshire & the Humber (SA)
# "YCJS" = Employment Total East Midlands (SA)
# "YCJT" = Employment Total West Midlands (SA)
# "YCJU" = Employment Total East (SA)
# "YCJV" = Employment Total London (SA)
# "YCJW" = Employment Total South East (SA)
# "YCJX" = Employment Total South West (SA)
# "YCJY" = Employment Total England (SA)
# "YCJZ" = Employment Total Wales (SA)
# "YCKA" = Employment Total Scotland (SA)
# "ZSFG" = Employment Total Northern Ireland (SA)

employ <- pdfetch_ONS(c("YCBE", "YCJP", "YCJQ", "YCJR", "YCJS", "YCJT", "YCJU", "YCJV", "YCJW", "YCJX", "YCJY", "YCJZ", "YCKA", "ZSFG"), "lms")

colnames(employ) <- c("Employment Total UK", "Employment Total North East", "Employment Total North West",
                      "Employment Total Yorkshire & the Humber", "Employment Total East Midlands", "Employment Total West Midlands",
                      "Employment Total East", "Employment Total London", "Employment Total South East",
                      "Employment Total South West", "Employment Total England", "Employment Total Wales",
                      "Employment Total Scotland", "Employment Total Northern Ireland")

