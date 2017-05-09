
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)



shinyServer
  function(input, output) {
    
    beers= read.csv("master_beer_5-6-17.csv")
    
    beers = beers %>%
      mutate(Avg.Rating = as.numeric(str_extract(Avg.Rating, "[0-9]{1}[.]{0,1}[0-9]{0,4}")),
             ABV = as.numeric(str_extract(ABV, "[0-9]{1}[.]{0,1}[0-9]{0,4}")),
             Numb.Ratings = as.numeric(str_replace_all(Numb.Ratings, ",","")))
    
    beers= subset(beers, state== "Alabama" | state== "Alaska" | state== "Arizona" | 
                    state== "Arkansas" | state== "California" | state== "Colorado" | 
                    state== "Connecticut" | state== "Delaware" | state== "District of Columbia" |
                    state== "Florida" | state== "Georgia" | state== "Hawaii" | 
                    state== "Idaho" | state== "Illinois" | state== "Indiana" | state== "Iowa" | 
                    state== "Kansas" | state== "Kentucky" | state== "Louisiana" | 
                    state== "Maine" | state== "Maryland" | state== "Massachusetts" | 
                    state== "Michigan" | state== "Minnesota" | state== "Mississippi" | 
                    state== "Missouri" | state== "Montana" | state== "Nebraska" | 
                    state== "Nevada" | state== "New Hampshire" | state== "New Jersey" | 
                    state== "New Mexico" | state== "New York" | state== "North Carolina" | 
                    state== "North Dakota" | state== "Ohio" | state== "Oklahoma" | 
                    state== "Oregon" | state== "Pennsylvania" | state== "Rhode Island" | 
                    state== "South Carolina" | state== "South Dakota" | state== "Tennessee" | 
                    state== "Texas" | state== "Utah" | state== "Vermont" | state== "Virginia" | 
                    state== "Washington" | state== "West Virginia" | state== "Wisconsin" | 
                    state== "Wyoming")
    
    button1 = eventReactive(input$action, {input$state})
    
    output$beer_rate_text = renderText({ 
      paste("Top Beers in", button1())
    })
    
    output$plot1 = renderPlot({
      
      input$action
      isolate(
        beers %>% ### or whatever the dataset is called
          filter(state == input$state) %>%
          arrange(desc(Adj.Rating)) %>%
          slice(1:10) %>%
          ggplot(aes(x = reorder(Beer, Adj.Rating), y = Adj.Rating, color = Style)) +
          geom_point(stat = "identity", size = 2) +
          coord_flip() +
          xlab("Beer") +
          ylab("Avg. Rating") + 
          labs(color= "Style"))
        })
    
  }
