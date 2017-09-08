#
# UI for displaying the Australian General Record of Incidence of Mortality
# (GRIM) data.
#
# The UI is divided into the main plot area and an about page using a tab
# panel.
#
# The plot area displays a drop down list of causes of death which the user can
# select from. A plot is rendered for the selected cause of death by gender and
# for the years the data is available.  Plotly is used to render the plot.
#
# The about page provides some info about the data and how to use the UI.
#

library(shiny)
library(plotly)
library(markdown)

shinyUI(navbarPage(
    "",
    tabPanel("Plot",
             fluidPage(
                 
                 titlePanel("Australian General Record of Incidence of Mortality (GRIM)"),
                 
                 br(),
                 br(),
                 
                 uiOutput("deathCauseSelector"),
                 
                 br(),
                 br(),
                 
                 plotlyOutput("plot")
                 
                 
             )),
    tabPanel("About",
             includeMarkdown("about.md"))
))