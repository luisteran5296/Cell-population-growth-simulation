#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
suppressPackageStartupMessages(library(plotly))
library(ggplot2)
library(tidyr)


# Define UI for application that draws a histogram
shinyUI( fluidPage(
    
    # Application title
    titlePanel(
        h1("Cell population growth simulation", align = "center")
    ),
    br(),
    br(),
    br(),
    # Sidebar with a slider input for number of bins
    
    
    fluidRow(
        column(3,
               br(),
               p("This is a cell popullation simulator. The main idea is to 
                 study population growth given a reproduction and mortality 
                 probability.", align = "justify"),
               p("There's an initial set of individual cells for the simulation 
                 (Initial Population). For every generation, each cell has a 
                 fixed probability to reproduce a new individual cell (Reproduction 
                 probability %). But also, has a fixed probablity of dying (Mortality
                 probability %).", align = "justify"),
               p("The reproduction probability is evaluated first, so a cell can 
                 reproduce and die in the same.", align = "justify"),
               p("The plot shows the evolutiobn through generation:"),
               p("- Population (Green Line): Total number of cells"),
               p("- Births (Blue Line): Number of births for every generation"),
               p("- Deaths (Births Line): Number of deaths for every generation"),
        ),
        column(6, plotlyOutput("plot")),
        column(3,
               numericInput("initialPop", "Initial population:", value=100,
                            min=1, max=10000, step = 1),
               sliderInput("generations",
                           "Number of generations:",
                           min = 1,
                           max = 20,
                           value = 10),
               sliderInput("probChild",
                           "Reproduction probability (%):",
                           min = 1,
                           max = 100,
                           value = 63),
               sliderInput("probDie",
                           "Mortality probability (%):",
                           min = 1,
                           max = 100,
                           value = 56),
               submitButton("Submit"),
               style="overflow-x: scroll; overflow-y: scroll"),
        
    )
))  

