library(shiny)

function(input, output) {
  
  button1 = eventReactive(input$action,{input$state})
  #button2 = eventReactive(input$action,{input$Style})

  output$MyTitle = renderText({
    paste(button1(), " Brewery Cities by\nCity Population & Total Number of Ratings")
    })
  
  output$MyPlot = renderPlot({
    
    cities = US_cities %>%         #Filter to get only select state cities from cities list
      filter(province == button1())
    
    Breweries = US_Breweries %>%   #FIlter to get only select state breweries
      filter(state == button1())
    
    Breweries = merge(Breweries, cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City 
    
    Brews = US_Beer_Data %>%       #Filter to get only selected state beers
      filter(state == button1())
    
    Brews = merge(Brews, cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City 
    
    ###################################################################
    
    ####################### Get data and create a base map outline for CA ##############
    Map = map_data("state", region = button1()) # gets base map data for the CA outline polygon
    
    base_map = ggplot(Map, aes(x = long, y = lat)) + # saves the plot of CA outline into a variable base_CA
      geom_polygon(fill ="white" ,color = "black")
    
    
    #### Creates a data frame with summarized data based on cities ###########
    
    Brew_Cities = group_by(Breweries, city, state, brewery_name) # aggregates data into city to plot city statistics
    
    Brew_Cities = summarize(Brew_Cities,count = n(), Avg_Rate = mean(Avg_Rate, na.rm = T), Tot_Ratings = sum(Tot_Ratings,na.rm = T),
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
}




