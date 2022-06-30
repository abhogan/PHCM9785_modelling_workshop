# some basics in R

# first some basic objects and operations
x <- 1

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
                population = c(25, 67),
                health_system = c("Medicare", "NHS"),
                southern_hemisphere = c(TRUE, FALSE)
                )

############################################################################
# one of the suites of packages useful for data analysis in R is called the tidyverse
install.packages('tidyverse')
library(tidyverse)

# read in some data (pertussis data from WHO (https://apps.who.int/gho/data/node.main.WHS3_43?lang=en))
pertussis <- read_csv("data/pertussis.csv")

head(pertussis)
nrow()
head()

df <- pertussis %>%
  pivot_longer(cols = '2020':'1974') %>%
  mutate(year = as.numeric(name)) %>%
  select(Country, year, value)

# filter a particular country (or exclude a country)

# filter to a particular year or range of years

# 
