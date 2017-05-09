library(shiny)

function(input, output) {
  
  button1 = eventReactive(input$action,{input$state})
  button2 = eventReactive(input$action,{input$Style})

  output$MyTitle = renderText({
    paste("US Beers by ABV % - ", button2())
    })
  
  output$MyPlot = renderPlot({
    
    x = filter(US_Beer_Data, Style == button2(), state == button1())
  
    ggplot(x, aes(x = ABVbin, fill = rateBin)) +
      geom_bar() +
      xlab("ABV %") +
      ylab("Count") +
      ggtitle("") +
      scale_fill_discrete(name = "Avg Beer Rating") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme(plot.title = element_text(hjust = 0.5))
      
})
}
