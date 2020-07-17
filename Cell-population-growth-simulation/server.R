#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
suppressPackageStartupMessages(library(plotly))
library(ggplot2)
library(tidyr)

accumulate_by <- function(dat, var) {
    var <- lazyeval::f_eval(var, dat)
    lvls <- plotly:::getLevels(var)
    dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
    })
    dplyr::bind_rows(dats)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data <- reactive({
        initialPop<- input$initialPop
        generations<- input$generations
        probChild<- (input$probChild)/100
        probDie<- (input$probDie)/100
        
        n<-initialPop
        Births<-1:generations
        Deaths<-1:generations
        Population<-1:generations
        
        for(i in 1:(generations-1)){
            Births[i+1]<-sum(rbinom(n, 1, probChild))
            Deaths[i+1]<-sum(rbinom(n, 1, probDie))
            n<-n+Births[i+1]-Deaths[i+1]
            Population[i+1]<-n
        }
        
        Births[1]<-0
        Deaths[1]<-0
        Population[1]<-initialPop
        Generation<-1:generations
        
        data<-data.frame(Generation, Population, Births, Deaths)
        data3<-data
        data3<-gather(data3, Type, Number, Population:Deaths,factor_key = T)
        data3<-data3 %>% accumulate_by(~Generation)
        
        data3
    })
    
    
    
    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$generations + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })
    
    output$plot <- renderPlotly({
        fig <- data() %>%
            plot_ly(
                x = ~Generation, 
                y = ~Number,
                split = ~Type,
                frame = ~frame, 
                type = 'scatter',
                mode = 'lines', 
                line = list(simplyfy = F)
            )
        # fig <- fig %>% layout(
        #     xaxis = list(
        #         title = "Generation",
        #         zeroline = F
        #     ),
        #     yaxis = list(
        #         title = "Number of individuals",
        #         zeroline = F
        #     )
        # ) 
        # fig <- fig %>% animation_opts(
        #     frame = 100, 
        #     transition = 0, 
        #     redraw = FALSE
        # )
        fig
    })
    
    
})
