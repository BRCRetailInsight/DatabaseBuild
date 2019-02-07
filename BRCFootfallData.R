#### Footfall Data ####

FF=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!k6:k",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!q6:q",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_12mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!s6:s",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!h6:h",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!j6:j",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!i6:i",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!m6:m",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!o6:o",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!n6:n",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF=cbind(FF,FF_3mth,FF_12mth,FF_Highst,FF_ShoppingCentre,FF_RetailPark,FF_Highst3mth,FF_ShoppingCentre3mth,FF_RetailPark3mth)


names(FF)[1]="Footfall UK (% yoy change):BRC-Springboard"
names(FF)[2]="Footfall UK 3 month average (% yoy change):BRC-Springboard"
names(FF)[3]="Footfall UK 12 month average (% yoy change):BRC-Springboard"
names(FF)[4]="Footfall High Street (% yoy change):BRC-Springboard"
names(FF)[5]="Footfall Shopping Centre (% yoy change):BRC-Springboard"
names(FF)[6]="Footfall Retail Park (% yoy change):BRC-Springboard"
names(FF)[7]="Footfall High Street 3 month average (% yoy change):BRC-Springboard"
names(FF)[8]="Footfall Shopping Centre 3 month average (% yoy change):BRC-Springboard"
names(FF)[9]="Footfall Retail Park 3 month average (% yoy change):BRC-Springboard"
