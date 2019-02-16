

#### Retail Sales Index ####

# Volume data: RETAIL SALES INDEX: VOLUME SEASONALLY ADJUSTED PERCENTAGE CHANGE ON SAME MONTH A YEAR EARLIER
# "J5EB" = "RSI Volumes - All retailing including automotive fuel"
# "J45U" = "RSI Volumes - All retailing excluding automotive fuel"
# "IDOB" = "RSI Volumes - Predominantly food stores"
# "IDOC" = "RSI Volumes - Predominantly non-food stores"
# "IDOA" = "RSI Volumes - Non-Specialised stores"
# "IDOG" = "RSI Volumes - Textile, clothing and footwear stores"
# "IDOH" = "RSI Volumes - Households goods stores"
# "IDOD" = "RSI Volumes - Other Non-Food Stores" 
# "J5DK" = "RSI Volumes - Non-Store retailing"
# "JO4C" = "RSI Volumes - Fuel"


rsi_vol <- pdfetch_ONS(c("J5EB","J45U", "IDOB","IDOC","IDOA","IDOG","IDOH","IDOH","IDOD","JO4C","J5DK"), "DRSI")
#rsi_vol <- to.monthly(rsi_vol, OHLC=FALSE)

colnames(rsi_vol) <- c("RSI Volumes - All retail inc auto fuel", "RSI Volumes - All retail exc auto fuel", "RSI Volumes - Predom food stores", "RSI Volumes - Predom non-food stores", "RSI Volumes - Non-Specialised stores", "RSI Volumes - Textile, clothing and footwear stores", "RSI Volumes - Households goods stores", "RSI Volumes - Other Non-Food Stores", "RSI Volumes - Non-Store retail", "RSI Volumes - Fuel")

# Retail sales volume weights (2017)

# W_IDOB: Predominantly food stores = 39.0
# W_IDOC: Total predominantly non-food stores = 41.58
# W_IDOA: Non-Specialised stores = 8.57
# W_IDOG: Textile, clothing and footwear stores = 11.97
# W_IDOH: Households goods stores = 8.2
# W_IDOD: Other Non-Food Stores = 12.84
# W_J5DK: Non-Store retailing = 9.65
# W_JO4C: Fuel = 9.77
# W_J45U: Total ex-fuel = 90.23

W_IDOB = 39.0
W_IDOC = 41.58
W_IDOA = 8.57
W_IDOG = 11.97
W_IDOH = 8.2
W_IDOD = 12.84
W_J5DK = 9.65
W_JO4C = 9.77
W_J45U = 90.23

# Value Data

# "J59v" = "RSI Values - All retailing including automotive fuel"
# "J3L2" = "RSI Values - All retailing excluding automotive fuel"
# "J3L3" = "RSI Values - All retailing excluding automotive fuel: Large Businesses"
# "J3L4" = "RSI Values - All retailing excluding automotive fuel: Small Businesses"

# "EAIA" = "RSI Values - Predominantly food stores"
# "EAIB" = "RSI Values - Total predominantly non-food stores"
# "EAIN" = "RSI Values - Non-Specialised stores"
# "EAIC" = "RSI Values - Textile, clothing and footwear stores"
# "EAID" = "RSI Values - Households goods stores"
# "EAIF" = "RSI Values - Other Non - Food Stores" 
# "J58L" = "RSI Values - Non-Store retailing"
# "IYP9" = "RSI Values - Fuel"

# "EAIT" = "RSI Values - Food Stores: Large Businesses"
# "EAIU" = "RSI Values - Food Stores: Small Businesses"
# "EAIV" = "RSI Values - Total Predominantly Non-Food Stores: Large Businesses"
# "EAIW" = "RSI Values - Total Predominantly Non-Food Stores: Small Businesses"
# "J58M" = "RSI Values - Non-Store retailing: Large Businesses"
# "j58N" = "RSI Values - Non-Store retailing: Small Businesses"
# "KP3T" = "RSI Values - Internet"

rsi_val <- pdfetch_ONS(c("J59v","J3L2","J3L3","J3L4","EAIA","EAIB","EAIN","EAIC","EAIC","EAID","EAIF","J58L","IYP9","EAIT","EAIU","EAIV","EAIW","J58M","j58N","KP3T"), "DRSI")
# rsi_val <- to.monthly(rsi_val, OHLC=FALSE)

colnames(rsi_val) <- c("RSI Values - All retail inc auto fuel",
                       "RSI Values - All retail exc auto fuel",
                       "RSI Values - All retail exc auto fuel: Large Businesses",
                       "RSI Values - All retail exc auto fuel: Small Businesses",
                       "RSI Values - Predom food stores",
                       "RSI Values - Predom non-food stores",
                       "RSI Values - Non-Specialised stores",
                       "RSI Values - Textile, clothing and footwear stores",
                       "RSI Values - Households goods stores",
                       "RSI Values - Other Non - Food Stores",
                       "RSI Values - Non-Store retail",
                       "RSI Values - Fuel",
                       "RSI Values - Food Stores: Large Businesses",
                       "RSI Values - Food Stores: Small Businesses",
                       "RSI Values - Predom Non-Food Stores: Large Businesses",
                       "RSI Values - Predom Non-Food Stores: Small Businesses",
                       "RSI Values - Non-Store retail: Large Businesses",
                       "RSI Values - Non-Store retail: Small Businesses",
                       "RSI Values - Internet")

# Value weights

# "W_J59v" = "All retailing including automotive fuel"=387969
# "W_J3L2" = "All retailing excluding automotive fuel"=350847
# "W_J3L3" = "All retailing excluding automotive fuel: Large Businesses" =275477
# "W_J3L4" = "All retailing excluding automotive fuel: Small Businesses" =75370

# "W_EAIA"= "Predominantly food stores" = 154446
# "W_EAIB" = "Total predominantly non-food stores"=163199
# "W_EAIN" = "Non-Food Non-Specialised stores"=34180
# "W_EAIC" = "Textile, clothing and footwear stores"=45728
# "W_EAID" = "Households goods stores"=32674
# "W_EAIF" = "Other Non - Food Stores" =50617
# "W_J58L" = "Non-Store retailing"=33202
# "W_IYP9" = "Fuel"= 36849

# "W_EAIT" = "Food Stores: Large Businesses"=132149
# "W_EAIU" = "Food Stores: Small Businesses"=22296
# "W_EAIV" = "Total Predominantly Non-Food Stores: Large Businesses"=121676
# "W_EAIW" = "Total Predominantly Non-Food Stores: Small Businesses"=41524
# "W_J58M" = "Non-Store retailing: Large Businesses"=21652
# "W_j58N" = "Non-Store retailing: Small Businesses"=11550


W_J59v=387969
W_J3L2=350847
W_J3L3 =275477
W_J3L4 =75370

W_EAIA=154446
W_EAIB=163199
W_EAIN=34180
W_EAIC=45728
W_EAID=32674
W_EAIF=50617
W_J58L=33202
W_IYP9= 36849

W_EAIT=132149
W_EAIU=22296
W_EAIV=121676
W_EAIW=41524
W_J58M=21652
W_J58N=11550
