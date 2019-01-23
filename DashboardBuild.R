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
                 dashboardHeader(title = "Retail Data"),
                 dashboardSidebar(
                   sidebarMenu(id = "sidebarmenu",
                     menuItem("BRC Data Snapshot", icon = icon("th"), tabName = "brcstats"),
                     menuItem("External Data Snapshot", icon = icon("th"), tabName = "extstats"),
                     menuItem("Monthly Data Graph", icon = icon("chart-line"), tabName = "dygraph"),
                       conditionalPanel("input.sidebarmenu === 'dygraph'",
                                        selectInput("selector", "Select Series", multiple = TRUE, choices = colnames(databasemonthly), selected = "CPI.All.Items")),
                     menuItem("Monthly Data Table", icon = icon("table"), tabName = "table"),
                       conditionalPanel("input.sidebarmenu === 'table'",
                                        selectInput("selector2", "Select Series", multiple = TRUE, choices = colnames(databasemonthlydf), selected = c("CPI.All.Items", "date")),
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
                                      selectInput("selector7", "Select Series", multiple = TRUE, choices = colnames(databaseyearly), selected = "Local.Units...UK")),
                     menuItem("Yearly Data Table", icon = icon("table"), tabName = "table3"),
                     conditionalPanel("input.sidebarmenu === 'table3'",
                                      selectInput("selector8", "Select Series", multiple = TRUE, choices = colnames(databaseyearlydf), selected = c("Local.Units...UK", "date")),
                                      dateRangeInput("selector9", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                     format = "yyyy-mm-dd", weekstart = 0)),
                     menuItem("UK Nations Map", icon = icon("map-marked-alt"), tabName = "nationmap"),
                     menuItem("UK Regions Map", icon = icon("map-marked-alt"), tabName = "regionmap"),
                     menuItem("BRC Release Calendar", icon = icon("calendar"), tabName = "calendar")
                     
                     )),
                 
                 dashboardBody(      
                        
                    tabItems(
                          
                      tabItem(tabName = "brcstats",
                        h3("BRC Data Snapshot"),
                        
                        fluidRow(
                          valueBox(subtitle = "RSM Total (YoY Change)", value = paste0(round(tail(RSM$`Total Sales (% yoy change):BRC-KPMG RSM`, 1), 1),"%"), color = "red"),
                          valueBox(subtitle = "RSM Total Food 3-mth avg (YoY Change)", value = paste0(round(tail(RSM$`Food Sales 3 month average (% yoy change)`, 1), 1), "%"), color = "red"),
                          valueBox(subtitle = "RSM Total Non-Food 3-mth avg (YoY Change)", value = paste0(round(tail(RSM$`Food Sales Non-Food 3 month average (% yoy change)`, 1), 1), "%"), color = "red")),
                          
                        fluidRow(
                          valueBox(subtitle = "SPI All Items (YoY Change)", value = paste0(round(tail(spi_all, 1), 1), "%"), color = "yellow"),
                          valueBox(subtitle = "SPI Food (YoY Change)", value = paste0(round(tail(spi_food, 1), 1), "%"), color = "yellow"),
                          valueBox(subtitle = "SPI Non-Food (YoY Change)", value = paste0(round(tail(spi_nonfood, 1), 1), "%"), color = "yellow")),
                          
                        fluidRow(
                          valueBox(subtitle = "High Street Footfall (YoY Change)", value = paste0(round(tail(FF_Highst, 1), 1), "%"), color = "green"),
                          valueBox(subtitle = "Retail Park Footfall (YoY Change)", value = paste0(round(tail(FF_RetailPark, 1), 1), "%"), color = "green"),
                          valueBox(subtitle = "Shopping Centre Footfall (YoY Change)", value = paste0(round(tail(FF_ShoppingCentre, 1), 1), "%"), color = "green")),
                          
                        fluidRow(
                          valueBox(subtitle = "REM Employment (YoY Change)", value = paste0(round(tail(REM_emp, 1), 1), "%"), color = "aqua"),
                          valueBox(subtitle = "REM Hours (YoY Change)", value = paste0(round(tail(REM_hrs, 1), 1), "%"), color = "aqua"),
                          valueBox(subtitle = "REM Stores (YoY Change)", value = paste0(round(tail(REM_stores, 1), 1), "%"), color = "aqua")),
                        
                        fluidRow(
                          valueBox(subtitle = "DRI Website Visits (YoY Change)", value = paste0(round(tail(DRI_Master$`BRC-Hitwise Growth in retailer website visits (yoy %)`, 1), 1), "%"), color = "blue"),
                          valueBox(subtitle = "DRI Mobile Share", value = paste0(round(tail(DRI_Master$`BRC-Hitwise Mobile Share of retail website visits (%)`, 1), 1), "%"), color = "blue"))),
                        
                        
                      tabItem(tabName = "extstats",
                        h3("External Data Snapshot"),
                                    
                        fluidRow(
                          valueBox(subtitle = "RSI Overall (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$`RSI Values - All retailing excluding automotive fuel`, 1), 1),"%"), color = "red"),
                          valueBox(subtitle = "RSI Food (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$`RSI Values - Predominantly food stores`, 1), 1),"%"), color = "red"),
                          valueBox(subtitle = "RSI Online (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$`RSI Values - Internet`, 1), 1),"%"), color = "red")),
                        
                        fluidRow(
                          valueBox(subtitle = "CPI All Items (YoY Change)", value = paste0(tail(cpi_all, 1), "%"), color = "yellow"),
                          valueBox(subtitle = "CPI Food (YoY Change)", value = paste0(round(tail(cpi_food, 1), 1), "%"), color = "yellow"),
                          valueBox(subtitle = "CPI Non-Food (YoY Change)", value = paste0(round(tail(cpi_nonfood, 1), 1), "%"), color = "yellow")),
                        
                        fluidRow(
                          valueBox(subtitle = "GVA Whole Economy (YoY Change)", value = paste0(tail(GVAmonthly_yoy), "%"), color = "green"),
                          valueBox(subtitle = "GVA Whole Economy Quarterly (£m)", value = paste0("£", prettyNum(tail(gva_all, 1), big.mark = ",", scientific=FALSE)), color = "green"),
                          valueBox(subtitle = "GVA Retail Quarterly (£m)", value = paste0("£", prettyNum(tail(gva_retail, 1), big.mark = ",", scientific=FALSE)), color = "green")),
                        
                        fluidRow(
                          valueBox(subtitle = "Unempoyment Rate", value = paste0(tail(unemp$`Unemployment Rate UK`, 1), "%"), color = "aqua"),
                          valueBox(subtitle = "Jobs Whole Economy (000's)", value = prettyNum(tail(empjobsquarterly_all + selfjobsquarterly_all, 1), big.mark = ",", scientific = FALSE), color = "aqua"),
                          valueBox(subtitle = "Jobs Retail (000's)", value = prettyNum(tail(empjobsquarterly_retail + selfjobsquarterly_retail, 1), big.mark = ",", scientific = FALSE), color = "aqua")),
                        
                        fluidRow(
                          valueBox(subtitle = "Average Weekly Earnings - Regular Pay (YoY Change)", value = paste0(tail(awe$`Regular Pay YoY Growth`, 1), "%"), color = "blue"),
                          valueBox(subtitle = "Average Weekly Earnings - Real Regular Pay (YoY Change)", value = paste0(tail(awe$`Real Regular Pay YoY Growth`, 1), "%"), color = "blue"))),
                        
                        
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
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
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
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
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
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
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
