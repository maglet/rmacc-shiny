# Read in the data

gapminder <- read.csv("https://bit.ly/2tRz8r3")

#load ggplot2
library(ggplot2)
library(dplyr)

subgap<-gapminder%>%
          filter(continent %in% c("Asia", "Oceania"))%>%
          filter(year>1980)%>%
          filter(year<1995)

#create a graph
ggplot(data = subgap, 
       aes(x=year, y=lifeExp, by=country, color=continent)) +
          geom_line() + geom_point()

ggplot(data = subgap, 
       aes(x=year, y=gdpPercap, by=country, color=continent)) +
          geom_line() + geom_point()
