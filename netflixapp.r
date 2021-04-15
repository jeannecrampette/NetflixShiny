setwd("~/Desktop/Netflix_app")
library(readr)
library(shiny)
library(ggplot2)
NetflixViewingHistory <- read_csv("NetflixViewingHistory.csv", 
                                  col_types = cols(Date = col_date(format = "%d/%m/%Y")))
plotnetflix <- table(NetflixViewingHistory$Date)
plotnetflix <- as.data.frame(plotnetflix)
names(plotnetflix)[names(plotnetflix) == "Var1"]<- "Dates"

ui <- fluidPage(
  titlePanel("Netflix Viewing History"),
  sidebarLayout(position = "right",
    sidebarPanel(
      helpText("To see the evolution of my Netflix consumption since 2018, look at the graph. To see more details about the programs I watched, play with the Date Range below !"),
      br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
      dateRangeInput(
                     inputId = "DateRange", 
                     label = "Choose the period you want to",
                     start = "2018-06-24", 
                     end = "2018-12-31",
                     min = "2018-06-24",
                     max = "2021-03-29",
                     format = "yyyy-mm-dd"),
      
    ),
    mainPanel(
      plotOutput("Nplot"),
      tableOutput(outputId = "distPlot"),
      
    )
  )
)

server <- function(input, output) {
  output$Nplot <- renderPlot(ggplot(plotnetflix, aes(x=Dates, y=Freq))+ geom_bar(stat = 'identity'))
  output$distPlot <-  renderTable({
    
    NetflixViewingHistory$Date<-as.Date(NetflixViewingHistory$Date,format = "%d/%m/%Y")
    x <- NetflixViewingHistory$Title[NetflixViewingHistory$Date >= input$DateRange[1] & NetflixViewingHistory$Date <= input$DateRange[2]]
    
    return(x)
  })
  
  
}

shinyApp(ui = ui, server = server)
