library(shiny)


function(input, output) {
  
  button1 = eventReactive(input$action,{input$state})


  output$MyTitle = renderText({
    paste(" Top Beers in", button1())
    })
  
  output$MyPlot = renderPlot({
    
    cities = US_cities %>%         #Filter to get only select state cities from cities list
      filter(province == button1())


    Brews = US_Beer_Data %>%       #Filter to get only selected state beers
      filter(state == button1())

    Brews = merge(Brews, cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City
    
    
    ###################### Get data and create a base map outline for CA ##############
    
    Map = map_data("state", region = button1()) # gets base map data for the CA outline polygon
    
    base_map = ggplot(Map, aes(x = long, y = lat)) + # saves the plot of CA outline into a variable base_CA
      geom_polygon(fill ="white" ,color = "black")
    
    
    ####plots the cities in whch there is a brewery. Color shows total qunatity of ratings and size shows total population of tehgeom_text(aes(label=Name),hjust=0, vjust=0)
    
    base_map +
      geom_point(data = head(arrange(Brews,desc(Adj.Rating)), n = 5), aes(x = long, y = lat, color = brewery_name, size = 5)) +
      geom_text(data = head(arrange(Brews,desc(Adj.Rating)), n = 5), aes(label = brewery_name, vjust = -1.5)) +
      theme_classic() +
      ggtitle("") +
      xlab("") +
      ylab("") +
      scale_y_continuous(breaks=NULL) +
      scale_x_continuous(breaks=NULL) +
      theme(plot.title = element_text(hjust = 0.5)) 
      
})
  
  output$MyTable = renderDataTable({
    
    Brews = US_Beer_Data %>%       #Filter to get only selected state beers
      filter(state == button1())
    
    Brews = merge(Brews, US_cities, by.x = "city", by.y = "city") # Gets lat longs of each Brewery's City
    
    Top5List = head(arrange(Brews,desc(Adj.Rating)), n = 5) #creates list of top 10 beers

    Top5List = select(Top5List, brewery_name, Beer, city, ABV, Adj.Rating) # selects only relevent columns to print

    Top5List #prints table

  })
}



