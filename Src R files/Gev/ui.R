library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Top Beers by Number of Ratings"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("state", label = "State ", choices = levels(factor(US_States))),
      
      actionButton("createButton", "Create Distribution")
    ),
    
    mainPanel(
      plotOutput("beer_plot")
    )
  )
))