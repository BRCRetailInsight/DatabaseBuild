library(dplyr)
library(pdfetch)
library(xts)
library(readxl)

# ONS consumer price inflation

#### ONS Consumer Price Inflation Annual Data (MM23) ####

# "D7G7" = All Items

###ALL FOOD
# "D7G8" = Food and Non-Alcoholic Beverages
# "D7GM" = Alcoholic Beverages

###AMBIENT FOOD
# "D7GM" = Alcoholoic Beverages
# "L7JM" = Rice
# "L7JN" = Flours and other cereals
# "L7JP" = Other bakery products
# "L7JT" = Pasta products and couscous
# "L7JU" = Breakfast cereals and other cereal products
# "D7GL" = Non-Alcoholic Beverages
# "D7HO" = Sugar, jam, honey, syrups, chocolates and confectionery
# "L7L6" = potato crisps and snacks

###FRESH Food
# "L7JO" = Bread
# "L7JQ" = Pizza and quiche
# "D7HJ" = Fish
# "D7HM" = Fruit
# "D7HI" = Meat
# "D7HK" = Milk, Cheese and Eggs
# "L7KS" = Butter
# "L7L5" = Potatoes
# "L7L2" = Fresh or chilled vegetables other than potatoes and other tubers


###CLOTHING & FOOTWEAR
# "D7GA" = Clothing and Footwear

###HEALTH & BEAUTY
# "D7JD" = Appliances and Products for Personal Care
# "D7NP" = Pharmaceutical products

###DIY, GARDENING & HARDWARE
# "D7GY" = Tools and Equipment for House and Garden

###FURNITURE & FLOORING
# "D7GU" = Furniture, Furnishings and Carpets
# "D7GV" = Household Textiles

###ELECTRICALS
# "D7IF" = Major Appliances and Small Electric Goods
# "D7IZ" = Reception and reproduction of sound and pictures
# "D7J2" = Photographic, cinematographic and optical equipment
# "D7J3" = Data processing equipment

###BOOKS, STATIONERY & HOME ENTERTAINMENT
# "D7O3" = Books, Newspapers and Stationery
# "D7J6" = Recording media

###OTHER NON-FOOD
# "D7NX" = Games, Toys and Hobbies
# "D7NY" = Equipment for sport and open-air recreation
# "L7SL" = Purchase of pets 
# "L7SM" = Products for Pets
# "D7O8" = Personal Effects
# "D7GN" = Tobacco

#Get CPI Data
cpi <- pdfetch_ONS(c("D7G7", 
                     "D7G8", "D7GM", 
                     "L7JM", "L7JN", "L7JP", "L7JT", "L7JU", "D7GL", "D7HO", "L7L6",
                     "L7JO", "L7JQ", "D7HJ", "D7HM", "D7HI", "D7HK", "L7KS", "L7L5", "L7L2",
                     "D7GA",
                     "D7JD", "D7NP",
                     "D7GY",
                     "D7GU", "D7GV",
                     "D7IF", "D7IZ", "D7J2", "D7J3",
                     "D7O3", "D7J6",
                     "D7NX", "D7NY", "L7SL", "L7SM", "D7O8", "D7GN"
                     ), "MM23")


#### ONS Consumer Price Inflation Weights (MM23) ####

# "CHZQ" = All Items

###ALL FOOD
# "CHZR" = Food and Non-Alcoholic Beverages
# "CJUZ" = Alcoholic Beverages

###AMBIENT FOOD
# "CJUZ" = Alcoholoic Beverages
# "L83B" = Rice
# "L83C" = Flours and other cereals
# "L83S" = Other bakery products
# "L844" = Pasta products and couscous
# "L846" = Breakfast cereals and other cereal products
# "CJUY" = Non-Alcoholic Beverages
# "CJWI" = Sugar, jam, honey, syrups, chocolates and confectionery
# "L859" = potato crisps and snacks

###FRESH Food
# "L83H" = Bread
# "L83T" = Pizza and quiche
# "CJWD" = Fish
# "CJWG" = Fruit
# "CJWC" = Meat
# "CJWE" = Milk, Cheese and Eggs
# "L84P" = Butter
# "L858" = Potatoes
# "L853" = Fresh or chilled vegetables other than potatoes and other tubers


###CLOTHING & FOOTWEAR
# "CHZT" = Clothing and Footwear

###HEALTH & BEAUTY
# "CJYO" = Appliances and Products for Personal Care
# "CJYA" = Pharmaceutical products

###DIY, GARDENING & HARDWARE
# "CJVK" = Tools and Equipment for House and Garden

###FURNITURE & FLOORING
# "CJVG" = Furniture, Furnishings and Carpets
# "CJVH" = Household Textiles

###ELECTRICALS
# "CJXI" = Major Appliances and Small Electric Goods
# "CJYC" = Reception and reproduction of sound and pictures
# "CJYD" = Photographic, cinematographic and optical equipment
# "CJYE" = Data processing equipment

###BOOKS, STATIONERY & HOME ENTERTAINMENT
# "ICVT" = Books, Newspapers and Stationery
# "CJYF" = Recording media

###OTHER NON-FOOD
# "ICVP" = Games, Toys and Hobbies
# "ICVQ" = Equipment for sport and open-air recreation
# "L8CZ" = Purchase of pets 
# "L8D2" = Products for Pets
# "CJVX" = Personal Effects
# "CJWP" = Tobacco

#Get CPI Weights
w_cpi <- pdfetch_ONS(c("CHZQ", 
                       "CHZR", "CJUZ", 
                       "L83B", "L83C", "L83S", "L844", "L846", "CJUY", "CJWI", "L859", 
                       "L83H", "L83T", "CJWD", "CJWG", "CJWC", "CJWE", "L84P", "L858", "L853", 
                       "CHZT", 
                       "CJYO", "CJYA", 
                       "CJVK", 
                       "CJVG", "CJVH", 
                       "CJXI", "CJYC", "CJYD", "CJYE", 
                       "ICVT", "CJYF", 
                       "ICVP", "ICVQ", "L8CZ", "L8D2", "CJVX", "CJWP"
                       ), "MM23")


#merge and fill in blank datapoints between weights changes (fills in points after last recorded point)
cpi <- merge(cpi, w_cpi, join = "outer")
cpi <- na.locf(cpi)
#cpi <- na.locf(cpi, fromLast = TRUE)

#### Build variables to match SPI ####

#All Items#
cpi_all <- cpi$D7G7

#FOOD#
cpi_food <- (cpi$D7G8 * (cpi$CHZR / (cpi$CHZR + cpi$CJUZ)) + (cpi$D7GM * (cpi$CJUZ / (cpi$CHZR + cpi$CJUZ))))

#Ambient Food#


#Fresh Food#


#### Plot CPI Variables ####

cpi_plot_1 <- merge(cpi_all, cpi_food, join = "outer")
plot(cpi_plot_1, plot.type="s", legend.loc = "topleft")


####  scrap  ####

#fill missing data with last datapoint...
xts_last <- na.locf(xts2)

