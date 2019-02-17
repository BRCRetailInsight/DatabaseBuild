#####Database code
##This file is designed to read-in raw survey data and create a database.
##File sources and locations may change and so the code will need updating accordingly.


##set working directory


###identify location of Java file (only needed for running XLconnect)
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_91') 
# for 32-bit version




###set Java parameters 
#options(java.parameters = "-Xmx4g")
#library(XLConnect)




#### Read in Hitwise data (DRI)

files=c("brc_20140830_4w.xls","brc_20140927_4w.xls","brc_20141004_5w.xls","brc_20141101_4w.xls","brc_20141129_4w.xls","brc_20150103_5w.xls","brc_20150131_4w.xls","brc_20150228_4w.xls","brc_20150404_5w.xls","brc_20150502_4w.xls","brc_20150530_4w.xls", "brc_20150704_5w.xls","brc_20150801_4w.xls","brc_20150829_4w.xls", "brc_20151003_5w.xls", "brc_20151031_4w.xls", "brc_20151128_4w.xls","brc_20160102_5w.xls", "brc_20160130_4w.xls", "brc_20160227_4w.xls","brc_20160402_5w.xls", "brc_20160430_4w.xls")
files_1=c("brc_20140830_4w.xls","brc_20140927_4w.xls","brc_20141004_5w.xls","brc_20141101_4w.xls")
files_2=c("brc_20150103_5w.xls","brc_20150131_4w.xls","brc_20150228_4w.xls","brc_20150404_5w.xls","brc_20150502_4w.xls","brc_20150530_4w.xls", "brc_20150704_5w.xls","brc_20150801_4w.xls","brc_20150829_4w.xls")
files_3=c("brc_20151003_5w.xls", "brc_20151031_4w.xls", "brc_20151128_4w.xls","brc_20160102_5w.xls", "brc_20160130_4w.xls", "brc_20160227_4w.xls","brc_20160402_5w.xls", "brc_20160430_4w.xls")



