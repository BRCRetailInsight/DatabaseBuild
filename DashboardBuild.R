library(shiny)
library(dygraphs)
library(shinydashboard)
library(DT)
library(xts)
library(leaflet)
library(leaflet.extras)
library(timevis)

#This package includes progress indicator graphic for wait time during map plotting
devtools::install_github("AnalytixWare/ShinySky")
library(shinysky)


#colours
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")


#### Shiny UI ####

ui <- dashboardPage(skin = "blue",
                 dashboardHeader(title = "BRC DATA DASHBOARD", titleWidth = 300),
                 dashboardSidebar(width = 300,
                   sidebarMenu(id = "sidebarmenu",
                     menuItem("Retail KPIs", icon = icon("th"), tabName = "brcstats"),
                     menuItem("Economic Conditions", icon = icon("th"), tabName = "extstats"),
                     menuItem("Monthly Data Graph", icon = icon("chart-line"), tabName = "dygraph"),
                       conditionalPanel("input.sidebarmenu === 'dygraph'",
                                        selectInput("selector", "Select Series", multiple = TRUE, choices = colnames(databasemonthly), selected = "Unemployment.Rate.UK")),
                     menuItem("Monthly Data Table", icon = icon("table"), tabName = "table"),
                       conditionalPanel("input.sidebarmenu === 'table'",
                                        selectInput("selector2", "Select Series", multiple = TRUE, choices = colnames(databasemonthlydf), selected = c("Unemployment.Rate.UK", "date")),
                                        dateRangeInput("selector3", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                       format = "yyyy-mm-dd", weekstart = 0)),
                     menuItem("Quarterly Data Graph", icon = icon("chart-line"), tabName = "dygraph2"),
                     conditionalPanel("input.sidebarmenu === 'dygraph2'",
                                      selectInput("selector4", "Select Series", multiple = TRUE, choices = colnames(databasequarterly), selected = "GDP.Quarterly...Whole.Economy...m.")),
                     menuItem("Quarterly Data Table", icon = icon("table"), tabName = "table2"),
                     conditionalPanel("input.sidebarmenu === 'table2'",
                                      selectInput("selector5", "Select Series", multiple = TRUE, choices = colnames(databasequarterlydf), selected = c("GDP.Quarterly...Whole.Economy...m.", "date")),
                                      dateRangeInput("selector6", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                     format = "yyyy-mm-dd", weekstart = 0)),
                     menuItem("Yearly Data Graph", icon = icon("chart-line"), tabName = "dygraph3"),
                     conditionalPanel("input.sidebarmenu === 'dygraph3'",
                                      selectInput("selector7", "Select Series", multiple = TRUE, choices = colnames(databaseyearly), selected = "United.Kingdom.Total.Median_OBS_VALUE")),
                     menuItem("Yearly Data Table", icon = icon("table"), tabName = "table3"),
                     conditionalPanel("input.sidebarmenu === 'table3'",
                                      selectInput("selector8", "Select Series", multiple = TRUE, choices = colnames(databaseyearlydf), selected = c("United.Kingdom.Total.Median_OBS_VALUE", "date")),
                                      dateRangeInput("selector9", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                     format = "yyyy-mm-dd", weekstart = 0)),
                     menuItem("UK Nations Map", icon = icon("map-marked-alt"), tabName = "nationmap"),
                     menuItem("UK Regions Map", icon = icon("map-marked-alt"), tabName = "regionmap"),
                     menuItem("BRC Release Calendar", icon = icon("calendar"), tabName = "calendar")
                     
                     )),
                 
                 dashboardBody(  
                   #This code links the styling of the app to the .css stylesheet saved in the 'www' folder.
                   tags$head(
                     tags$link(rel = "stylesheet", type = "text/css", 
                               href = "style.css")
                   ),    
                    tabItems(
                          
                      tabItem(tabName = "brcstats",
                        h3("Retail KPI's"),
                        
                        fluidRow(
                          valueBox(subtitle = "RSM Total (YoY Change)", value = paste0(round(tail(databasemonthly$Total.Sales....yoy.change..BRC.KPMG.RSM[!is.na(databasemonthly$Total.Sales....yoy.change..BRC.KPMG.RSM)], 1), 1),"%"), color = "red", icon = icon("cart-plus")),
                          valueBox(subtitle = "RSM Total Food 3-mth avg (YoY Change)", value = paste0(round(tail(databasemonthly$Food.Sales.3.month.average....yoy.change.[!is.na(databasemonthly$Food.Sales.3.month.average....yoy.change.)], 1), 1), "%"), color = "red", icon = icon("shopping-basket")),
                          valueBox(subtitle = "RSM Total Non-Food 3-mth avg (YoY Change)", value = paste0(round(tail(databasemonthly$Food.Sales.Non.Food.3.month.average....yoy.change.[!is.na(databasemonthly$Food.Sales.Non.Food.3.month.average....yoy.change.)], 1), 1), "%"), color = "red", icon = icon("shopping-bag"))),
                          
                        fluidRow(
                          valueBox(subtitle = "SPI All Items (YoY Change)", value = paste0(round(tail(databasemonthly$SPI_All[!is.na(databasemonthly$SPI_All)], 1), 1), "%"), color = "yellow", icon = icon("chart-line")),
                          valueBox(subtitle = "SPI Food (YoY Change)", value = paste0(round(tail(databasemonthly$SPI_Food[!is.na(databasemonthly$SPI_Food)], 1), 1), "%"), color = "yellow", icon = icon("chart-bar")),
                          valueBox(subtitle = "SPI Non-Food (YoY Change)", value = paste0(round(tail(databasemonthly$SPI_NF[!is.na(databasemonthly$SPI_NF)], 1), 1), "%"), color = "yellow", icon = icon("chart-area"))),
                          
                        fluidRow(
                          valueBox(subtitle = "High Street Footfall (YoY Change)", value = paste0(round(tail(databasemonthly$Footfall.High.Street....yoy.change..BRC.Springboard[!is.na(databasemonthly$Footfall.High.Street....yoy.change..BRC.Springboard)], 1), 1), "%"), color = "green", icon = icon("male")),
                          valueBox(subtitle = "Retail Park Footfall (YoY Change)", value = paste0(round(tail(databasemonthly$Footfall.Retail.Park....yoy.change..BRC.Springboard[!is.na(databasemonthly$Footfall.Retail.Park....yoy.change..BRC.Springboard)], 1), 1), "%"), color = "green", icon = icon("walking")),
                          valueBox(subtitle = "Shopping Centre Footfall (YoY Change)", value = paste0(round(tail(databasemonthly$Footfall.Shopping.Centre....yoy.change..BRC.Springboard[!is.na(databasemonthly$Footfall.Shopping.Centre....yoy.change..BRC.Springboard)], 1), 1), "%"), color = "green", icon = icon("female"))),
                          
                        fluidRow(
                          valueBox(subtitle = "REM Employment (YoY Change)", value = paste0(round(tail(databasemonthly$REM...Employment[!is.na(databasemonthly$REM...Employment)], 1), 1), "%"), color = "aqua", icon = icon("user-graduate")),
                          valueBox(subtitle = "REM Hours (YoY Change)", value = paste0(round(tail(databasemonthly$REM...Hours[!is.na(databasemonthly$REM...Hours)], 1), 1), "%"), color = "aqua", icon = icon("clock")),
                          valueBox(subtitle = "REM Stores (YoY Change)", value = paste0(round(tail(databasemonthly$REM...Stores[!is.na(databasemonthly$REM...Stores)], 1), 1), "%"), color = "aqua", icon = icon("building"))),
                        
                        fluidRow(
                          valueBox(subtitle = "DRI Website Visits (YoY Change)", value = paste0(round(tail(databasemonthly$BRC.Hitwise.Growth.in.retailer.website.visits..yoy...[!is.na(databasemonthly$BRC.Hitwise.Growth.in.retailer.website.visits..yoy...)], 1), 1), "%"), color = "blue", icon = icon("desktop")),
                          valueBox(subtitle = "DRI Mobile Share", value = paste0(round(tail(databasemonthly$BRC.Hitwise.Mobile.Share.of.retail.website.visits....[!is.na(databasemonthly$BRC.Hitwise.Mobile.Share.of.retail.website.visits....)], 1), 1), "%"), color = "blue", icon = icon("mobile")))),
                        
                        
                      tabItem(tabName = "extstats",
                        h3("Economic Conditions"),
                                    
                        fluidRow(
                          valueBox(subtitle = paste("RSI Overall (NSA) (YoY Change)","  ", format(index(tail(rsi_val$`RSI Values - All retail exc auto fuel`, 1)), "%Y %B")), value = paste0(round(tail(rsi_val$`RSI Values - All retail exc auto fuel`, 1), 1),"%"), color = "red", icon = icon("cart-plus")),
                          valueBox(subtitle = paste("RSI Food (NSA) (YoY Change)","  ", format(index(tail(rsi_val$`RSI Values - Predom food stores`, 1)), "%Y %B")), value = paste0(round(tail(rsi_val$`RSI Values - Predom food stores`, 1), 1),"%"), color = "red", icon = icon("shopping-basket")),
                          valueBox(subtitle = paste("RSI Online (NSA) (YoY Change)","  ", format(index(tail(rsi_val$`RSI Values - Internet`, 1)), "%Y %B")), value = paste0(round(tail(rsi_val$`RSI Values - Internet`, 1), 1),"%"), color = "red", icon = icon("shipping-fast"))),
                        
                        fluidRow(
                          valueBox(subtitle = paste("CPI All Items (YoY Change)","  ", format(index(tail(cpi_all, 1)), "%Y %B")), value = paste0(tail(cpi_all, 1), "%"), color = "yellow", icon = icon("chart-line")),
                          valueBox(subtitle = paste("CPI Food (YoY Change)","  ", format(index(tail(cpi_food, 1)), "%Y %B")), value = paste0(round(tail(cpi_food, 1), 1), "%"), color = "yellow", icon = icon("chart-bar")),
                          valueBox(subtitle = paste("CPI Non-Food (YoY Change)","  ", format(index(tail(cpi_nonfood, 1)), "%Y %B")), value = paste0(round(tail(cpi_nonfood, 1), 1), "%"), color = "yellow", icon = icon("chart-area"))),
                        
                        fluidRow(
                          valueBox(subtitle = paste("GVA Whole Economy (YoY Change)","  ", format(index(tail(GVAmonthly_yoy, 1)), "%Y %B")), value = paste0(tail(GVAmonthly_yoy), "%"), color = "green", icon = icon("briefcase")),
                          valueBox(subtitle = paste("GVA Whole Economy Quarterly (£m)","  ", as.yearqtr(index(tail(GVAquarterly_all, 1)), format = "%Y-%m-%d")), value = paste0("£", prettyNum(tail(GVAquarterly_all, 1), big.mark = ",", scientific=FALSE)), color = "green", icon = icon("city")),
                          valueBox(subtitle = paste("GVA Retail Quarterly (£m)","  ", as.yearqtr(index(tail(GVAquarterly_retail, 1)), format = "%Y-%m-%d")), value = paste0("£", prettyNum(tail(GVAquarterly_retail, 1), big.mark = ",", scientific=FALSE)), color = "green", icon = icon("industry"))),
                        
                        fluidRow(
                          valueBox(subtitle = paste("Unempoyment Rate","  ", format(index(tail(unemp$`Unemployment Rate UK`, 1)), "%Y %B")), value = paste0(tail(unemp$`Unemployment Rate UK`, 1), "%"), color = "aqua", icon = icon("user-tie")),
                          valueBox(subtitle = paste("Jobs Whole Economy (000's)","  ", as.yearqtr(index(tail(empjobsquarterly_all, 1)), format = "%d-%m-%Y")), value = prettyNum(tail(empjobsquarterly_all, 1) + tail(selfjobsquarterly_all, 1), big.mark = ",", scientific = FALSE), color = "aqua", icon = icon("users")),
                          valueBox(subtitle = paste("Jobs Retail (000's)","  ", as.yearqtr(index(tail(empjobsquarterly_retail, 1)), format = "%Y-%m-%d")), value = prettyNum(tail(empjobsquarterly_retail, 1) + tail(selfjobsquarterly_retail, 1), big.mark = ",", scientific = FALSE), color = "aqua", icon = icon("people-carry"))),
                        
                        fluidRow(
                          valueBox(subtitle = paste("Average Weekly Earnings - Regular Pay (YoY Change)","  ", format(index(tail(awe$`Regular Pay YoY Growth`, 1)), "%Y %B")), value = paste0(tail(awe$`Regular Pay YoY Growth`, 1), "%"), color = "blue", icon = icon("money-bill-wave")),
                          valueBox(subtitle = paste("Average Weekly Earnings - Real Regular Pay (YoY Change)","  ", format(index(tail(awe$`Real Regular Pay YoY Growth`, 1)), "%Y %B")), value = paste0(tail(awe$`Real Regular Pay YoY Growth`, 1), "%"), color = "blue", icon = icon("credit-card")))),
                        
                        
                      tabItem(tabName = "dygraph",
                        h3("Monthly Data Graph"),
                        fluidRow(
                          dygraphOutput("dygraph")),
                        fluidRow(
                          h3("Legend"),
                          textOutput("dylegend1"), width = 12)
                        ),
                        
                      tabItem(tabName = "table",
                        h3("Monthly Data Table"),
                        fluidRow(
                        DT::dataTableOutput("table")),
                        fluidRow(
                          box(title = "Download Data", downloadButton("downloadData", "Download"), width = 12)
                        )),
                      
                      
                      tabItem(tabName = "dygraph2",
                              h3("Quarterly Data Graph"),
                              fluidRow(
                                dygraphOutput("dygraph2")),
                              fluidRow(
                                h3("Legend"),
                                textOutput("dylegend2"), width = 12)
                              ),
                      
                      tabItem(tabName = "table2",
                              h3("Quarterly Data Table"),
                              fluidRow(
                                DT::dataTableOutput("table2")),
                              fluidRow(
                                box(title = "Download Data", downloadButton("downloadData2", "Download"), width = 12)
                              )),
                      
                      
                      tabItem(tabName = "dygraph3",
                              h3("Yearly Data Graph"),
                              fluidRow(
                                dygraphOutput("dygraph3")),
                              fluidRow(
                                h3("Legend"),
                                textOutput("dylegend3"), width = 12)
                              ),
                      
                      tabItem(tabName = "table3",
                              h3("Yearly Data Table"),
                              fluidRow(
                                DT::dataTableOutput("table3")),
                              fluidRow(
                                box(title = "Download Data", downloadButton("downloadData3", "Download"), width = 12)
                              )),
                      
                      tabItem(tabName = "nationmap",
                              h3("UK Nations Map"),
                              div(class="outer",
                                  leafletOutput("nationmap", height = "700"), busyIndicator(text = "Map plotting in progress...", wait = 100)),
                              fluidRow(
                                box(title = "Download Data", 
                                    selectInput("nationdataset", "Select Nation:", choices = c("England", "Wales", "Scotland", "Northern Ireland")),
                                    downloadButton("downloadData4", "Download"), width = 12)
                              )),
                      
                      tabItem(tabName = "regionmap",
                              h3("UK Regions Map"),
                              div(class="outer",
                                  leafletOutput("regionmap", height = "700"), busyIndicator(text = "Map plotting in progress...", wait = 100)),
                              fluidRow(
                                box(title = "Download Data", 
                                    selectInput("regiondataset", "Select Region:", choices = c("North East", "North West", "Yorkshire and the Humber", "East Midlands", "West Midlands", "East", "London", "South East", "South West", "Wales", "Scotland", "Northern Ireland")),
                                    downloadButton("downloadData5", "Download"), width = 12)
                              )
                      ),
                      
                      tabItem(tabName = "calendar",
                              h3("BRC Release Calendar"),
                              fluidRow(
                                timevisOutput("timelineGroups")
                              ),
                              fluidRow(
                                actionButton("btn", "Focus around today")
                              ))
                      )))
                 

