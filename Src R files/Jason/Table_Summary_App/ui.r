

library(shiny)


# ui.R

shinyUI(fluidPage(
  titlePanel("US Beers"),
  
  sidebarLayout(
    sidebarPanel(
      
      # selectInput("state",
      #             label = "State",
      #             choices = levels(US_Beer_Data$state),
      #             selected = "California"),
      
      selectInput("city",
                  label = "city",
                  choices = levels(US_Beer_Data$city),
                  selected = "Los Angeles"),
      
      sliderInput("minNum", "Minimum # of ratings:",
                  min=0, max=20000, value=500),
      
      
      # Specification of ABV range within an interval
      sliderInput("range", "Range:",
                  min = 0, max = 57, value = c(4,10)),
      
      
      
    #  textInput("SelectColor", label = "Distribution Fill Color", value = "orange"),
      
      actionButton("action", label = "Update Chart")
      
    ),
    
    mainPanel(
      textOutput("MyTitle"),
      dataTableOutput("MyTable"),
      align = "center"
      
            )
    )
)
)

