# some basics in R - we will work through these together and discuss

###################################################################
# first some basic objects and operations

# assignment
x <- 1

# create a vector
y <- 1:10
class(y)

a <- "hello world"
class(a)

z <- x + y

length(z)

c(z, 1, 2, 3)

seq(1, 100, by = 1)

# getting help on a function:
?rnorm

# drawing from a distribution
rnorm(20)
hist(rnorm(50))
hist(runif(50))

# a data.frame is a table where each column can have a different type
my_data_frame <- data.frame(row = 1:2,
                country = c("AUS", "GBR"),
                population_mill = c(25, 67),
                health_system = c("Medicare", "NHS"),
                southern_hemisphere = c(TRUE, FALSE)
                )

############################################################################
# one of the suites of packages useful for data analysis in R is called the tidyverse
install.packages("tidyverse")
library(tidyverse)

# read in some data (pertussis data from WHO (https://apps.who.int/gho/data/node.main.WHS3_43?lang=en))
pertussis <- read_csv("data/pertussis_formatted.csv")

head(pertussis)
nrow(pertussis)
ncol(pertussis)
tail(pertussis)

pertussis$year
unique(pertussis$year)

unique(pertussis$Country)

# filter a particular country (or exclude a country)
filter(pertussis, Country == "Uganda")

# filter to a particular year or range of years
filter(pertussis, year == 2018)

filter(pertussis, year %in% c(2018, 2019, 2020))

# select particular columns
select(pertussis, Country)
pertussis$Country

# mutate and summarise
x <- pertussis %>%
  group_by(Country) %>%
  mutate(country_sum = sum(value, na.rm = T))
  
y <- pertussis %>%
  group_by(Country) %>%
  summarise(country_sum = sum(value, na.rm = T))

y <- pertussis
yy <- group_by(y, Country)
yyy <- summarise(yyy, country_sum = sum(value, na.rm = T))