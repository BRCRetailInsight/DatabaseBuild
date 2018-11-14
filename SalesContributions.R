
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
p1=  ggplot(plot_data_long, aes(x=index.plot_data.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_IDOB", "C_IDOC", "C_J5DK"),
                        labels=c("Food Stores", "Non-Food Stores", "Online only"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales volume growth (ONS RSI)")+
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
  
  rsi_val$C_EAIT = rsi_val$EAIT*W_EAIT/W_J3L2
  rsi_val$C_EAIU = rsi_val$EAIU*W_EAIU/W_J3L2
  rsi_val$C_EAIV = rsi_val$EAIV*W_EAIV/W_J3L2
  rsi_val$C_EAIW = rsi_val$EAIW*W_EAIW/W_J3L2

  rsi_val$C_J58M = rsi_val$J58M*W_J58M/W_J3L2
  rsi_val$C_J58N = rsi_val$J58N*W_J58N/W_J3L2

  rsi_val$all_check = rsi_val$C_J58N +  rsi_val$C_J58M+rsi_val$C_EAIT+rsi_val$C_EAIU+rsi_val$C_EAIV+rsi_val$C_EAIW 
  
  total_weight = W_J58N/W_J3L2+W_J58M/W_J3L2+W_EAIT/W_J3L2+W_EAIU/W_J3L2+W_EAIV/W_J3L2+W_EAIW/W_J3L2

  
  
  
  
  #subset data & transform
  plot_data2=rsi_val["2016-01/",c("C_EAIA","C_EAIB","C_J58L")]
  plot_data2_long=data.frame(index(plot_data2),stack(as.data.frame(coredata(plot_data2))))
  
  #plot food, non-food, internet contribution
 p2= ggplot(plot_data2_long, aes(x=index.plot_data2.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_EAIA", "C_EAIB", "C_J58L"),
                        labels=c("Food","Non-Food","Internet"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales value growth (ONS RSI)")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  #plot small v large
  plot_data3=rsi_val["2016-01/",c("C_J3L3","C_J3L4")]
  plot_data3_long=data.frame(index(plot_data3),stack(as.data.frame(coredata(plot_data3))))
  
  p3=ggplot(plot_data3_long, aes(x=index.plot_data3.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_J3L3","C_J3L4"),
                        labels=c("Large Businesses", "Small Businesses"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales value growth (ONS RSI)")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  
  #plot small v large, food, non-food, online
  plot_data4=rsi_val["2016-01/",c("C_EAIT","C_EAIU","C_EAIV","C_EAIW","C_J58M","C_J58N")]
  plot_data4_long=data.frame(index(plot_data4),stack(as.data.frame(coredata(plot_data4))))
  
  #plot food, non-food, internet contribution
  p4=ggplot(plot_data4_long, aes(x=index.plot_data4.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_EAIT","C_EAIU","C_EAIV","C_EAIW","C_J58M","C_J58N"),
                        labels=c("Food Stores Large","Food Stores Small", "Non-Food Stores Large", "Non-Food Stores Small", "Online Large","Online Small"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales value growth (ONS RSI)")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  
  #Contributions to large stores only
  
  
  rsi_val$C_EAIT_large = rsi_val$EAIT*W_EAIT/W_J3L3

  rsi_val$C_EAIV_large = rsi_val$EAIV*W_EAIV/W_J3L3
  
  rsi_val$C_J58M_large = rsi_val$J58M*W_J58M/W_J3L3
 
  
  #subset data & transform
 plot_data5=rsi_val["2016-01/",c("C_EAIT_large","C_EAIV_large","C_J58M_large")]
  plot_data5_long=data.frame(index(plot_data5),stack(as.data.frame(coredata(plot_data5))))
  
  #plot food, non-food, internet contribution
  p5=ggplot(plot_data5_long, aes(x=index.plot_data5.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_EAIT_large","C_EAIV_large","C_J58M_large"),
                        labels=c("Food","Non-Food","Online"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales value growth Large businesses (ONS RSI)")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
  
  #RSM contributions
  RSM_xts$C_rsm_food=RSM_xts$rsm_food*W_rsm_food/100
  RSM_xts$C_rsm_nffood=RSM_xts$rsm_nffood*W_rsm_nffood/100

  plot_data6=RSM_xts["2016-01/",c("C_rsm_food","C_rsm_nffood")]
  
  
  plot_data6_long=data.frame(index(plot_data6),stack(as.data.frame(coredata(plot_data6))))
  
  #plot food, non-food, internet contribution
p6=  ggplot(plot_data6_long, aes(x=index.plot_data6.,y=values,fill=ind))+
    geom_bar(stat="identity")+
    scale_fill_discrete(name="Variables",
                        breaks=c("C_rsm_food","C_rsm_nffood"),
                        labels=c("Food","Non-Food"))+
    labs(x="month",y="Contribution to year on year growth",title = "Contributions to retail sales value growth (RSM)")+
    geom_text(aes(label=round(values,digits=1)),size = 3, position =  "stack",vjust = 1.5)
  
grid.arrange(p1, p2,p3,p4,p5,p6, nrow = 3)

  