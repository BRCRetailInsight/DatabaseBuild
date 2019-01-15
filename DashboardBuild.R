library(shiny)
library(dygraphs)
library(shinydashboard)
library(DT)
library(xts)

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
                                      selectInput("selector4", "Select Series", multiple = TRUE, choices = colnames(databasequarterly), selected = "GVA.Whole.Economy")),
                     menuItem("Quarterly Data Table", icon = icon("table"), tabName = "table2"),
                     conditionalPanel("input.sidebarmenu === 'table2'",
                                      selectInput("selector5", "Select Series", multiple = TRUE, choices = colnames(databasequarterlydf), selected = c("GVA.Whole.Economy", "date")),
                                      dateRangeInput("selector6", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                     format = "yyyy-mm-dd", weekstart = 0)),
                     menuItem("Yearly Data Graph", icon = icon("chart-line"), tabName = "dygraph3"),
                     conditionalPanel("input.sidebarmenu === 'dygraph3'",
                                      selectInput("selector7", "Select Series", multiple = TRUE, choices = colnames(databaseyearly), selected = "Local.Units...UK")),
                     menuItem("Yearly Data Table", icon = icon("table"), tabName = "table3"),
                     conditionalPanel("input.sidebarmenu === 'table3'",
                                      selectInput("selector8", "Select Series", multiple = TRUE, choices = colnames(databaseyearlydf), selected = c("Local.Units...UK", "date")),
                                      dateRangeInput("selector9", "Select Dates", start = "2001-01-01", end = Sys.Date(),
                                                     format = "yyyy-mm-dd", weekstart = 0))
                     
                     )),
                 
                 dashboardBody(      
                        
                    tabItems(
                          
                      tabItem(tabName = "brcstats",
                        h2("BRC Data Snapshot"),
                        
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
                        h2("External Data Snapshot"),
                                    
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
                          valueBox(subtitle = "GVA Whole Economy Quarterly (£m)", value = paste0("£", tail(gva_all, 1)), color = "green"),
                          valueBox(subtitle = "GVA Retail Quarterly (£m)", value = paste0("£", tail(gva_retail, 1)), color = "green")),
                        
                        fluidRow(
                          valueBox(subtitle = "Unempoyment Rate", value = paste0(tail(unemp$`Unemployment Rate UK`, 1), "%"), color = "aqua"),
                          valueBox(subtitle = "Jobs Whole Economy (000's)", value = tail(empjobs_all + selfjobs_all, 1), color = "aqua"),
                          valueBox(subtitle = "Jobs Retail (000's)", value = tail(empjobs_retail + selfjobs_retail, 1), color = "aqua")),
                        
                        fluidRow(
                          valueBox(subtitle = "Average Weekly Earnings - Regular Pay (YoY Change)", value = paste0(tail(awe$`Regular Pay YoY Growth`, 1), "%"), color = "blue"),
                          valueBox(subtitle = "Average Weekly Earnings - Real Regular Pay (YoY Change)", value = paste0(tail(awe$`Real Regular Pay YoY Growth`, 1), "%"), color = "blue"))),
                        
                        
                      tabItem(tabName = "dygraph",
                        h2("Monthly Data Graph"),
                        
                        dygraphOutput("dygraph")),
                        
                      tabItem(tabName = "table",
                        h2("Monthly Data Table"),
                        fluidRow(
                        DT::dataTableOutput("table")),
                        fluidRow(
                          box(title = "Download Data", downloadButton("downloadData", "Download"))
                        )),
                      
                      
                      tabItem(tabName = "dygraph2",
                              h2("Quarterly Data Graph"),
                              
                              dygraphOutput("dygraph2")),
                      
                      tabItem(tabName = "table2",
                              h2("Quarterly Data Table"),
                              fluidRow(
                                DT::dataTableOutput("table2")),
                              fluidRow(
                                box(title = "Download Data", downloadButton("downloadData2", "Download"))
                              )),
                      
                      
                      tabItem(tabName = "dygraph3",
                              h2("Yearly Data Graph"),
                              
                              dygraphOutput("dygraph3")),
                      
                      tabItem(tabName = "table3",
                              h2("Yearly Data Table"),
                              fluidRow(
                                DT::dataTableOutput("table3")),
                              fluidRow(
                                box(title = "Download Data", downloadButton("downloadData3", "Download"))
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
}

  
#### Run Shiny ####

shinyApp(ui, server)

