

library(shiny)
library(dplyr)
library(ggplot2)
library(rsconnect)
library(plotly)
library(httr)
library(rjson)

#setwd("C:/Users/18184/Documents/Interface5/")
Master <- read.csv("Bloomberg.csv")
Last10 <-  read.csv("Last10.csv")
Comp10 <-  read.csv("Comp10.csv")
YieldPrice <-  read.csv("yieldprice.csv")
   
        
        
    
# Define UI for application 
ui <- fluidPage(style= "font-family:Arial,Helvetica,sans-serif; zoom: .80; color:#DCDCDC",tags$style("#gauge {align:center;"), tags$style("#textCUSIP {font-size:35px;height:50px;}"),
             
        fluidRow(style = "border-top: 1px solid #8d8d8d;height:200px;background-color:#111111; height:150px",
             
                column(2,
                        
                        p(textInput("textCUSIP","", value ="797412CD3"),style="margin-top:30px")),
                        actionButton("request", "Search"),
                        
                
                column(10,
                       h1(textOutput("print"),style="text-align: center;color:#8d8d8d; font-weight: bolder;margin-top: 65px"))),
                
        fluidRow(style = "border-top: 1px solid #8d8d8d;height:300px;background-color:#141721",
          
                
                 
                 column(1,style ="background-color:#141721",
                        h2("Rating",style="margin-top: 25px;font-size:28px; color:#8d8d8d"),
                    fluidRow(style="border-bottom: thin solid #8d8d8d",
                        h3("S&P:",style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                    fluidRow(style="border-bottom: thin solid #8d8d8d",
                        h3("Fitch:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                    fluidRow(style="border-bottom: thin solid #8d8d8d",
                        h3("Moody's:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                    fluidRow(style="border-bottom: thin solid #8d8d8d",
                        h3("CUSIP:",style="margin-left:10px;font-size:17px;color:#8d8d8d"))),
                 
                 column(1,style ="background-color:#141721",
                        h2("Rating",style="margin-top: 25px;font-size:28px; color:#141721"),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3(textOutput("print6"),style="font-size:17px;color:#8d8d8d;font-weight: bolder")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print7"),style="font-size:17px;color:#8d8d8d;font-weight: bolder")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print8"),style="font-size:17px;color:#8d8d8d;font-weight: bolder")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d;",
                                 h3(textOutput("print9"),style="font-size:17px;color:#8d8d8d;font-weight: bolder"))),
                    
            column(3,
                   h2("Rich/Cheap Analysis", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:28px"),
                   div(plotlyOutput("plot5", height = "100%"), align = "center")),
            
            column(2,
                   h2("Model Price", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:28px"),
                   h1(textOutput("print10"),style="text-align: center; margin-top: 50px;font-size:5vw;color:#8d8d8d;font-weight: bolder;margin-left: -20px;border: 1px solid #8d8d8d")),
                      
        
            
            column(3,
                   h2("Risk Meter", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:28px"),
                   div(plotlyOutput("plot", height = "100%"), align = "center", style="margin-right: -60px;margin-top: 40px")),

            
            column(2,
                   h2("Default Probability", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:28px"),
                   div(plotlyOutput("plot2", height = "100%"), align = "left", style="margin-right: -20px"))),
            
            
            
        fluidRow(style = "border-top: 1px solid #8d8d8d;border-bottom: 1px solid #8d8d8d;height:80px;background-color:#111111",
              
            column(1, 
                   h3("Coupon :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
                   
            column(1,
                   h3(textOutput("print11"),style="margin-top: 18px;margin-left: -50px;color:#8d8d8d;font-weight: bolder;font-size:17px")),
            
            column(1, 
                   h3("Maturity :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
                   
            column(1,
                    h3(textOutput("print12"),style="margin-top: 18px;margin-left: -50px;color:#8d8d8d;font-weight: bolder;font-size:17px")),
            
            column(1, 
                   h2("Last Trade :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
                   
            column(1,
                    h3(textOutput("print13"),style="margin-top: 18px;margin-left: -20px;color:#8d8d8d;font-weight: bolder;font-size:17px")),
            
            column(1, 
                    h3("Last Price :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
            
            column (1,
                    h3(textOutput("print14"),style="margin-top: 18px;margin-left: -20px;color:#8d8d8d;font-weight: bolder;font-size:17px")),
            
            column(1, 
                   h3("Outstanding :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
            
            column(1,
                   h3(textOutput("print35"),style="margin-top: 18px;margin-left: -5px;color:#8d8d8d;font-weight: bolder;font-size:17px")),
            
            column(1, 
                   h3("Volume :", style="color:#8d8d8d;margin-top: 18px;font-size:17px")),
            
            column(1,
                   h3(textOutput("print36"),style="margin-top: 18px;margin-left: -50px;color:#8d8d8d;font-weight: bolder;font-size:17px"))),
        
        
        fluidRow(style ="background-color:#141721",
        
                 column(1,style ="background-color:#141721",
                        h2("Yield",style="margin-top: 25px;font-size:28px; color:#8d8d8d"),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Mid Current:",style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Bid Current:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Ask Current:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("To Maturity:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("To Worst:",style="margin-left:10px;font-size:17px;color:#8d8d8d"))),
                 
                 column(1,style ="background-color:#141721;",
                        h2("Yield",style="margin-top: 25px;font-size:28px; color:#141721"),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3(textOutput("print15"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d;",
                                 h3(textOutput("print16"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print17"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print18"),style="font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d;",
                                 h3(textOutput("print19"),style="font-size:17px;color:#8d8d8d;"))),
                 
                 column(1,style ="background-color:#141721",
                        h2("Bond",style="margin-top: 25px;font-size:28px;color:#8d8d8d"),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Purpose:",style="font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Source:", style="font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Series:", style="font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Issue Type:", style="font-size:17px;color:#8d8d8d")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3("Maturity Type:",style="font-size:17px;color:#8d8d8d"))),
                 
                 column(2,style ="background-color:#141721;",
                        h2("Bond",style="margin-top: 25px;font-size:28px; color:#141721"),
                        fluidRow(style="border-bottom: thin solid #8d8d8d",
                                 h3(textOutput("print20"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print21"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print22"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                                 h3(textOutput("print23"),style="font-size:17px;color:#8d8d8d;")),
                        fluidRow(style="border-bottom: thin solid #8d8d8d;",
                                 h3(textOutput("print24"),style="font-size:17px;color:#8d8d8d;"))),
                   
    
        column(7,style ="background-color:#141721",
               h2("Yield Over Time", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:25px"),
               plotlyOutput("plot3", height = "300px"))), 
        


fluidRow(style = "border-top: 1px solid #8d8d8d;background-color:#141721",
    
         column(1,style ="background-color:#141721",
                h2("Price",style="margin-top: 25px;font-size:28px; color:#8d8d8d"),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Bid:",style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Mid:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Ask:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Day Change:", style="margin-left:10px;font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Last Close:",style="margin-left:10px;font-size:17px;color:#8d8d8d"))),
         
         column(1,style ="background-color:#141721;",
                h2("Price",style="margin-top: 25px;font-size:28px; color:#141721"),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3(textOutput("print25"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print26"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print27"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print28"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d;",
                         h3(textOutput("print29"),style="font-size:17px;color:#8d8d8d;"))),
         
         column(1,style ="background-color:#141721",
                h2("Fundamentals",style="margin-top: 25px;font-size:28px; color:#8d8d8d"),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Issue Size:",style="font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Maturity Size:", style="font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Tax Provision:", style="font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Offering:", style="font-size:17px;color:#8d8d8d")),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3("Underwriter:",style="font-size:17px;color:#8d8d8d"))),
         
         column(2,style ="background-color:#141721;",
                h2("Fundamentals",style="margin-top: 25px;font-size:28px; color:#141721"),
                fluidRow(style="border-bottom: thin solid #8d8d8d",
                         h3(textOutput("print30"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print31"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print32"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d; ",
                         h3(textOutput("print33"),style="font-size:17px;color:#8d8d8d;")),
                fluidRow(style="border-bottom: thin solid #8d8d8d;",
                         h3(textOutput("print34"),style="font-size:17px;color:#8d8d8d;"))),    
    
    column(7,style ="background-color:#141721",
           h2("Price Over Time", style="color:#8d8d8d;text-align: center;margin-top: 20px;font-size:25px"),
           plotlyOutput("plot4", height = "300px"))),


fluidRow(style = "border-top: 1px solid #8d8d8d;background-color:#111111",
    
         column(12,
                
                h2("Summary",style="color:#8d8d8d;margin-top: 25px;font-size:35px"),
                
                tags$div(tableOutput("results"),style="color:#8d8d8d;font-size:17px;overflow-x: scroll;  height: 150px;overflow-y: hidden"))),
         
fluidRow(style = "border-top: 1px solid #8d8d8d;background-color:#141721",
                  
                  column(6,
                         
                         h2("Last 10 Trades",style="color:#8d8d8d;margin-top: 25px;font-size:35px"),
                         
                         tags$div(tableOutput("results2"),style="color:#8d8d8d;font-size:19px")),
                  
                column(6,style ="background-color:#141721",
       
                        h2("10 Comparable Trades ",style="color:#8d8d8d;margin-top: 25px;font-size:35px"),
       
                        tags$div(tableOutput("results3"),style="color:#8d8d8d;font-size:19px"))))
                    
        
        

# Define server logic
server <- function(input, output) {
    
    selectdata<-reactive({filter(Master, CUSIP %in% input$textCUSIP)})
    selectdata2<-reactive({filter(Last10, CUSIP %in% input$textCUSIP)})
    selectdata3<-reactive({filter(YieldPrice, CUSIP %in% input$textCUSIP)})
    ##selectdata2<-reactive({filter(Master, CUSIP %in% input$selectCUSIP)})
    
    output$print <- renderText({print(as.character(selectdata()$Title))})
    
    observeEvent(input$request, {
        response <- GET("http://httpbin.org/get")
        print(response)
    })
   
        output$plot <- renderPlotly(
            plot_ly(type = "indicator",
                    mode = "number+gauge+delta",
                    value = selectdata()$Risk1,
                    domain = list(x = c(0, 1), y= c(0, 1)),
                    title = list(text = ""),
                    delta = list(reference = 50,increasing = list(color = "#FD625E"),decreasing = list(color = "#01B8AA")),
                    gauge = list(
                        shape = "bullet",
                        bar = list(color = "#374649"),
                        axis = list(range = list(0, 100)),
                        threshold = list(
                            line = list(color = "#374649", width = 1),
                            thickness = 0.75,
                            value = selectdata()$Risk1),
                        steps = list(
                            list(range = c(0, 50), color = "#51A39A "),
                            list(range = c(50, 75), color = "#F19757"),
                            list(range = c(75, 100), color = "#DE5E56"))),
                    height = 150, width = 375) %>%
                layout(margin = list(l= 3, r= 10),
                       paper_bgcolor = "#141721",
                       font = list(color = "#8d8d8d", family = "Arial")))
                
    
    f2 <- list(
        size = 14,
        color = "#8d8d8d")
    
    ax <- list(
        zeroline = TRUE,
        showline = TRUE,
        mirror = "ticks",
        linecolor = toRGB("lightblue"),
        linewidth = 1,
        title="",
        tickfont=f2
    )
    
    
    b <- c(5, 10, 15, 20, 25)
    c <- c(0.1, 0.2, 0.3, 0.2, 0.1)
    dataf <- data.frame(b, c)
    
    output$plot2 <- renderPlotly({plot_ly(dataf, x = ~b, y = ~c, type = 'bar', color = I("#51A39A"),height = 200,
                                          width = 350)} %>%
                                     layout(title = "",
                                            plot_bgcolor="#141721",paper_bgcolor="#141721",
                                            font = list(color = "#8d8d8d"),
                                            xaxis = list(title = "Year"),
                                            yaxis = list(title = "Percent (%)")))
    
    
    dte <- reactive({selectdata3()$Date2})
    yld <- reactive({selectdata3()$MidYTM})
    yld2 <- reactive({selectdata3()$BidYTM})
    yld3 <- reactive({selectdata3()$AskYTM})
    
    
    mid_annotations <- list(
        x=~dte(), 
        y=~yld(),
        xref='x', yref='y')
    
    bid_annotations <- list(
        x=~dte(), 
        y=~yld2(),
        xref='x', yref='y')
    
    ask_annotations <- list(
        x=~dte(), 
        y=~yld3(),
        xref='x', yref='y')
    
    # updatemenus component
    updatemenus <- list(
        list(
            active = -1,
            type= 'buttons',
            buttons = list(
                list(
                    label = "Ask",
                    method = "update",
                    args = list(list(visible = c(TRUE, FALSE, FALSE)),
                                list(title = "",
                                     annotations = list(mid_annotations, c(), c())))),
                list(
                    label = "Mid",
                    method = "update",
                    args = list(list(visible = c(FALSE, TRUE, FALSE)),
                                list(title = "",
                                     annotations = list(c(), bid_annotations, c())))),
                
                list(
                    label = "Bid",
                    method = "update",
                    args = list(list(visible = c(FALSE, FALSE, TRUE)),
                                list(title = "",
                                     annotations = list(c(), c(), ask_annotations)))))))

                
    
    output$plot3 <- renderPlotly({
        plot_ly(type = 'scatter', mode = 'lines')} %>%
            add_lines(x=~dte(), y=~yld(), name="Mid",
                      line=list(color="#00b9f3")) %>%
            add_lines(x=~dte(), y=~yld2(), name="Bid",
                      line=list(color="#33CFA5")) %>%
            add_lines(x=~dte(), y=~yld3(), name="Ask",
                      line=list(color="#F06A6A")) %>%
            layout(title = "", showlegend=TRUE,
                   font = list(color = '#8d8d8d'),
                   xaxis=list(title="Date",gridcolor = "#373C4D",gridwidth = 1),
                   yaxis=list(title="Yield",gridcolor = "#373C4D",gridwidth = 1),
                   plot_bgcolor="#141721",paper_bgcolor="#141721",
                   updatemenus=updatemenus))
    
    
    
    dte2 <- reactive({selectdata3()$Date2})
    pr1 <- reactive({selectdata3()$MidPrice})
    pr2 <- reactive({selectdata3()$LastPrice})
    
    pr1_annotations <- list(
        x=~dte2(), 
        y=~pr1(),
        xref='x', yref='y')
    
    pr2_annotations <- list(
        x=~dte2(), 
        y=~pr2(),
        xref='x', yref='y')
    
    # updatemenus component
    updatemenus2 <- list(
        list(
            active = -1,
            type= 'buttons',
            buttons = list(
                list(
                    label = "Last price",
                    method = "update",
                    args = list(list(visible = c(TRUE, FALSE)),
                                list(title = "",
                                     annotations = list(pr1_annotations, c())))),
                list(
                    label = "Mid Price",
                    method = "update",
                    args = list(list(visible = c(FALSE, TRUE)),
                                list(title = "",
                                     annotations = list(c(), pr2_annotations, c())))))))
                
    
    output$plot4 <- renderPlotly({
        plot_ly(type = 'scatter', mode = 'lines')} %>%
            add_lines(x=~dte2(), y=~pr1(), name="Mid",
                      line=list(color="#00b9f3")) %>%
            add_lines(x=~dte2(), y=~pr2(), name="Last",
                      line=list(color="#33CFA5")) %>%
            
            layout(title = "", showlegend=TRUE,
                   font = list(color = '#8d8d8d'),
                   xaxis=list(title="Date",gridcolor = "#373C4D",gridwidth = 1),
                   yaxis=list(title="Price",gridcolor = "#373C4D",gridwidth = 1),
                   plot_bgcolor="#141721",paper_bgcolor="#141721",
                   updatemenus=updatemenus2))
     
   
    
    output$plot5 <- renderPlotly(
        plot_ly(
            type = "indicator",
            mode = "gauge+number+delta",
            value = selectdata()$Price2,
            title = list(text = "", font = list(size = 24)),
            delta = list(reference = selectdata()$Mid2, increasing = list(color = "#FD625E"),decreasing = list(color = "#01B8AA")),
            gauge = list(
                axis = list(range = list(selectdata()$Bid2, selectdata()$Ask2), tickwidth = 1, tickcolor = "#374649"),
                bar = list(color = "#374649"),
                bgcolor = "#DCDCDC",
                borderwidth = 1,
                bordercolor = "gray",
                steps = list(
                    list(range = c(selectdata()$Bid2, selectdata()$Mid2), color = "#51A39A"),
                    list(range = c(selectdata()$Mid2, selectdata()$Ask2), color = "#DE5E56")),
                threshold = list(
                    line = list(color = "#374649", width = 1),
                    thickness = 0.75,
                    value = selectdata()$Price2)),height = 200,
            width = 350) %>%
            layout(
                margin = list(l=20,r=30),
                paper_bgcolor = "#141721",
                font = list(color = "#8d8d8d", family = "Arial")))
    
    output$results <- renderTable({selectdata()})
    output$results2 <- renderTable({selectdata2()})
    output$results3 <- renderTable(Comp10)
    output$print2 <- renderText({print(as.character(selectdata()$Borrower))})
    output$print3 <- renderText({print(as.character(selectdata()$County))}) 
    output$print4 <- renderText({print(as.character(selectdata()$x))})
    output$print5 <- renderText({print(as.character(selectdata()$x))})
    output$print6 <- renderText({print(as.character(selectdata()$SP))})
    output$print7 <- renderText({print(as.character(selectdata()$Fitch))})
    output$print8 <- renderText({print(as.character(selectdata()$Moodys))})
    output$print9 <- renderText({print(as.character(selectdata()$CUSIP))})
    output$print10 <- renderText({print(as.character(selectdata()$Price1))})
    output$print11 <- renderText({print(as.character(selectdata()$Coupon))})
    output$print12 <- renderText({print(as.character(selectdata()$Maturity))})
    output$print13 <- renderText({print(as.character(selectdata()$DateofLastClose))})
    output$print14 <- renderText({print(as.character(selectdata()$LastTradePrice))})
    output$print15 <- renderText({print(as.character(selectdata()$MidCurrentYield))})
    output$print16 <- renderText({print(as.character(selectdata()$BidCurrentYield))})
    output$print17 <- renderText({print(as.character(selectdata()$AskCurrentYield))})
    output$print18 <- renderText({print(as.character(selectdata()$MidYTM))})
    output$print19 <- renderText({print(as.character(selectdata()$NetYieldtoworst))})
    output$print20 <- renderText({print(as.character(selectdata()$Purpose))})
    output$print21 <- renderText({print(as.character(selectdata()$Source))})
    output$print22 <- renderText({print(as.character(selectdata()$Series))})
    output$print23 <- renderText({print(as.character(selectdata()$IssueType))})
    output$print24 <- renderText({print(as.character(selectdata()$MaturityType))})
    output$print25 <- renderText({print(as.character(selectdata()$BidPrice))})
    output$print26 <- renderText({print(as.character(selectdata()$MidPrice))})
    output$print27 <- renderText({print(as.character(selectdata()$AskPrice))})
    output$print28 <- renderText({print(as.character(selectdata()$PriceChangeonDay))})
    output$print29 <- renderText({print(as.character(selectdata()$PreviousclosingValue))})
    output$print30 <- renderText({print(as.character(selectdata()$IssueSize))})
    output$print31 <- renderText({print(as.character(selectdata()$MaturitySize))})
    output$print32 <- renderText({print(as.character(selectdata()$TaxProvision))})
    output$print33 <- renderText({print(as.character(selectdata()$OfferingType))})
    output$print34 <- renderText({print(as.character(selectdata()$Underwriter))})
    output$print35 <- renderText({print(as.character(selectdata()$AmountOutstanding))})
    output$print36 <- renderText({print(as.character(selectdata()$TotalVolume))})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