####first set of files
for(j in files_1){

url_hit=paste("https://brc:pah9Hu1u@feeds.hitwise.com/user162/",j,sep="")
loc.hit=paste(j)
download.file(url_hit,loc.hit,mode="wb")

#
 #readHTMLTable:
  
  #readHTMLTable("https://brc:pah9Hu1u@feeds.hitwise.com/user162/", 
   #             skip.rows=1:2)[[1]]$Name -> file.list



#}
###read-in data from sheet

for (i in 1:11 ){

  a=data.frame(read_excel(loc.hit, sheet = i, col_names = TRUE, col_types = NULL, na = "",skip = 0))           
           
  nam=paste(excel_sheets(loc.hit)[i])
  assign(nam,a)
}

### change to long format and rotate
gender$var_name=paste0(gender[,1],"_",gender[,4])
gender=gender[,c(5,2,3)]
gender=melt(gender, id.vars = c("var_name"))
gender$var_name=paste0(gender[,1],"_",gender[,2])
gender=gender[,c(1,3)]
gender_t=data.frame(t(gender))
gender_t=setNames(data.frame(t(gender[,-1])), gender[,1])

age$var_name=paste0(age[,1],"_",age[,4])
age=age[,c(5,2,3)]
age=melt(age, id.vars = c("var_name"))
age$var_name=paste0(age[,1],"_",age[,2])
age=age[,c(1,3)]
age_t=data.frame(t(age))
age_t=setNames(data.frame(t(age[,-1])), age[,1])

mosaic_uk_2009_group$var_name=paste0(mosaic_uk_2009_group[,1],"_",mosaic_uk_2009_group[,4])
mosaic_uk_2009_group=mosaic_uk_2009_group[,c(5,2,3)]
mosaic_uk_2009_group=melt(mosaic_uk_2009_group, id.vars = c("var_name"))
mosaic_uk_2009_group$var_name=paste0(mosaic_uk_2009_group[,1],"_",mosaic_uk_2009_group[,2])
mosaic_uk_2009_group=mosaic_uk_2009_group[,c(1,3)]
mosaic_uk_2009_group_t=data.frame(t(mosaic_uk_2009_group))
mosaic_uk_2009_group_t=setNames(data.frame(t(mosaic_uk_2009_group[,-1])), mosaic_uk_2009_group[,1])

device_group$var_name=paste0(device_group[,1],"_",device_group[,4])
device_group=device_group[,c(5,2,3)]
device_group=melt(device_group, id.vars = c("var_name"))
device_group$var_name=paste0(device_group[,1],"_",device_group[,2])
device_group=device_group[,c(1,3)]
device_group_t=data.frame(t(device_group))
device_group_t=setNames(data.frame(t(device_group[,-1])), device_group[,1])

region$var_name=paste0(region[,1],"_",region[,4])
region=region[,c(5,2,3)]
region=melt(region, id.vars = c("var_name"))
region$var_name=paste0(region[,1],"_",region[,2])
region=region[,c(1,3)]
region_t=data.frame(t(region))
region_t=setNames(data.frame(t(region[,-1])), region[,1])

social_grade$var_name=paste0(social_grade[,1],"_",social_grade[,4])
social_grade=social_grade[,c(5,2,3)]
social_grade=melt(social_grade, id.vars = c("var_name"))
social_grade$var_name=paste0(social_grade[,1],"_",social_grade[,2])
social_grade=social_grade[,c(1,3)]
social_grade_t=data.frame(t(social_grade))
social_grade_t=setNames(data.frame(t(social_grade[,-1])), social_grade[,1])

downstream$var_name=paste0(downstream[,1],"_",downstream[,3])
downstream=downstream[,c(4,2)]
downstream=melt(downstream, id.vars = c("var_name"))
downstream$var_name=paste0(downstream[,1],"_",downstream[,2])
downstream=downstream[,c(1,3)]
downstream_t=data.frame(t(downstream))
downstream_t=setNames(data.frame(t(downstream[,-1])), downstream[,1])

upstream$var_name=paste0(upstream[,1],"_",upstream[,3])
upstream=upstream[,c(4,2)]
upstream=melt(upstream, id.vars = c("var_name"))
upstream$var_name=paste0(upstream[,1],"_",upstream[,2])
upstream=upstream[,c(1,3)]
upstream_t=data.frame(t(upstream))
upstream_t=setNames(data.frame(t(upstream[,-1])), upstream[,1])

names(duration)[1]="var_name"
duration=melt(duration, id.vars = c("var_name"))
duration$var_name=paste0(duration[,1],"_",duration[,2])
duration=duration[,c(1,3)]
duration_t=data.frame(t(duration))
duration_t=setNames(duration_t[-1,],duration[,1])

names(page)[1]="var_name"
page=melt(page, id.vars = c("var_name"))
page$var_name=paste0(page[,1],"_",page[,2])
page=page[,c(1,3)]
page_t=setNames(data.frame(t(page[,-1])), page[,1])

names(visit)[1]="var_name"
visit=melt(visit, id.vars = c("var_name"))
visit$var_name=paste0(visit[,1],"_",visit[,2])
visit=visit[,c(1,3)]
visit_t=setNames(data.frame(t(visit[,-1])), visit[,1])

X=cbind(visit_t,page_t,duration_t,device_group_t,upstream_t,downstream_t,gender_t,age_t,region_t,social_grade_t,mosaic_uk_2009_group_t)

nam=paste(j)
assign(nam,X)

}

sheets=list(page,duration,device_group,upstream,downstream,gender,age,region,social_grade,mosaic_uk_2009_group)

temp=visit

for (k in 1:10){

 temp= merge(temp,as.data.frame(sheets[k]), by.x="var_name",by.y="var_name",all=TRUE)
}

####second set of files


