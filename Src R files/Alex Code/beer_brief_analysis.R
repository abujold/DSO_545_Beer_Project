library(dplyr)
library(ggplot2)
library(stringr)
library(rvest)
library(foreach)
library(doParallel)
library(ggmap)

# df_beer_data <- read.csv(file = "../BA_Data/master_beer_1.csv") OLD Code
df_beer_data <- read.csv(file = "../BA_Data/master_beer_5-6-17.csv")

## Explore the Data

## Change ratings into numeric
## Factor into numeric
df_beer_data <- df_beer_data %>%
  mutate(Avg.Rating = as.numeric(str_extract(Avg.Rating, "[0-9]{1}[.]{0,1}[0-9]{0,4}"))) %>%
  mutate(ABV = as.numeric(str_extract(ABV, "[0-9]{1}[.]{0,1}[0-9]{0,4}"))) %>%
  mutate(Numb.Ratings = as.numeric(str_replace(Numb.Ratings, "[,]", "")))

write.csv(df_beer_data, "../BA_Data/master_beer_5-6-17.csv")

## Point plot of rating by number
df_beer_data %>%
  group_by(Style) %>%
  summarise(avg_rate = mean(na.omit(Avg.Rating)),
            style_count = n(),
            avg_ABV = mean(na.omit(ABV))) %>%
  arrange(desc(style_count)) %>%
  ggplot(aes(y = avg_rate, x = style_count, color = avg_ABV)) +
  geom_point() +
  scale_color_continuous(low = "white", high = "blue") +
  ylab("Average Rating") +
  xlab("Number of Beers") +
  ggtitle("Average rating of beers by number of beers")

## Highest Reviewed Brewery, testing scoring data

test <- df_beer_data %>%
  filter(Numb.Ratings > 0) %>%
  mutate(score = ((5*Avg.Rating)/10) + 5*(1 - '^'(exp(1), (-Numb.Ratings/20)))) %>%
  group_by(city, state) %>%
  summarise(avg_score = mean(na.omit(score))) %>%
  arrange(desc(avg_score)) %>%
  top_n(n = 20, wt = avg_score)
  

## Highest Rated Beer by Type
df_beer_data %>%
  filter(Numb.Ratings >= 20) %>%
  filter(State = "California")
  filter(Style %in% c("Gose", "American Amber / Red Ale", "Russian Imperial Stout", "American IPA")) %>%
  top_n(n = 200, wt = Adj.Rating) %>%
  ggplot(aes(x = Adj.Rating, y = ABV, color = Style)) +
  geom_point() +
  geom_smooth(method = "lm")

df_top_2000_breweries <- as.data.frame(head(df_scored_breweries, 2000))

  
test <- cbind(df_top_2000_breweries, geocode(paste(df_top_2000_breweries$brewery_name, df_top_2000_breweries$city, df_top_2000_breweries$state), output = "more"))


# ### Pulling Breweries, Doesn't need to be run anymore
# 
# df_breweries <- data.frame(brewery_link = as.character(unique(df_beer_data$Brewery.Link)))
# df_breweries$brewery_link <- paste("https://www.beeradvocate.com", df_breweries$brewery_link, sep = "")
# 
# # Pulling Brewery State and City
# setup parallel backend to use 8 processors
# cl<-makeCluster(8)
# registerDoParallel(cl)
# 
# # Pull all Cities from Brewery locations and merge data
# df_breweries$city <- foreach(i = 1:nrow(df_breweries), .combine=rbind) %dopar% {
#  library(rvest)
#  test[[i]] <- xml_text(xml_nodes(read_html(df_breweries$brewery_link[[i]]), xpath = '//*[@id="ba-content"]/div[3]/div[2]/a[1]'))
# }
# 
# # Pull all States from Brewery locations and merge data
# df_breweries$state <- foreach(i = 1:nrow(df_breweries), .combine=rbind) %dopar% {
#  library(rvest)
#  test[[i]] <- xml_text(xml_nodes(read_html(df_breweries$brewery_link[[i]]), xpath = '//*[@id="ba-content"]/div[3]/div[2]/a[2]'))
# }
# 
# df_breweries$brewery_name <- foreach(i = 1:nrow(df_breweries), .combine=rbind) %dopar% {
#  library(rvest)
#  test[[i]] <- xml_text(xml_nodes(read_html(df_breweries$brewery_link[[i]]), xpath = '//*[@id="content"]/div/div/div[3]/div/div/div[1]/h1'))
# }
# 
# # Merge City and State data from Breweries onto Beer Data
# df_beer_data$brewery_link <- paste("https://www.beeradvocate.com", df_beer_data$Brewery.Link, sep = "")
# df_beer_data_test <- left_join(df_beer_data, df_breweries, by.x = 'brewery_link', by.y = 'brewery_link')
# 
# df_beer_data_test$url <- NULL
# df_beer_data_test$Brewery_Link <- NULL
# write.csv(df_beer_data_test, "../BA_Data/beeradvocate_breweries_and_beer.csv")
# 
# ###
