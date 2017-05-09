library(shiny)


function(input, output) {
  
  button1 = eventReactive(input$action,{input$state})
  button2 = eventReactive(input$action,{input$Style})
  button3 = eventReactive(input$action,{input$city})


  output$MyTitle = renderText({
    paste(" Top Beers in", button2())
    })
  
  output$MyTable = renderDataTable({
    
    Brews = US_Beer_Data %>%       
      filter(city == button3(), ABV >= input$range[1], ABV <= input$range[2], Numb.Ratings >= input$minNum)
    
   Brews = select(Brews,Beer,Style, ABV, Adj.Rating, brewery_name, state)
    
    Brews #prints table

  })
}