for(j in files_2){
  
  url_hit=paste("https://brc:pah9Hu1u@feeds.hitwise.com/user162/",j,sep="")
  loc.hit=paste(j)
  download.file(url_hit,loc.hit,mode="wb")
  
  #}
  ###read-in data from sheet
  
  for (i in 1:12 ){
    
    a=data.frame(read_excel(loc.hit, sheet = i, col_names = TRUE, col_types = NULL, na = "",skip = 0))           
    
    nam=paste(excel_sheets(loc.hit)[i])
    assign(nam,a)
  }
  
  ### change to long format and rotate
  gender$var_name=paste0(gender[,1],"_",gender[,4])
  gender=gender[,c(5,2,3)]
  gender=melt(gender, id.vars = c("var_name"))
  gender$var_name=paste0(gender[,1],"_",gender[,2])
  gender=gender[,c(1,3)]
  gender_t=data.frame(t(gender))
  gender_t=setNames(data.frame(t(gender[,-1])), gender[,1])
  
  age$var_name=paste0(age[,1],"_",age[,4])
  age=age[,c(5,2,3)]
  age=melt(age, id.vars = c("var_name"))
  age$var_name=paste0(age[,1],"_",age[,2])
  age=age[,c(1,3)]
  age_t=data.frame(t(age))
  age_t=setNames(data.frame(t(age[,-1])), age[,1])
  
  mosaic_uk_2009_group$var_name=paste0(mosaic_uk_2009_group[,1],"_",mosaic_uk_2009_group[,4])
  mosaic_uk_2009_group=mosaic_uk_2009_group[,c(5,2,3)]
  mosaic_uk_2009_group=melt(mosaic_uk_2009_group, id.vars = c("var_name"))
  mosaic_uk_2009_group$var_name=paste0(mosaic_uk_2009_group[,1],"_",mosaic_uk_2009_group[,2])
  mosaic_uk_2009_group=mosaic_uk_2009_group[,c(1,3)]
  mosaic_uk_2009_group_t=data.frame(t(mosaic_uk_2009_group))
  mosaic_uk_2009_group_t=setNames(data.frame(t(mosaic_uk_2009_group[,-1])), mosaic_uk_2009_group[,1])
  
  mosaic_uk_2013_group$var_name=paste0(mosaic_uk_2013_group[,1],"_",mosaic_uk_2013_group[,4])
  mosaic_uk_2013_group=mosaic_uk_2013_group[,c(5,2,3)]
  mosaic_uk_2013_group=melt(mosaic_uk_2013_group, id.vars = c("var_name"))
  mosaic_uk_2013_group$var_name=paste0(mosaic_uk_2013_group[,1],"_",mosaic_uk_2013_group[,2])
  mosaic_uk_2013_group=mosaic_uk_2013_group[,c(1,3)]
  mosaic_uk_2013_group_t=data.frame(t(mosaic_uk_2013_group))
  mosaic_uk_2013_group_t=setNames(data.frame(t(mosaic_uk_2013_group[,-1])), mosaic_uk_2013_group[,1])
  
  
  
  device_group$var_name=paste0(device_group[,1],"_",device_group[,4])
  device_group=device_group[,c(5,2,3)]
  device_group=melt(device_group, id.vars = c("var_name"))
  device_group$var_name=paste0(device_group[,1],"_",device_group[,2])
  device_group=device_group[,c(1,3)]
  device_group_t=data.frame(t(device_group))
  device_group_t=setNames(data.frame(t(device_group[,-1])), device_group[,1])
  
  region$var_name=paste0(region[,1],"_",region[,4])
  region=region[,c(5,2,3)]
  region=melt(region, id.vars = c("var_name"))
  region$var_name=paste0(region[,1],"_",region[,2])
  region=region[,c(1,3)]
  region_t=data.frame(t(region))
  region_t=setNames(data.frame(t(region[,-1])), region[,1])
  
  social_grade$var_name=paste0(social_grade[,1],"_",social_grade[,4])
  social_grade=social_grade[,c(5,2,3)]
  social_grade=melt(social_grade, id.vars = c("var_name"))
  social_grade$var_name=paste0(social_grade[,1],"_",social_grade[,2])
  social_grade=social_grade[,c(1,3)]
  social_grade_t=data.frame(t(social_grade))
  social_grade_t=setNames(data.frame(t(social_grade[,-1])), social_grade[,1])
  
  downstream$var_name=paste0(downstream[,1],"_",downstream[,3])
  downstream=downstream[,c(4,2)]
  downstream=melt(downstream, id.vars = c("var_name"))
  downstream$var_name=paste0(downstream[,1],"_",downstream[,2])
  downstream=downstream[,c(1,3)]
  downstream_t=data.frame(t(downstream))
  downstream_t=setNames(data.frame(t(downstream[,-1])), downstream[,1])
  
  upstream$var_name=paste0(upstream[,1],"_",upstream[,3])
  upstream=upstream[,c(4,2)]
  upstream=melt(upstream, id.vars = c("var_name"))
  upstream$var_name=paste0(upstream[,1],"_",upstream[,2])
  upstream=upstream[,c(1,3)]
  upstream_t=data.frame(t(upstream))
  upstream_t=setNames(data.frame(t(upstream[,-1])), upstream[,1])
  
  names(duration)[1]="var_name"
  duration=melt(duration, id.vars = c("var_name"))
  duration$var_name=paste0(duration[,1],"_",duration[,2])
  duration=duration[,c(1,3)]
  duration_t=data.frame(t(duration))
  duration_t=setNames(duration_t[-1,],duration[,1])
  
  names(page)[1]="var_name"
  page=melt(page, id.vars = c("var_name"))
  page$var_name=paste0(page[,1],"_",page[,2])
  page=page[,c(1,3)]
  page_t=setNames(data.frame(t(page[,-1])), page[,1])
  
  names(visit)[1]="var_name"
  visit=melt(visit, id.vars = c("var_name"))
  visit$var_name=paste0(visit[,1],"_",visit[,2])
  visit=visit[,c(1,3)]
  visit_t=setNames(data.frame(t(visit[,-1])), visit[,1])
  
  X=cbind(visit_t,page_t,duration_t,device_group_t,upstream_t,downstream_t,gender_t,age_t,region_t,social_grade_t,mosaic_uk_2009_group_t,mosaic_uk_2013_group_t)
  
  nam=paste(j)
  assign(nam,X)
  
}


