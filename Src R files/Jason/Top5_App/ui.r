

library(shiny)


# ui.R

shinyUI(fluidPage(
  titlePanel("State Top 5 Beers"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("state",
                  label = "State",
                  choices = levels(US_Beer_Data$state),
                  selected = "California"),
      
      
    #  textInput("SelectColor", label = "Distribution Fill Color", value = "orange"),
      
      actionButton("action", label = "Update Chart")
      
    ),
    
    mainPanel(
      textOutput("MyTitle"),
      plotOutput("MyPlot"),
      dataTableOutput("MyTable"),
      align = "center"
      
            )
    )
)
)