#### Shiny Server ####

server <- function(input, output, session) {
  
  data <- reactive({
    databasemonthly[,input$selector]
  })

  output$dygraph <- renderDygraph({
    dygraph(data()) %>%
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol, mobileDisableYTouch = TRUE) %>%
      dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
      dyRangeSelector() %>%
      dyLegend(labelsDiv = "dylegend1") %>%
      dyCrosshair(direction = "vertical")
  })
  
  data2 <- reactive({
    database2 <- databasemonthlydf[which(databasemonthlydf$date >= input$selector3[1] & databasemonthlydf$date <= input$selector3[2]), input$selector2]
  })
  
  output$table = DT::renderDataTable({
    data2()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("BRCdata", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data2(), file, row.names = FALSE)
    },
    contentType = "csv"
  )
  
  data3 <- reactive({
    databasequarterly[,input$selector4]
  })
  
  output$dygraph2 <- renderDygraph({
    dygraph(data3()) %>%
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol, mobileDisableYTouch = TRUE) %>%
      dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
      dyRangeSelector() %>%
      dyLegend(labelsDiv = "dylegend2") %>%
      dyCrosshair(direction = "vertical")
  })
  
  data4 <- reactive({
    database4 <- databasequarterlydf[which(databasequarterlydf$date >= input$selector6[1] & databasequarterlydf$date <= input$selector6[2]), input$selector5]
  })
  
  output$table2 = DT::renderDataTable({
    data4()
  })
  
  output$downloadData2 <- downloadHandler(
    filename = function() {
      paste("BRCdata", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data4(), file, row.names = FALSE)
    },
    contentType = "csv"
  )
  
  data5 <- reactive({
    databaseyearly[,input$selector7]
  })
  
  output$dygraph3 <- renderDygraph({
    dygraph(data5()) %>%
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol, mobileDisableYTouch = TRUE) %>%
      dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
      dyRangeSelector() %>%
      dyLegend(labelsDiv = "dylegend3") %>%
      dyCrosshair(direction = "vertical")
  })
  
  data6 <- reactive({
    database6 <- databaseyearlydf[which(databaseyearlydf$date >= input$selector9[1] & databasequarterlydf$date <= input$selector9[2]), input$selector8]
  })
  
  output$table3 = DT::renderDataTable({
    data6()
  })
  
  output$downloadData3 <- downloadHandler(
    filename = function() {
      paste("BRCdata", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data6(), file, row.names = FALSE)
    },
    contentType = "csv"
  )
  
  output$nationmap <- renderLeaflet({
    leaflet() %>% 
      addPolygons(data = ukcountries, weight = 1, smoothFactor = 0.5,
                  color = ~pal1(Unemployment.Rate.England), 
                  opacity = 1.0, fillOpacity = 1.0,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), #%>%
                  #addProviderTiles(providers$Esri.WorldStreetMap)
                  popup = paste("Nation:", paste("<b>", ukcountries$ctry16nm, "</b>"), "<br>",
                                "Unemployment:", paste("<b>", ukcountries$Unemployment.Rate.England, "%", "</b>"), "<br>",
                                "Employment:", paste("<b>", prettyNum(ukcountries$Employment.Total.England, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "Work Force Jobs:", paste("<b>", prettyNum(ukcountries$Workforce.Jobs, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "Number of Retailers:", paste("<b>", prettyNum(ukcountries$Number.of.Retailers, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "Number of Shops:", paste("<b>", prettyNum(ukcountries$Number.of.Shops, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "Median Hourly Wage - Whole Economy:", paste("<b>", "£", ukcountries$Median.Hourly.Wage...Whole.Economy, "</b>"), "<br>",
                                "Median Hourly Wage - Retail:", paste("<b>", "£", ukcountries$Median.Hourly.Wage...Retail, "</b>"), "<br>",
                                "Average House Price:", paste("<b>", "£", prettyNum(ukcountries$House.Price.Average...England, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "GVA (Index):", paste("<b>", ukcountries$GVA...England, "</b>"), "<br>",
                                "GVA per head:", paste("<b>", "£", prettyNum(ukcountries$GVA.per.Head...England, big.mark=",", scientific=FALSE), "</b>")), popupOptions = popupOptions(closeOnClick=TRUE)) %>%
                  addResetMapButton() %>%
                  addLegend("bottomright", pal = pal1, values = ukcountries$Unemployment.Rate.England,
                  title = "Unemployment Rate",
                  opacity = 0.7) %>%
                  setView(-3.3, 54.6, zoom = 6)
  })
  
  output$regionmap <- renderLeaflet({
    leaflet() %>% 
      addPolygons(data = ukregions, weight = 1, smoothFactor = 0.5,
                  color = ~pal2(Unemployment.Rate.North.East), 
                  opacity = 1.0, fillOpacity = 1.0,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  popup = paste("Nation:", paste("<b>", ukregions$nuts118nm, "</b>"), "<br>",
                                "Unemployment:", paste("<b>", ukregions$Unemployment.Rate.North.East, "%", "</b>"), "<br>",
                                "Employment:", paste("<b>", prettyNum(ukregions$Employment.Total.North.East, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "Median Hourly Wage - Whole Economy:", paste("<b>", "£", ukregions$Median.Hourly.Wage...Whole.Economy, "</b>"), "<br>",
                                "Median Hourly Wage - Retail:", paste("<b>", "£", ukregions$Median.Hourly.Wage...Retail, "</b>"), "<br>",
                                "Average House Price:", paste("<b>", "£", prettyNum(ukregions$House.Price.Average...North.East, big.mark = ",", scientific=FALSE), "</b>"), "<br>",
                                "GVA (Index):", paste("<b>", ukregions$GVA...North.East, "</b>"), "<br>",
                                "GVA per head:", paste("<b>", "£", prettyNum(ukregions$GVA.per.Head...North.East, big.mark=",", scientific=FALSE), "</b>")), popupOptions = popupOptions(closeOnClick=TRUE)) %>%
                  addResetMapButton() %>%
                  addLegend("bottomright", pal = pal2, values = ukregions$Unemployment.Rate.North.East,
                  title = "Unemployment Rate",
                  opacity = 0.7) %>%
                  setView(-3.3, 54.6, zoom = 6)
        })
  
  datasetInput1 <- reactive({
    switch(input$nationdataset,
           "England" = englanddata,
           "Wales" = walesdata,
           "Scotland" = scotlanddata,
           "Northern Ireland" = nidata)
  })
  
  datasetInput2 <- reactive({
    switch(input$regiondataset,
           "North East" = nedata,
           "North West" = nwdata,
           "Yorkshire and the Humber" = yorkdata,
           "East Midlands" = emdata,
           "West Midlands" = wmdata,
           "East" = edata, 
           "London" = londondata, 
           "South East" = sedata, 
           "South West" = swdata, 
           "Wales" = walesdata, 
           "Scotland" = scotlanddata, 
           "Northern Ireland" = nidata
           )
  })
  
  output$downloadData4 <- downloadHandler(
    filename = function() {
      paste("BRCdata", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput1(), file, row.names = FALSE)
    },
    contentType = "csv"
  )
  
  output$downloadData5 <- downloadHandler(
    filename = function() {
      paste("BRCdata", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput2(), file, row.names = FALSE)
    },
    contentType = "csv"
  )
  
  output$timelineGroups <- renderTimevis({
    timevis(data = timevisData, groups = timevisDataGroups, showZoom = TRUE, fit = FALSE)
  })
  
  observeEvent(input$btn, {
    centerTime("timelineGroups", Sys.Date() - 1)
  })
  
#When running the app in a browser, this code automatically stops the app running in Rstudio when you close the tab.
  session$onSessionEnded(stopApp)
  
}


#### Run Shiny ####

shinyApp(ui, server)
