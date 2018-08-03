############### Code outside of ui/server will only be run once ################

#load libraries
library(shiny)
library(ggplot2)
library(dplyr)

#load the dataset
gapminder <- read.csv("https://bit.ly/2tRz8r3")

################################################################################

###################### Define the user interface ###############################

ui<-fluidPage(
          titlePanel(img(src = "logo.png")), #Page title
          
          sidebarLayout(                #creates the 2 panel layout
                    sidebarPanel(       #content of the sidebar (inputs)
                              h3("Subset the data"),
                              p("Select which years and continents you'd like to view data from",
                                style = "font-family: 'times'; font-si16pt"),
                              
                              sliderInput("years",    
                                             label= "years", 
                                             min = min(gapminder$year), 
                                             max = max(gapminder$year), 
                                             value = c(min(gapminder$year),max(gapminder$year)),
                                             sep =""),
                                 
                                 checkboxGroupInput("Continents",
                                               label = "Continents",
                                               choices = levels(gapminder$continent),
                                               selected = levels(gapminder$continent)
                                               )
                                 ),
                                
                    mainPanel( 
                              strong("Select a graph"),
                              em("View life expectancy or gdp per capita over time by selecting a tab"),
                              tabsetPanel(
                                        
                                        tabPanel("Life expectancy", 
                                                 plotOutput("lifeexpPlot")),
                                        tabPanel("GDP per capita", 
                                                 plotOutput("gdpPlot"))
                                        )
          )
))
################################################################################

##################### server: builds the plot(s) ###############################
server <- function(input, output) {
          output$lifeexpPlot<-renderPlot({
                    
                    subgap<-gapminder %>%
                              filter(continent %in% input$Continents)%>%
                              filter(year>input$years[1])%>%
                              filter(year<input$years[2])
                    
                    #create a graph
                    ggplot(data = subgap,
                           aes(x=year, y=lifeExp, by=country, color=continent)) +
                              geom_line() + geom_point()
          })
          
          output$gdpPlot<-renderPlot({
                    
                    subgap<-gapminder%>%
                              filter(continent %in% input$Continents)%>%
                              filter(year>input$years[1])%>%
                              filter(year<input$years[2])
                    
                    
                    #create a graph
                    ggplot(data = subgap, 
                           aes(x=year, y=gdpPercap, by=country, color=continent)) +
                              geom_line() + geom_point()
          })
          
          }
################################################################################

############################ Also outside server/ui, run once ##################
# Run the app ----
shinyApp(ui = ui, server = server)
################################################################################