####third set of files


for(j in files_3){
  
  url_hit=paste("https://brc:pah9Hu1u@feeds.hitwise.com/user162/",j,sep="")
  loc.hit=paste(j)
  download.file(url_hit,loc.hit,mode="wb")

  #}
  ###read-in data from sheet
  
  for (i in 1:10 ){
    
    a=data.frame(read_excel(loc.hit, sheet = i, col_names = TRUE, col_types = NULL, na = "",skip = 0))           
    
    nam=paste(excel_sheets(loc.hit)[i])
    assign(nam,a)
  }
  
  ### change to long format and rotate
  gender$var_name=paste0(gender[,1],"_",gender[,4])
  gender=gender[,c(5,2,3)]
  gender=melt(gender, id.vars = c("var_name"))
  gender$var_name=paste0(gender[,1],"_",gender[,2])
  gender=gender[,c(1,3)]
  gender_t=data.frame(t(gender))
  gender_t=setNames(data.frame(t(gender[,-1])), gender[,1])
  
  age$var_name=paste0(age[,1],"_",age[,4])
  age=age[,c(5,2,3)]
  age=melt(age, id.vars = c("var_name"))
  age$var_name=paste0(age[,1],"_",age[,2])
  age=age[,c(1,3)]
  age_t=data.frame(t(age))
  age_t=setNames(data.frame(t(age[,-1])), age[,1])
  

  mosaic_uk_2013_group$var_name=paste0(mosaic_uk_2013_group[,1],"_",mosaic_uk_2013_group[,4])
  mosaic_uk_2013_group=mosaic_uk_2013_group[,c(5,2,3)]
  mosaic_uk_2013_group=melt(mosaic_uk_2013_group, id.vars = c("var_name"))
  mosaic_uk_2013_group$var_name=paste0(mosaic_uk_2013_group[,1],"_",mosaic_uk_2013_group[,2])
  mosaic_uk_2013_group=mosaic_uk_2013_group[,c(1,3)]
  mosaic_uk_2013_group_t=data.frame(t(mosaic_uk_2013_group))
  mosaic_uk_2013_group_t=setNames(data.frame(t(mosaic_uk_2013_group[,-1])), mosaic_uk_2013_group[,1])
  
  
  
  device_group$var_name=paste0(device_group[,1],"_",device_group[,4])
  device_group=device_group[,c(5,2,3)]
  device_group=melt(device_group, id.vars = c("var_name"))
  device_group$var_name=paste0(device_group[,1],"_",device_group[,2])
  device_group=device_group[,c(1,3)]
  device_group_t=data.frame(t(device_group))
  device_group_t=setNames(data.frame(t(device_group[,-1])), device_group[,1])
  
  region$var_name=paste0(region[,1],"_",region[,4])
  region=region[,c(5,2,3)]
  region=melt(region, id.vars = c("var_name"))
  region$var_name=paste0(region[,1],"_",region[,2])
  region=region[,c(1,3)]
  region_t=data.frame(t(region))
  region_t=setNames(data.frame(t(region[,-1])), region[,1])
  
  
  downstream$var_name=paste0(downstream[,1],"_",downstream[,3])
  downstream=downstream[,c(4,2)]
  downstream=melt(downstream, id.vars = c("var_name"))
  downstream$var_name=paste0(downstream[,1],"_",downstream[,2])
  downstream=downstream[,c(1,3)]
  downstream_t=data.frame(t(downstream))
  downstream_t=setNames(data.frame(t(downstream[,-1])), downstream[,1])
  
  upstream$var_name=paste0(upstream[,1],"_",upstream[,3])
  upstream=upstream[,c(4,2)]
  upstream=melt(upstream, id.vars = c("var_name"))
  upstream$var_name=paste0(upstream[,1],"_",upstream[,2])
  upstream=upstream[,c(1,3)]
  upstream_t=data.frame(t(upstream))
  upstream_t=setNames(data.frame(t(upstream[,-1])), upstream[,1])
  
  names(duration)[1]="var_name"
  duration=melt(duration, id.vars = c("var_name"))
  duration$var_name=paste0(duration[,1],"_",duration[,2])
  duration=duration[,c(1,3)]
  duration_t=data.frame(t(duration))
  duration_t=setNames(duration_t[-1,],duration[,1])
  
  names(page)[1]="var_name"
  page=melt(page, id.vars = c("var_name"))
  page$var_name=paste0(page[,1],"_",page[,2])
  page=page[,c(1,3)]
  page_t=setNames(data.frame(t(page[,-1])), page[,1])
  
  names(visit)[1]="var_name"
  visit=melt(visit, id.vars = c("var_name"))
  visit$var_name=paste0(visit[,1],"_",visit[,2])
  visit=visit[,c(1,3)]
  visit_t=setNames(data.frame(t(visit[,-1])), visit[,1])
  
  X=cbind(visit_t,page_t,duration_t,device_group_t,upstream_t,downstream_t,gender_t,age_t,region_t,social_grade_t,mosaic_uk_2013_group_t)
  
  nam=paste(j)
  assign(nam,X)
  
}


