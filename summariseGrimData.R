# 
# Load and Summarise the Australian General Record of Incidence of Mortality
# (GRIM) data.
#
# Write out the summarised data for use in in the Shiny App to plot the data.
#
# There are nearly 300,000 records in the raw data set compared to nearly
# 10,000 in the summarised data set.
#
library(dplyr)
#
# Load the GRIM Data
#
fileUrl <- url("http://data.gov.au/dataset/488ef6d4-c763-4b24-b8fb-9c15b67ece19/resource/edcbc14c-ba7c-44ae-9d4f-2622ad3fafe0/download/grimdatagovau.csv")
deaths <- read.csv(fileUrl, stringsAsFactors = FALSE)
#
# Remove the data in brackets in the cause of death field.  This data makes the
# data in this field quite long as does not provide any additional info to
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
# The data is filtered by age group to select the total deaths for the year, 
# cause of death and gender.  Also clean up the variable names.
#
deathTotals <- filter(deaths, AGE_GROUP == "Total") %>%
    na.omit() %>%
    rename(year = YEAR, causeOfDeath = cause_of_death, sex = SEX)  %>%
    select(year, causeOfDeath, sex, deaths) 
#
# The combined total for males and females is called persons.  Change this to
# total.
#
deathTotals$sex <- ifelse(deathTotals$sex == "Persons", "Total", deathTotals$sex)
# head(deathTotals)
#   YEAR      cause_of_death     SEX deaths
# 1 1907 All causes combined   Males  25939
# 2 1907 All causes combined Females  19366
# 3 1907 All causes combined   Total  45305
# 4 1908 All causes combined   Males  26632
# 5 1908 All causes combined Females  19794
# 6 1908 All causes combined   Total  46426
#
# Write out the summary data
#
write.csv(x=deathTotals, file = "./deathTotals.csv", row.names = FALSE)
