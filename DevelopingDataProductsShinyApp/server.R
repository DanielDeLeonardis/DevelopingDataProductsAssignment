library(shiny)
library(dplyr)
library(plotly)

options(warn =-1)

# setwd("F:/Documents/Programming/R/Course Projects/09 Developing Data Products/Peer-graded Assignment Course Project Shiny Application and Reproducible Pitch")
#
# Load the GRIM Data
#
# deaths <- read.csv("./data/grimdatagovau.csv", stringsAsFactors = FALSE)

#
# Filter the data by the cause of death.  This is the data used in the plot.
#
filterByDeathCause <- function(df, deathCause) {
    dplyr::filter(df, cause_of_death %in% deathCause) %>%
        select(YEAR, SEX, deaths)
}
#
# If the plot contains both males and females, show a plot by male, female and
# the total.
# 
# Some causes of death may not have any data before a certain year, hence the
# getting the minimum year.
#
plotterBySex <- function(year, deaths, sex, deathCause) {
    lTitle = paste("Australian Deaths ", min(year), " to ", max(year), "\n", deathCause, "\n")
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
plotter <- function(year, deaths, sex, deathCause) {
    lTitle = paste("Australian Deaths ", min(year), " to ", max(year), "\n", deathCause, " (", sex, " only )", "\n")
    plot_ly(x = year,
            y = deaths,
            type = "scatter",
            mode = "lines+markers") %>%
        layout(title = lTitle,
               xaxis = list(title = "Year"),
               yaxis = list(title = "Deaths"))
}

shinyServer(function(input, output) {
    
    withProgress(message="Loading Data", value = 0, {
        fileUrl <- url("http://data.gov.au/dataset/488ef6d4-c763-4b24-b8fb-9c15b67ece19/resource/edcbc14c-ba7c-44ae-9d4f-2622ad3fafe0/download/grimdatagovau.csv")
        deaths <- read.csv(fileUrl, stringsAsFactors = FALSE)
        #
        # Remove the data in brackets.  This data makes the names quite long as does not provide any additional info to
        # clarify the cause of death.
        #
        deaths$cause_of_death <- trimws(gsub( " *\\(.*?\\) *", "", deaths$cause_of_death))
        # head(deaths)
        #       grim      cause_of_death YEAR   SEX AGE_GROUP deaths   rate age_standardised_rate
        # 1 GRIM0000 All causes combined 1907 Males       0–4   6482 2604.0                    NA
        # 2 GRIM0000 All causes combined 1907 Males       5–9    473  205.1                    NA
        # 3 GRIM0000 All causes combined 1907 Males     10–14    366  168.4                    NA
        # 4 GRIM0000 All causes combined 1907 Males     15–19    569  266.8                    NA
        # 5 GRIM0000 All causes combined 1907 Males     20–24    763  366.8                    NA
        # 6 GRIM0000 All causes combined 1907 Males     25–29    723  388.5                    NA
        #
        # The data is split by age group which is not used in these plots.  The are
        # nearly 300,000 records compared to nearly 10,000 by only including the totals.
        #
        deathTotals <- filter(deaths, AGE_GROUP == "Total") %>%
            na.omit() %>%
            select(YEAR, cause_of_death, SEX, deaths)
        rm(deaths)
        #
        # The combined total for males and females is called persons.  Change this to
        # total.
        #
        deathTotals$SEX <- ifelse(deathTotals$SEX == "Persons", "Total", deathTotals$SEX)
        # head(deathTotals)
        #   YEAR      cause_of_death     SEX deaths
        # 1 1907 All causes combined   Males  25939
        # 2 1907 All causes combined Females  19366
        # 3 1907 All causes combined   Total  45305
        # 4 1908 All causes combined   Males  26632
        # 5 1908 All causes combined Females  19794
        # 6 1908 All causes combined   Total  46426
        #
        # Get a unique list sorted in alphabetical order of the cause of death. This is
        # used in the drop down list to select a plot
        #
        deathCauses <- sort(distinct(deathTotals, cause_of_death)[, 1])
    })
    #
    # create the drop doun list used in the ui
    #
    output$deathCauseSelector <-renderUI({
        selectInput("deathCause", "Cause Of Death:", as.list(deathCauses))
    })
    
    output$plot <- renderPlotly({
        #
        # Filter the data by the selected cause of death
        #     
        deathsByCause <- filterByDeathCause(df=deathTotals, deathCause=input$deathCause)
        #
        # Determine with plot to execute based on if both or only one sex appear
        # in the filtered data. If there is only one sex remove the total data
        # from the data.
        #
        deathSex <- distinct(deathsByCause, SEX)[, 1]
        if (length(deathSex) == 3) {
            plotterBySex(year = deathsByCause$YEAR,
                         deaths = deathsByCause$deaths,
                         sex = deathsByCause$SEX,
                         deathCause = input$deathCause)
        } else {
            deathsByCause <- filter(deathsByCause, SEX != "Total")
            plotter(year = deathsByCause$YEAR,
                    deaths = deathsByCause$deaths,
                    sex = deathsByCause$SEX[1],
                    deathCause = input$deathCause)
        }
    })
    
})