names(brc_20140830_4w.xls)=names(brc_20140927_4w.xls)=names(brc_20141004_5w.xls)=names(brc_20141101_4w.xls)
files_1=rbind.data.frame(brc_20140830_4w.xls,brc_20140927_4w.xls,brc_20141004_5w.xls,brc_20141101_4w.xls)


names(brc_20150103_5w.xls)=names(brc_20150131_4w.xls)=names(brc_20150228_4w.xls)=names(brc_20150404_5w.xls)=names(brc_20150502_4w.xls)=names(brc_20150530_4w.xls)=names(brc_20150704_5w.xls)=names(brc_20150801_4w.xls)=names(brc_20150829_4w.xls)

files_2=rbind.data.frame(brc_20150103_5w.xls,brc_20150131_4w.xls,brc_20150228_4w.xls,brc_20150404_5w.xls,brc_20150502_4w.xls,brc_20150530_4w.xls,brc_20150704_5w.xls,brc_20150801_4w.xls,brc_20150829_4w.xls)

names(brc_20151003_5w.xls)=names(brc_20151031_4w.xls)=names(brc_20151128_4w.xls)=names(brc_20160102_5w.xls)=names(brc_20160130_4w.xls)=names(brc_20160227_4w.xls)=names(brc_20160402_5w.xls)=names(brc_20160430_4w.xls)

files_3=rbind.data.frame(brc_20151003_5w.xls, brc_20151031_4w.xls,brc_20151128_4w.xls,brc_20160102_5w.xls,brc_20160130_4w.xls,brc_20160227_4w.xls,brc_20160402_5w.xls,brc_20160430_4w.xls)




files_1_t=data.frame(t(files_1))
files_1_t$var=row.names(files_1_t)
files_2_t=data.frame(t(files_2))
files_2_t$var=row.names(files_2_t)
files_3_t=data.frame(t(files_3))
files_3_t$var=row.names(files_3_t)




a=merge(files_1_t,files_2_t,by="var",all=TRUE)
a=merge(a,files_3_t,by="var",all=TRUE)

DRI=setNames(data.frame(t(a[,-1])), a[,1])
DRI$Date<- as.Date(seq(ISOdate(2014,8,1), by = "month", length.out = nrow(DRI)))

DRI=DRI[,c(2059,2:2058)]

