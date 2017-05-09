
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyUI(fluidPage(
  titlePanel("Top Beers by State"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("state", 
                  label = "Choose a State:",
                  choices = levels(factor(beers$state))),

      
      actionButton("action", 
                   label = "Find Beers")
      ),
    
    mainPanel(textOutput("text1"), 
              plotOutput("plot1"), 
              align= "center")
))
)




