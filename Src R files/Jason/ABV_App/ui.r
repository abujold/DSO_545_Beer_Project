

library(shiny)


# ui.R

shinyUI(fluidPage(
  titlePanel("US Beer by ABV %"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("Style",
                  label = "Beer Style",
                  choices = levels(US_Beer_Data$Style),
                  selected = "American IPA"),
      
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
      align = "center"
      
            )
    )
)
)

