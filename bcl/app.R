library(shiny)
library(knitr)
library(tidyverse)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
bcl_countries <- count(bcl, Country)

# Define UI for application that draws a histogram
# UI is user interface, its just HTML
#'fluid' means it will adapt to whatever screen you are using
ui <- fluidPage(
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Select your desired price range.",
                             min = 0, max = 100, value = c(0,100), pre="$"),
                 checkboxGroupInput("typeInput", "Select your desired alocohol type.", 
                               choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                               selected = c("BEER", "REFRESHMENT", "SPIRITS", "WINE")),
                 checkboxInput("countryOption", "Would you like to filter by country?"),
                 conditionalPanel(condition = 'input$countryOption == TRUE', 
                                  selectInput("countryInput", "Select your desired country.", 
                                              choices = c(bcl_countries$Country),
                                              selected = "CANADA"))
                 ),
    mainPanel(
      plotOutput("price_hist"),
      tableOutput("bcl_data"))
    )
  )


# Define server logic required to draw objects
# Output is a list that we have to build
server <- function(input, output) {
  output$price_hist <- renderPlot({
    #The histogram
    bcl %>% 
      filter(Price < input$priceInput[2], 
             Price > input$priceInput[1], 
             Type == input$typeInput,
             Country == input$countryInput) %>% 
      ggplot(aes(Price, color = Type, fill = Type)) +
      geom_histogram()
    })
  output$bcl_data <- renderTable({
    #The table
    bcl %>% 
      filter(Price < input$priceInput[2], 
             Price > input$priceInput[1], 
             Type == input$typeInput)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

