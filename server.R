
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

function(input, output) {
  US_cities = isolate(read.csv("../DSO_545_Beer_Project/Data/US_cities.csv"))
  US_Breweries <- isolate(read.csv("../DSO_545_Beer_Project/Data/US_Beer_List_5_8_17.csv"))

  state_button <- eventReactive(input$button_state, {input$state})
  style_button = eventReactive(input$button_state,{input$Style})
  city_button = eventReactive(input$button_state,{input$city})
  
  observeEvent(input$button_state,{
    output$state_title_1 <- renderText(paste(state_button(), " Brewery Cities by\nCity Population & Total Number of Ratings"))
  })

  output$MyTitle = renderText({
    paste(" Top Beers in", style_button())
  })
  
  ## Render Table of Beer based on city, ABV, number of ratings
  
  output$beer_table_1 = renderDataTable({
    
    Brews = US_Breweries %>%       
      filter(city == city_button(), ABV >= input$range[1], ABV <= input$range[2], Numb.Ratings >= input$minNum)
    
    Brews = select(Brews,Beer,Style, ABV, Adj.Rating, brewery_name, state)
    
    Brews #prints table
    
  })  
  
  ## State Map Function
  
  observeEvent(input$button_state,
               output$state_plot <- renderPlot({
                 ###################################################################
                 
                 cities = US_cities %>%         #Filter to get only select state cities from cities list
                   filter(province == state_button())
                 
                 Breweries = US_Breweries %>%   #FIlter to get only select state breweries
                   filter(state == state_button())
                 
                 Breweries = merge(Breweries, cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City 
                 
                 Brews = US_Breweries %>%       #Filter to get only selected state beers
                   filter(state == state_button())
                 
                 Brews = merge(Brews, cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City 
                 
                 ###################################################################
                 
                 ####################### Get data and create a base map outline for CA ##############
                 
                 Map = map_data("state", region = state_button()) # gets base map data for the CA outline polygon
                 
                 base_map = ggplot(Map, aes(x = long, y = lat)) + # saves the plot of CA outline into a variable base_CA
                   geom_polygon(fill ="white" ,color = "black")
    
    
    #### Creates a data frame with summarized data based on cities ###########
    
    Brew_Cities = group_by(Breweries, city, state, brewery_name) # aggregates data into city to plot city statistics
    
    Brew_Cities = summarize(Brew_Cities,count = n(), Avg_Rate = mean(Avg.Rating, na.rm = T), Tot_Ratings = sum(Numb.Ratings,na.rm = T),
                            long = mean(long), lat = mean(lat), pop = mean(pop))
    
    ####plots the cities in whch there is a brewery. Color shows total qunatity of ratings and size shows total population of tehgeom_text(aes(label=Name),hjust=0, vjust=0)
    
    base_map +
      geom_point(data = Brew_Cities, aes(x = long, y = lat, size = Tot_Ratings,color = pop)) +
      geom_text(data = Brew_Cities, aes(label = city, vjust = -1.5)) +
      theme_classic() +
      scale_color_gradient(low="lightblue", high= "darkred") +
      ggtitle("") +
      xlab("") +
      ylab("") +
      scale_y_continuous(breaks=NULL) +
      scale_x_continuous(breaks=NULL) +
      theme(plot.title = element_text(hjust = 0.5)) 
    
  })
  )
  
  # Create a new reactive expression for color that triggers when our actionButton is pressed
  color = eventReactive(input$go, {input$color})
  
  # Create a new reactive expression for cause of death that triggers when our actionButton is pressed
  cause = eventReactive(input$go, {input$density})
  
  # Build Map of USA

  
  # Render plot with our eventReactive expressions substituted for the ui's reactive expressions
  output$plot1 <- renderPlot({
    map_USA = isolate(map_data('state'))
    
    US_Breweries = US_Breweries %>%
      mutate(region = tolower(state))
    
    # Plot brewery count map
    ggplot() +
      geom_map(data = map_USA, map = map_USA, aes(x=long, y=lat, map_id = region), fill = 'black', color = '#ffffff', size = 0.5) +
      geom_map(data =
                 if(cause() != "All"){
                   filter(US_Breweries, Style == cause()) %>%
                     count(region)
                 } else {
                   count(US_Breweries, region)
                 }, map = map_USA, aes(fill = n, map_id = region), color = 'black', size = 0.15) +
      scale_fill_continuous("# of Breweries\n", low = "white", high = color(), guide = 'colorbar', na.value="grey") +
      labs(x=NULL, y=NULL) +
      coord_map("mercator") +
      theme(panel.border = element_blank(), panel.background = element_blank(), 
            axis.ticks = element_blank(), axis.text = element_blank())
    
  })

  beer_state_button <- eventReactive(input$button_dist, {input$beer_state})  
  observeEvent(input$button_dist, {
    output$beer_count_dist = renderPlot({
      
      input$button_dist
        US_Breweries %>%
          filter(state == beer_state_button()) %>%
          arrange(desc(Numb.Ratings)) %>%
          slice(1:20) %>%
          ggplot(aes(x = reorder(Beer, -Numb.Ratings), y = Numb.Ratings, fill = Adj.Rating)) +
          geom_bar(stat = "identity", color = "black") +
          scale_fill_gradient(low = "red", high = "green") +
          ggtitle("Top 20 Most Rated Beers") +
          xlab("Beer Type") +
          ylab("Number of Ratings") +
          theme(plot.title = element_text(hjust = 0.5),
                axis.text.x=element_text(angle=45,hjust=0.5,vjust=0.5))
    })
    
    observeEvent(input$button_dist, {
      
      output$beer_rate_text = renderText({ 
        paste("Top Beers in", beer_state_button())
      })
      
      output$beer_rate_dist <- renderPlot({
        
        input$button_dist
        US_Breweries %>%
          filter(state == beer_state_button()) %>%
          arrange(desc(Adj.Rating)) %>%
          slice(1:20) %>%
          ggplot(aes(x = reorder(Beer, Adj.Rating), y = Adj.Rating, color = Style)) +
          geom_point(stat = "identity", size = 2) +
          coord_flip() +
          xlab("Beer") +
          ylab("Avg. Rating") + 
          labs(color= "Style")
      })
    })
  })

}
