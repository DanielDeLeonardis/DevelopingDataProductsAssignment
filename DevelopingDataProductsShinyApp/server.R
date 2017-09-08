library(shiny)
library(dplyr)
library(plotly)
options(warn = -1)
#
# Load a subset of the Australian General Record of Incidence of Mortality
# (GRIM) Data
#
fileUrl <- url("https://raw.github.com/DanielDeLeonardis/DevelopingDataProductsAssignment/gh-pages/deathTotals.csv")
deathTotals <- read.csv(fileUrl, stringsAsFactors = FALSE)
#
# Get a unique list sorted in alphabetical order of the cause of death. This is
# used in the drop down list to select a plot
#
deathCauses <- sort(distinct(deathTotals, causeOfDeath)[, 1])
#
# Filter the data by the cause of death.  This is the data used in the plot.
#
filterByDeathCause <- function(df, deathCause) {
    dplyr::filter(df, causeOfDeath %in% deathCause) %>%
        select(year, sex, deaths)
}
#
# If the plot contains both males and females, show a plot by male, female and
# the total.
# 
# Some causes of death may not have any data before a certain year, hence the
# getting the minimum year.
#
plotterBySex <- function(year, deaths, sex) {
    lTitle = paste("Australian Deaths", min(year), "to", max(year))
    plot_ly(x = year,
            y = deaths,
            color = sex,
            type = "scatter",
            mode = "lines+markers") %>%
        layout(title = lTitle,
               xaxis = list(title = "Year"),
               yaxis = list(title = "Deaths"))
}
#
# If a cuase of death only contains one sex, the total line is ommitted e.g.
# Prostate cancer contains males only.
#
plotter <- function(year, deaths, sex) {
    lTitle = paste("Australian Deaths", min(year), "to", max(year), "-", sex, "only")
    plot_ly(x = year,
            y = deaths,
            type = "scatter",
            mode = "lines+markers") %>%
        layout(title = lTitle,
               xaxis = list(title = "Year"),
               yaxis = list(title = "Deaths"))
}

shinyServer(function(input, output) {
    #
    # create the drop doun list used in the ui
    #
    output$deathCauseSelector <-renderUI({
        selectInput("deathCause", "Cause Of Death:", as.list(deathCauses), width = "100%")
    })
    
    output$plot <- renderPlotly({
        #
        # Filter the data by the selected cause of death
        #     
        deathsByCause <- filterByDeathCause(df=deathTotals, deathCause=input$deathCause)
        #
        # Determine which plot to execute based on if both or only one sex appear
        # in the filtered data. If there is only one sex remove the total data
        # from the data.
        #
        deathSex <- distinct(deathsByCause, sex)[, 1]
        if (length(deathSex) == 3) {
            plotterBySex(year = deathsByCause$year,
                         deaths = deathsByCause$deaths,
                         sex = deathsByCause$sex)
        } else {
            deathsByCause <- filter(deathsByCause, sex != "Total")
            plotter(year = deathsByCause$year,
                    deaths = deathsByCause$deaths,
                    sex = deathsByCause$sex[1])
        }
    })
    
})