#write.csv(DRI,"DRI- 170516.csv")


####
require(reshape2)

j="brc.zip"
zipfiles=c("age.csv","device_group.csv","downstream.csv","duration.csv","gender.csv","mosaic_uk_2013_group.csv","page.csv","region.csv","upstream.csv","visit.csv")

for (i in (1:length(zipfiles))){
temp <- tempfile()
download.file("https://brc:pah9Hu1u@feeds.hitwise.com/user162/brc.zip",temp)
DF <- read.csv(unz(temp,zipfiles[i]))
unlink(temp)
assign(zipfiles[i],DF)
}


#agedata
age.new=melt(age.csv,id.vars=c("Age","Industry","Month"),measure.vars=c("Share","Index"))

#Change share variable to decimal
age.new[which(age.new$variable=="Share"),5] <- as.numeric(gsub("%", "",age.new[which(age.new$variable=="Share"),5]))/100
age.new$name=paste(age.new$Age,age.new$Industry,age.new$variable,sep="_")
age.new.trim=age.new[,c("Month","name","value")]
age.new.trim$id=match(age.new.trim$Month,age.new.trim$Month)
age.new.cast=dcast(data=age.new.trim, id~name)
#add dates
age.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(age.new.cast)))
age.out=age.new.cast[,c(152,2:151)]

#device_group
device_group.new=melt(device_group.csv,id.vars=c("Device.Group","Industry","Month"),measure.vars=c("Share","Index"))

#Change share variable to decimal
device_group.new[which(device_group.new$variable=="Share"),5] <- as.numeric(gsub("%", "",device_group.new[which(device_group.new$variable=="Share"),5]))/100
device_group.new$name=paste(device_group.new$Device.Group,device_group.new$Industry,device_group.new$variable,sep="_")
device_group.new.trim=device_group.new[,c("Month","name","value")]
device_group.new.trim$id=match(device_group.new.trim$Month,device_group.new.trim$Month)
device_group.new.cast=dcast(data=device_group.new.trim, id~name)
#add dates
device_group.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(device_group.new.cast)))
device_group.out=device_group.new.cast[,c(62,2:61)]

#downstream
downstream.new=downstream.csv

#Change share variable to decimal
downstream.new$Downstream.Share <- as.numeric(gsub("%", "",downstream.new$Downstream.Share))/100
downstream.new$name=paste(downstream.new$Downstream.Industry,downstream.new$Selected.Industry,"Downstream",sep="_")
downstream.new.trim=downstream.new[,c("Month","name","Downstream.Share")]
downstream.new.trim$id=match(downstream.new.trim$Month,downstream.new.trim$Month)
downstream.new.cast=dcast(data=downstream.new.trim, id~name,value.var="Downstream.Share")
#add dates
downstream.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(downstream.new.cast)))
downstream.out=downstream.new.cast[,c(190,2:189)]


#duration
duration.new=duration.csv
#duration
duration.new$name=paste(duration.new$Industry,"Duration",sep="_")
duration.new.trim=duration.new[,c("Month","name","Duration")]
duration.new.trim$id=match(duration.new.trim$Month,duration.new.trim$Month)
duration.new.cast=dcast(data=duration.new.trim, id~name,value.var="Duration")
#add dates
duration.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(duration.new.cast)))
duration.out=duration.new.cast[,c(17,2:16)]



#gender
gender.new=melt(gender.csv,id.vars=c("Gender","Industry","Month"),measure.vars=c("Share","Index"))

#Change share variable to decimal
gender.new[which(gender.new$variable=="Share"),5] <- as.numeric(gsub("%", "",gender.new[which(gender.new$variable=="Share"),5]))/100
gender.new$name=paste(gender.new$Gender,gender.new$Industry,gender.new$variable,sep="_")
gender.new.trim=gender.new[,c("Month","name","value")]
gender.new.trim$id=match(gender.new.trim$Month,gender.new.trim$Month)
gender.new.cast=dcast(data=gender.new.trim, id~name)
#add dates
gender.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(gender.new.cast)))
gender.out=gender.new.cast[,c(62,2:61)]

#"mosaic_uk_2013_group.csv"

mosaic_uk_2013_group.new=melt(mosaic_uk_2013_group.csv,id.vars=c("Mosaic.UK.2013.Group","Industry","Month"),measure.vars=c("Share","Index"))

