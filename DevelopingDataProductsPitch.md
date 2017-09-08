---
title: "Developing Data Products Pitch"
author: "Daniel De Leonardis"
date: "7 September 2017"
output: ioslides_presentation
---



## Australian General Record of Incidence of Mortality (GRIM) Overview

The GRIM books house national level, historical and recent deaths data for specific causes of death. The tables present age- and sex-specific counts and rates of deaths, and age-standardised death rates, for all causes and for International Statistical Classification of Diseases and Related Health Problems.

The data goes back to 1907, but data may not be available for before a certain year for a particular cause of death. In general most causes of death apply to both sexes but there are instances where it may apply to only sex e.g. prostrate cancer for males.

A subset of this data is taken to enable to plot the number of deaths for a selected cause of death by year and sex as well as the total for all sexes.


## Subsetting the GRIM Data

The full data set contains around 300,000.  A short script was written to reduce the size of the dataset to around 10,000 records (primarily to substantially reduce the load time in the shiny app).

Some cleanup is also performed for the following:

- reduce the size of the cause of death field by removing some unnecessary data with brackets at the end of each row
- standardise the field names output to camel case.  Some are in upper case and others are seperated by undersores.
- Change person to total in the sex field for use in the plot.


```
  year        causeOfDeath     sex deaths
1 1907 All causes combined   Males  25939
2 1907 All causes combined Females  19366
3 1907 All causes combined   Total  45305
4 1908 All causes combined   Males  26632
5 1908 All causes combined Females  19794
6 1908 All causes combined   Total  46426
```

The output containing the subset of the data can be found here on GitHub:

- https://raw.github.com/DanielDeLeonardis/DevelopingDataProductsAssignment/gh-pages/deathTotals.csv

## Plotting the Data

The shiny app allows the user to select from a list of causes of death to display a particular plot. The data set is filtered by the cause of death and then Plotly is used to display the plot. An example of a plot is shown here:



```
Error in file(con, "rb") : cannot open the connection
```
