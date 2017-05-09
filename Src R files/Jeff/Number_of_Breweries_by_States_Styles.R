data = read.csv("../DSO_545_Beer_Project/Data/master_beer_5-6-17.csv")


library(dplyr)
library(ggplot2)
library(stringr)
library(maps)
library(shiny)

# Declare US States
US_States = c('Alaska','Alabama','Arkansas','Arizona','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Iowa','Idaho','Illinois','Indiana','Kansas','Kentucky','Louisiana','Massachusetts','Maryland','Maine','Michigan','Minnesota','Missouri','Mississippi','Montana','North Carolina','North Dakota','Nebraska','New Hampshire','New Jersey','New Mexico','Nevada','New York','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Virginia','Vermont','Washington','Wisconsin','West Virginia','Wyoming')

# Filter to US_Beer_Data
US_Beer_Data = data %>%
  filter(data$state %in% US_States)

# Factor the states
US_Beer_Data$state = factor(US_Beer_Data$state)

# Create region column as lowercase states
US_Beer_Data = US_Beer_Data %>%
  mutate(region = tolower(state))

# Get map data
map_USA = map_data('state')


### SHINY

# Create the ui
ui <- fluidPage(
  headerPanel('Number of Breweries by State: Brewing Which Styles of Beer'),
  sidebarPanel(
    selectInput('density', 'Style of Beer', c("All", levels(US_Beer_Data$Style))),
    textInput('color', 'Distribution Fill Color', 'darkred'),
    actionButton('go', 'Create Distribution')
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

# Create the server to serve the ui
server <- function(input, output) {
  # Create a new reactive expression for color that triggers when our actionButton is pressed
  color = eventReactive(input$go, {input$color})
  
  # Create a new reactive expression for cause of death that triggers when our actionButton is pressed
  cause = eventReactive(input$go, {input$density})
  
  # Render plot with our eventReactive expressions substituted for the ui's reactive expressions
  output$plot1 <- renderPlot(
    # Plot brewery count map
    ggplot() +
      geom_map(data = map_USA, map = map_USA, aes(x=long, y=lat, map_id = region), fill = 'black', color = '#ffffff', size = 0.5) +
      geom_map(data =
                 if(cause() != "All"){
                   filter(US_Beer_Data, Style == cause()) %>%
                            count(region)
                 } else {
                   count(US_Beer_Data, region)
                 }, map = map_USA, aes(fill = n, map_id = region), color = 'black', size = 0.15) +
      scale_fill_continuous("# of Breweries\n", low = "white", high = color(), guide = 'colorbar') +
      labs(x=NULL, y=NULL) +
      coord_map("mercator") +
      theme(panel.border = element_blank(), panel.background = element_blank(), 
            axis.ticks = element_blank(), axis.text = element_blank())
    
  )
  
}

# Instantiate shinyApp
shinyApp(ui = ui, server = server)