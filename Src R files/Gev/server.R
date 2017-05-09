library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)

shinyServer(function(input, output) {
  
  data = read.csv("master_beer_5-6-17.csv")
  data = data %>%
    mutate(Avg.Rating = as.numeric(str_extract(Avg.Rating, "[0-9]{1}[.]{0,1}[0-9]{0,4}")),
           ABV = as.numeric(str_extract(ABV, "[0-9]{1}[.]{0,1}[0-9]{0,4}")),
           Numb.Ratings = as.numeric(str_replace_all(Numb.Ratings, ",","")))
  
  US_States = c('Alaska','Alabama','Arkansas','Arizona','California','Colorado','Connecticut',
                'Delaware', 'District of Columbia','Florida','Georgia','Hawaii','Iowa','Idaho',
                'Illinois','Indiana','Kansas','Kentucky','Louisiana','Massachusetts','Maryland',
                'Maine','Michigan','Minnesota','Missouri','Mississippi','Montana','North Carolina',
                'North Dakota','Nebraska','New Hampshire','New Jersey','New Mexico','Nevada','New York',
                'Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota',
                'Tennessee','Texas','Utah','Virginia','Vermont','Washington','Wisconsin','West Virginia','Wyoming')
  
  observeEvent(input$createButton, {
    output$beer_plot <- renderPlot({
      
      input$createButton
      isolate(
        data %>%
          filter(state == input$state) %>%
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
      )
    })
  })
})