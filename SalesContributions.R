
# Analysis of the makeup of growth
# Note APIget.R is required beforehand, but teh conversion to "month-yr" format needs to be turned off

  library(ggplot2)
  library(reshape2)

#calculate contributions to growth (ex-fuel vol sales)
  rsi_vol$C_IDOB = rsi_vol$IDOB*W_IDOB/W_J45U
  rsi_vol$C_IDOC = rsi_vol$IDOC*W_IDOC/W_J45U
  rsi_vol$C_IDOA = rsi_vol$IDOA*W_IDOA/W_J45U
  rsi_vol$C_IDOG = rsi_vol$IDOG*W_IDOG/W_J45U
  rsi_vol$C_IDOH = rsi_vol$IDOH*W_IDOH/W_J45U
  rsi_vol$C_IDOD = rsi_vol$IDOD*W_IDOD/W_J45U
  rsi_vol$C_J5DK = rsi_vol$J5DK*W_J5DK/W_J45U



#subset data & transform
  plot_data=rsi_vol["2017-01/",c("C_IDOB","C_IDOC","C_J5DK")]
  plot_data_long=data.frame(index(plot_data),stack(as.data.frame(coredata(plot_data))))

#plot contributions of Food, Non-Food & Internet
  ggplot(plot_data_long, aes(x=index.plot_data.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_IDOB", "C_IDOC", "C_J5DK"),
                        labels=c("Food Stores", "Non-Food Stores", "Online only"))+
    labs(x="month",y="Contribution to year on year growth")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)

#calculate contributions to growth (ex-fuel val sales)
  rsi_val$C_J3L3 = rsi_val$J3L3*W_J3L3/W_J3L2
  rsi_val$C_J3L4 = rsi_val$J3L4*W_J3L4/W_J3L2
  
  rsi_val$C_EAIA = rsi_val$EAIA*W_EAIA/W_J3L2
  rsi_val$C_EAIB = rsi_val$EAIB*W_EAIB/W_J3L2
  rsi_val$C_EAIN = rsi_val$EAIN*W_EAIN/W_J3L2
  rsi_val$C_EAIC = rsi_val$EAIC*W_EAIC/W_J3L2
  rsi_val$C_EAID = rsi_val$EAID*W_EAID/W_J3L2
  rsi_val$C_EAIF = rsi_val$EAIF*W_EAIF/W_J3L2
  rsi_val$C_J58L = rsi_val$J58L*W_J58L/W_J3L2
  
  rsi_val$C_EAIV = rsi_val$EAIV*W_EAIV/W_J3L2
  rsi_val$C_EAIW = rsi_val$EAIW*W_EAIW/W_J3L2
  rsi_val$C_EAIO = rsi_val$EAIO*W_EAIO/W_J3L2
  rsi_val$C_EAIP = rsi_val$EAIP*W_EAIP/W_J3L2

  rsi_val$C_J58M = rsi_val$J58M*W_J58M/W_J3L2
  rsi_val$C_J58N = rsi_val$J58N*W_J58N/W_J3L2

  rsi_val$all_check = rsi_val$C_J58N +  rsi_val$C_J58M+rsi_val$C_EAIP+rsi_val$C_EAIO+rsi_val$C_EAIW+rsi_val$C_EAIV 
  
  #subset data & transform
  plot_data2=rsi_val["2016-01/",c("C_EAIA","C_EAIB","C_J58L")]
  plot_data2_long=data.frame(index(plot_data2),stack(as.data.frame(coredata(plot_data2))))
  
  #plot food, non-food, internet contribution
  ggplot(plot_data2_long, aes(x=index.plot_data2.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_EAIA", "C_EAIB", "C_J58L"),
                        labels=c("Food","Non-Food","Internet"))+
    labs(x="month",y="Contribution to year on year growth")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  #plot small v large
  plot_data3=rsi_val["2016-01/",c("C_J3L3","C_J3L4")]
  plot_data3_long=data.frame(index(plot_data3),stack(as.data.frame(coredata(plot_data3))))
  
  #plot food, non-food, internet contribution
  ggplot(plot_data3_long, aes(x=index.plot_data3.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_J3L3","C_J3L4"),
                        labels=c("Large Businesses", "Small Businesses"))+
    labs(x="month",y="Contribution to year on year growth")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  
  #plot small v large
  plot_data4=rsi_val["2016-01/",c("C_EAIV","C_EAIW","C_EAIO","C_EAIP","C_J58M","C_J58N")]
  plot_data4_long=data.frame(index(plot_data4),stack(as.data.frame(coredata(plot_data4))))
  
  #plot food, non-food, internet contribution
  ggplot(plot_data4_long, aes(x=index.plot_data4.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_EAIV","C_EAIW","C_EAIO","C_EAIP","C_J58M","C_J58N"),
                        labels=c("Food Stores Large","Food Stores Small", "Non-Food Stores Large", "Non-Food Stores Small", "Online Large","Online Small"))+
    labs(x="month",y="Contribution to year on year growth")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  
  
  