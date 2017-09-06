#
# UI for displaying the Australian General Record of Incidence of Mortality
# (GRIM) data.
#
# The UI displays a drop down list of causes of death which the user can select
# from.
#
# A plot of the selected cause of death by gender and for the years the data is
# available.  Plotly is used to render the plot.
#

library(shiny)
library(plotly)

shinyUI(fluidPage(
    
    titlePanel("Australian General Record of Incidence of Mortality (GRIM)"),
    
    br(),
    br(),
    
    uiOutput("deathCauseSelector"),
    
    br(),
    br(),
    
    plotlyOutput("plot")
    
))
