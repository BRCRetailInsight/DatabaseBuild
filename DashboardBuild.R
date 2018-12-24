library(shiny)
library(dygraphs)
library(shinydashboard)
library(DT)

#colours
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")

#### Create Single Unified Database for Graph & Table ####

# merge xts objects into one big dataset
database <- merge(cpi_all, spi_all, all = TRUE, fill = NA)

# correct column names so that series selector displays useful names




#### Shiny UI ####

ui <- dashboardPage(skin = "blue",
                 dashboardHeader(title = "Retail Data"),
                 dashboardSidebar(
                   sidebarMenu(id = "sidebarmenu",
                     menuItem("BRC Data Snapshot", icon = icon("th"), tabName = "brcstats"),
                     menuItem("External Data Snapshot", icon = icon("th"), tabName = "extstats"),
                     menuItem("All Data Graph", icon = icon("chart-line"), tabName = "dygraph"),
                       conditionalPanel("input.sidebarmenu === 'dygraph'",
                                        selectInput("selector", "Select Series", multiple = TRUE, choices = colnames(database), selected = "CPI.All.Items")),
                     menuItem("All Data Table", icon = icon("table"), tabName = "table"),
                       conditionalPanel("input.sidebarmenu === 'table'",
                                        selectInput("selector2", "Select Series", multiple = TRUE, choices = colnames(database), selected = "CPI.All.Items"),
                                        dateRangeInput("selector3", "Select Dates", start = "2001-01-01", end = Sys.Date(),
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
                          valueBox(subtitle = "RSI Overall (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$J3L2, 1), 1),"%"), color = "red"),
                          valueBox(subtitle = "RSI Food (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$EAIA, 1), 1),"%"), color = "red"),
                          valueBox(subtitle = "RSI Online (NSA) (YoY Change)", value = paste0(round(tail(rsi_val$KP3T, 1), 1),"%"), color = "red")),
                        
                        fluidRow(
                          valueBox(subtitle = "CPI All Items (YoY Change)", value = paste0(tail(cpi_all, 1), "%"), color = "yellow"),
                          valueBox(subtitle = "CPI Food (YoY Change)", value = paste0(round(tail(cpi_food, 1), 1), "%"), color = "yellow"),
                          valueBox(subtitle = "CPI Non-Food (YoY Change)", value = paste0(round(tail(cpi_nonfood, 1), 1), "%"), color = "yellow")),
                        
                        fluidRow(
                          valueBox(subtitle = "GVA Whole Economy (YoY Change)", value = paste0(tail(GVAmonthly_yoy), "%"), color = "green"),
                          valueBox(subtitle = "GVA Whole Economy Quarterly (£m)", value = paste0("£", tail(gva_all, 1)), color = "green"),
                          valueBox(subtitle = "GVA Retail Quarterly (£m)", value = paste0("£", tail(gva_retail, 1)), color = "green")),
                        
                        fluidRow(
                          valueBox(subtitle = "Unempoyment Rate", value = paste0(tail(unemp$MGSX, 1), "%"), color = "aqua"),
                          valueBox(subtitle = "Jobs Whole Economy (000's)", value = tail(empjobs_all + selfjobs_all, 1), color = "aqua"),
                          valueBox(subtitle = "Jobs Retail (000's)", value = tail(empjobs_retail + selfjobs_retail, 1), color = "aqua")),
                        
                        fluidRow(
                          valueBox(subtitle = "Average Weekly Earnings - Regular Pay (YoY Change)", value = paste0(tail(awe$KAI8, 1), "%"), color = "blue"),
                          valueBox(subtitle = "Average Weekly Earnings - Real Regular Pay (YoY Change)", value = paste0(tail(awe$A2F9, 1), "%"), color = "blue"))),
                        
                        
                      tabItem(tabName = "dygraph",
                        h2("All Data Graph"),
                        
                        dygraphOutput("dygraph")),
                        
                      tabItem(tabName = "table",
                        h2("All Data Table"),
                        fluidRow(
                        DT::dataTableOutput("table")),
                        fluidRow(
                          box(title = "Download Data", downloadButton("downloadData", "Download"))
                        ))
                      
                        )))
                 

#### Shiny Server ####

server <- function(input, output, session) {
  
  data <- reactive({
    database[,input$selector]
  })

  output$dygraph <- renderDygraph({
    dygraph(data()) %>%
      dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
      dyAxis("y", label = "% Year-on-Year", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
      dyRangeSelector() %>%
      dyCrosshair(direction = "vertical")
  })
  
  data2 <- reactive({
    database[(database$date>=min(input$selector3[1]) & database$date<=max(input$selector3[2])),input$selector2]
  })
  
  output$table = DT::renderDataTable({
    DT::datatable(data2())
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$selector2, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data2(), file(), row.names = TRUE)
    }
  )
}

  
#### Run Shiny ####

shinyApp(ui, server)
