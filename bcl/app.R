library(shiny)
library(knitr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
# UI is user interface, its just HTML
#'fluid' means it will adapt to whatever screen you are using
ui <- fluidPage(
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Select your desired price range.",
                             min = 0, max = 100, value = c(15, 30), pre="$")),
    mainPanel(
      plotOutput("price_hist"),
      tableOutput("price_table")
    )
  )
)

# Define server logic required to draw objects
# Output is a list that we have to build
server <- function(input, output) {
  output$price_hist <- renderPlot(ggplot2::qplot(bcl$Price))
  output$price_table <- renderTable(table(bcl$Price, bcl$Type))
}

# Run the application 
shinyApp(ui = ui, server = server)

