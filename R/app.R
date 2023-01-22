Sys.setlocale('LC_ALL','C')

library(shiny)
library(dplyr)
library(ggplot2)
library(rsconnect)
library(plotly)

#setwd("C:/Users/18184/Documents/Interface3/")
Master <- read.csv("demo2.csv")

# Define UI for application 
ui <- fluidPage(theme = "bootstrap.css", style= "zoom: .80", tags$style("#gauge {align:center;"), tags$style("#textCUSIP {font-size:50px;height:50px;}"),
        
    
        fluidRow(style = "border-left: 1px solid #8d8d8d;border-right: 1px solid #8d8d8d;border-top: 1px solid #8d8d8d;height:300px",
          
           
              
            column(2,
                   h2("Search CUSIP", style="text-align: center;margin-top: 20px"),
                   p(textInput("textCUSIP","", value =""),style="margin-top:45px;"),
            h4(textOutput("print26"),style="text-align: center;color:#8d8d8d; font-weight: bolder;margin-top: 25px")),
                
            
            
            column(2,
                   h2("Last Trade Price", style="text-align: center;margin-top: 20px"),
                   h2(textOutput("print"),style="text-align: center; margin-top: 60px;color:#8d8d8d; font-weight: bolder")),
            
            column(2, 
                   h2("Real Worth", style="text-align: center;margin-top: 20px"),
                   h2(textOutput("print2"),style="text-align: center; margin-top: 60px;color:#8d8d8d; font-weight: bolder")),
                      
        
            
            column(3,
                   h2("Risk", style="text-align: center;margin-top: 20px"),
                   div(plotlyOutput("plot", height = "100%"), align = "center")),

            
            column(3,
                   h2("Default Probability", style="text-align: center;margin-top: 20px"),
                   div(plotlyOutput("plot2", height = "100%"), align = "center")),
            
            ),
            
        fluidRow(style = "border: 1px solid #8d8d8d;height:100px",
              
            column(3, 
                   h2("Coupon :", style="margin-top: 15px"),
                   h4(textOutput("print3"),style="color:#8d8d8d;font-weight: bolder")),
            
            column(3, 
                   h2("Maturity :", style="margin-top: 15px"),
                   h4(textOutput("print4"),style="color:#8d8d8d;font-weight: bolder")),
            
            column(3, 
                   h2("Last Trade Date :", style="margin-top: 15px"),
                   h4(textOutput("print5"),style="color:#8d8d8d;font-weight: bolder")),
            
            column(3, 
                   h2("Last Trade Price :", style="margin-top: 15px"),
                   h4(textOutput("print6"),style="color:#8d8d8d;font-weight: bolder")),
        ),
        
        fluidRow(style = "",
        
            column(3,style ="border-right: 1px solid #8d8d8d;border-left: 1px solid #8d8d8d",
                   h2("Issuer",style="text-decoration: underline; margin-top: 25px"),
                   h3("Issuer Adress:", style="margin-top: 25px"),h5(textOutput("print7"),style="color:#8d8d8d; margin-top: 10px"),
                   h3("City, State, Zip:", style="margin-top: 25px"),h5(textOutput("print8"),style="color:#8d8d8d; margin-top: 10px"),
                   h3("Issuer Type:", style="margin-top: 25px"),h5(textOutput("print9"),style="color:#8d8d8d; margin-top: 10px"),
                   h3("County:",style="margin-top: 25px"),h5(textOutput("print10"),style="color:#8d8d8d; margin-top: 10px")),
            
            column(3,style ="border-right: 1px solid #8d8d8d;",
                   h2("Trade", style="text-decoration: underline;margin-top: 25px"),
                   h3("Total Par Value:",style="margin-top: 20px"),h5(textOutput("print11"),style="color:#8d8d8d;margin-top: 10px"),
                   h3("Discount:",style="margin-top: 20px"),h5(textOutput("print12"),style="color:#8d8d8d;margin-top: 10px"),
                   h3("Yield:",style="margin-top: 20px"),h5(textOutput("print13"),style="color:#8d8d8d;margin-top: 10px"),
                   h3("Premium:",style="margin-top: 20px"),h5(textOutput("print14"),style="color:#8d8d8d;margin-top: 10px"),
                   h3("Type:",style="margin-top: 20px"),h5(textOutput("print15"),style="color:#8d8d8d;margin-top: 10px")),
                   
    
        column(6,style ="border-right: 1px solid #8d8d8d;",
               h2("Yield Over Time", style="text-align: center;margin-top: 20px"),
               plotlyOutput("plot3"))), 
        


fluidRow(style = "border-top: 1px solid #8d8d8d",
    
    column(3,style ="border-right: 1px solid #8d8d8d;border-left: 1px solid #8d8d8d",
           h2("Issuance",style="text-decoration: underline;margin-top: 25px"),
           h3("Voter Approved:",style="margin-top: 20px"),h5(textOutput("print16"),style="color:#8d8d8d"),
           h3("Sale Method:",style="margin-top: 20px"),h5(textOutput("print17"),style="color:#8d8d8d"),
           h3("Number of Bids:",style="margin-top: 20px"),h5(textOutput("print18"),style="color:#8d8d8d"),
           h3("Debt Type:",style="margin-top: 20px"),h5(textOutput("print19"),style="color:#8d8d8d"),
           h3("Purpose:",style="margin-top: 20px"),h5(textOutput("print20"),style="color:#8d8d8d")),
    
    column(3,style ="border-right: 1px solid #8d8d8d;",
           h2("Fundamentals",style="text-decoration: underline;margin-top: 25px"),
           h3("S&P Rating:", style="margin-top: 20px"),h5(textOutput("print121"),style="color:#8d8d8d"),
           h3("Moody's Rating:",style="margin-top: 20px"),h5(textOutput("print22"),style="color:#8d8d8d"),
           h3("Fitch Rating:",style="margin-top: 20px"),h5(textOutput("print23"),style="color:#8d8d8d"),
           h3("Underwriter:",style="margin-top: 20px"),h5(textOutput("print24"),style="color:#8d8d8d"),
           h3("Bond Counsel:",style="margin-top: 20px"),h5(textOutput("print25"),style="color:#8d8d8d")),
    
    column(6,style ="border-right: 1px solid #8d8d8d;",
           h2("Price Over Time", style="text-align: center;margin-top: 20px"),
           plotlyOutput("plot4")),
),

fluidRow(style = "border: 1px solid #8d8d8d;",
    
         column(12,
                
                h2("Data Summary",style="margin-top: 25px"),
                
                tags$div(tableOutput("results"),style="font-size:17px;overflow-x: scroll;border: 1px solid #8d8d8d;  height: 150px;overflow-y: hidden"))
         
         
         
))       

                    
        
        

