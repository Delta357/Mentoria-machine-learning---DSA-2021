library(shiny)
library(dplyr)

ui <- pageWithSidebar(
  headerPanel('Agrupamento por k-means'),
  sidebarPanel(
    selectInput('xcol', 'Vari�vel X', names(palmerpenguins::penguins[3:6])),
    selectInput('ycol', 'Vari�vel Y', names(palmerpenguins::penguins[3:6]),
                selected = names(palmerpenguins::penguins[4])),
    numericInput('clusters', 'N�mero de grupos', 2,
                 min = 1, max = 5)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

server <- function(input, output, session) {
  
  dados <- reactive({
    palmerpenguins::penguins %>% 
      select(input$xcol, input$ycol) %>% 
      na.omit()
  })
  
  clusters <- reactive({
    kmeans(dados(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(dados(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
}


# shinyApp ----------------------------------------------------------------
shinyApp(ui, server)
