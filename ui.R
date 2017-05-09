
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
state_data <- unique(read.csv("../DSO_545_Beer_Project/Data/US_cities.csv"))$province
city_data <- read.csv("../DSO_545_Beer_Project/Data/beer_city_data.csv", as.is = T)
style_data <- as.list(read.csv("../DSO_545_Beer_Project/Data/beer_styles_data.csv", as.is = T))

ui = fluidPage(
  tabsetPanel(
    tabPanel("Beer By State, Options",
      sidebarLayout(
        sidebarPanel(
          titlePanel("Select State to Plot Its Breweries"),
          selectInput("state",
                      label = "",
                      choices = levels(state_data),
                      selected = "California"),
          titlePanel("Filter Options for Data Table"),
          selectInput("city",
                      label = "City",
                      choices = city_data,
                      selected = "Los Angeles"),
          
          sliderInput("minNum", "Minimum # of ratings:",
                      min=0, max=20000, value=500),
          
          # Specification of ABV range within an interval
          sliderInput("range", "ABV % Range:",
                      min = 0, max = 57, value = c(4,10)),
          actionButton(inputId = "button_state", label = "Update Chart")
          ),
        mainPanel(
          fluidRow(verbatimTextOutput("state_title_1")),
          fluidRow(plotOutput("state_plot"),
                   align = "center"),
          fluidRow(textOutput("MyTitle"),
                   dataTableOutput("beer_table_1"),
                   align = "center")
                    )
        )
      ),
    tabPanel("Style Density Map, USA",
      headerPanel('Number of Breweries by State: Brewing Which Styles of Beer'),
      sidebarPanel(
        selectInput('density', 'Style of Beer', c("All", style_data)),
        textInput('color', 'Distribution Fill Color', 'darkred'),
        actionButton(inputId = 'go', 'Create Distribution')
      ),
      mainPanel(
        plotOutput('plot1')
      )
    ),
    
    tabPanel("Beers, Overall",
             headerPanel("Top Beers by Number of Ratings"),
             sidebarPanel(
               selectInput("beer_state", label = "State ", choices = levels(state_data)),
               actionButton(inputId = "button_dist", "Create Distribution")
             ),
             mainPanel(
               fluidRow(plotOutput("beer_count_dist")),
               fluidRow(textOutput("beer_rate_text"),
                        plotOutput("beer_rate_dist"))
             )
    )
    )
)