# Define server logic
server <- function(input, output) {

    selectdata<-reactive({filter(Master, CUSIP %in% input$textCUSIP)})
    ##selectdata2<-reactive({filter(Master, CUSIP %in% input$selectCUSIP)})
    
    output$print <- renderText({print(as.character(selectdata()$LastTrade))})
    output$print2 <- renderText({print(as.character(selectdata()$RealWorth))})
    
    output$plot <- renderPlotly(
        plot_ly(
            domain = list(x = c(0, 1), y = c(0, 1)),
            value = selectdata()$Gauge, #Change to Tim's model specifications
            title = list(text = ""),
            type = "indicator",
            mode = "gauge",
            gauge = list(
                axis = list(range = list(0, 100), tick0 = 0, dtick = 100, tickcolor="#8d8d8d", tickfont=list(color="#8d8d8d")), 
                bar=list(color=toRGB("lightblue"), thickness=1), 
                bordercolor="#8d8d8d", 
                borderwidth = 2),
            height = 200,
            width = 350) 
        %>%
            layout(autosize = F, margin = list(r=50), paper_bgcolor="#000000"))
    random = floor(runif(100, min=1, max=100))
    
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
    
    output$plot2 <- renderPlotly(plot_ly(x = ~rnorm(selectdata()$Prob),
                                         type = "histogram",
                                         histnorm = "probability",
                                         
                                         marker=list(
                                             color = toRGB("lightblue"),
                                             line = list(color = "rgba(141, 141, 141, 1)",
                                                         width = 2)
                                         ),
                                         hoverlabel=list(bgcolor=("white")),
                                         height = 200,
                                         width = 400
    )
    %>%
        layout(autosize = F,plot_bgcolor="#000000",paper_bgcolor="#000000", xaxis=ax,yaxis=ax, margin=list(r=100)))
    
    
    tm <- seq(0, 600, by = 10)
    
    z<-reactive({as.numeric(sub("%", "", as.character(selectdata()$Yield)))-tm})
    y<-reactive({rnorm(length(z()))})
    
    output$plot3 <- renderPlotly({plot_ly(type='scatter',x = ~z(), y = ~y(), mode = 'lines', text = paste(tm, "days from today"))} %>%
                                     layout(plot_bgcolor="#000000",paper_bgcolor="#000000"))
    
    L <- seq(0, 400, by = 8)
    t<-reactive({as.numeric(sub("%", "", as.character(selectdata()$Yield)))-L})
    a<-reactive({rnorm(length(t()))})
    
    output$plot4 <- renderPlotly({plot_ly(type='scatter',x = ~t, y = ~a(), mode = 'lines', text = paste(L, "days from today"))}%>%
                                     layout(plot_bgcolor="#000000",paper_bgcolor="#000000"))
    
    output$results <- renderTable({selectdata()})
    output$print3 <- renderText({print(as.character(selectdata()$NetTaxExemptInterestRate))}) 
    output$print4 <- renderText({print(as.character(selectdata()$MaturityDate))})
    output$print5 <- renderText({print(as.character(selectdata()$SaleDate))})
    output$print6 <- renderText({print(as.character(selectdata()$LastTrade))})
    output$print7 <- renderText({print(as.character(selectdata()$IssuerAddress))})
    output$print8 <- renderText({print(as.character(selectdata()$IssuerCity_State_Zip))})
    output$print9 <- renderText({print(as.character(selectdata()$IssuerType))})
    output$print10 <- renderText({print(as.character(selectdata()$County))})
    output$print11 <- renderText({print(as.character(selectdata()$TotalParValue))})
    output$print12 <- renderText({print(as.character(selectdata()$Discount))})
    output$print13 <- renderText({print(as.character(selectdata()$Yield))})
    output$print14 <- renderText({print(as.character(selectdata()$Premium))})
    output$print15 <- renderText({print(as.character(selectdata()$Type))})
    output$print16 <- renderText({print(as.character(selectdata()$VoterApproved))})
    output$print17 <- renderText({print(as.character(selectdata()$SaleMethod))})
    output$print18 <- renderText({print(as.character(selectdata()$NumberofBids))})
    output$print19 <- renderText({print(as.character(selectdata()$DebtType))})
    output$print20 <- renderText({print(as.character(selectdata()$Purpose))})
    output$print21 <- renderText({print(as.character(selectdata()$SPRating))})
    output$print22 <- renderText({print(as.character(selectdata()$MoodyRating))})
    output$print23 <- renderText({print(as.character(selectdata()$FitchRating))})
    output$print24 <- renderText({print(as.character(selectdata()$LeadUnderwriter))})
    output$print25 <- renderText({print(as.character(selectdata()$BondCounsel))})
    output$print26 <- renderText({print(as.character(selectdata()$IssueTitle))})
}

# Run the application 
shinyApp(ui = ui, server = server)