#Change share variable to decimal
mosaic_uk_2013_group.new[which(mosaic_uk_2013_group.new$variable=="Share"),5] <- as.numeric(gsub("%", "",mosaic_uk_2013_group.new[which(mosaic_uk_2013_group.new$variable=="Share"),5]))/100
mosaic_uk_2013_group.new$name=paste(mosaic_uk_2013_group.new$Mosaic.UK.2013.Group,mosaic_uk_2013_group.new$Industry,mosaic_uk_2013_group.new$variable,sep="_")
mosaic_uk_2013_group.new.trim=mosaic_uk_2013_group.new[,c("Month","name","value")]
mosaic_uk_2013_group.new.trim$id=match(mosaic_uk_2013_group.new.trim$Month,mosaic_uk_2013_group.new.trim$Month)
mosaic_uk_2013_group.new.cast=dcast(data=mosaic_uk_2013_group.new.trim, id~name)
#add dates
mosaic_uk_2013_group.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(mosaic_uk_2013_group.new.cast)))
mosaic_uk_2013_group.out=mosaic_uk_2013_group.new.cast[,c(452,2:451)]

#page.csv
page.new=page.csv
#page
page.new$name=paste(page.new$Industry,"Page.View",sep="_")
page.new.trim=page.new[,c("Month","name","Page.View")]
page.new.trim$id=match(page.new.trim$Month,page.new.trim$Month)
page.new.cast=dcast(data=page.new.trim, id~name, value.var="Page.View")
#add dates
page.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(page.new.cast)))
page.out=page.new.cast[,c(17,2:16)]

#region

#region
region.new=melt(region.csv,id.vars=c("Region","Industry","Month"),measure.vars=c("Share","Index"))

#Change share variable to decimal
region.new[which(region.new$variable=="Share"),5] <- as.numeric(gsub("%", "",region.new[which(region.new$variable=="Share"),5]))/100
region.new$name=paste(region.new$Region,region.new$Industry,region.new$variable,sep="_")
region.new.trim=region.new[,c("Month","name","value")]
region.new.trim$id=match(region.new.trim$Month,region.new.trim$Month)
region.new.cast=dcast(data=region.new.trim, id~name)
#add dates
region.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(region.new.cast)))
region.out=region.new.cast[,c(362,2:361)]

#"upstream.csv"
upstream.new=upstream.csv

#Change share variable to decimal
upstream.new$Upstream.Share <- as.numeric(gsub("%", "",upstream.new$Upstream.Share))/100
upstream.new$name=paste(upstream.new$Upstream.Industry,upstream.new$Selected.Industry,"Upstream",sep="_")
upstream.new.trim=upstream.new[,c("Month","name","Upstream.Share")]
upstream.new.trim$id=match(upstream.new.trim$Month,upstream.new.trim$Month)
upstream.new.cast=dcast(data=upstream.new.trim, id~name,value.var="Upstream.Share")
#add dates
upstream.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(upstream.new.cast)))
upstream.out=upstream.new.cast[,c(178,2:177)]


#"visit.csv"
visit.new=melt(visit.csv,id.vars=c("Industry","Month"),measure.vars=c("Total.Visits","Average.Weekly.Visits"))

#Change share variable to decimal
visit.new$name=paste(visit.new$Industry,visit.new$Industry,visit.new$variable,sep="_")
visit.new.trim=visit.new[,c("Month","name","value")]
visit.new.trim$id=match(visit.new.trim$Month,visit.new.trim$Month)
visit.new.cast=dcast(data=visit.new.trim, id~name)
#add dates
visit.new.cast$Date<- as.Date(seq(ISOdate(2015,12,1), by = "month", length.out = nrow(visit.new.cast)))
visit.out=visit.new.cast[,c(32,2:31)]


DRI_new=cbind.data.frame(age.out,device_group.out,downstream.out,duration.out,gender.out,mosaic_uk_2013_group.out,page.out,region.out,upstream.out,visit.out)

# there are some naming differences / differences in variables
names_match=names(DRI)[which(!names(DRI)%in%names(DRI_new))]

#Trim old DRI

DRI_old=DRI[which(DRI$Date<as.Date("2015-12-01")),]

require(plyr)
require(dplyr)
DRI_Master=rbind.fill(DRI_old,DRI_new)

write.csv(DRI_Master,"DRI Master.csv")


