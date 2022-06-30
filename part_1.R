# Install and load the packages we need!
# install.packages("tidyverse")
# install.packages("nimue")
# install.packages("purrr")
# install.packages("furrr")

library(tidyverse)
library(purrr)
library(nimue)
library(furrr)

##########################################################################
# in the "Help" window, open the nimue package, and the function "run" to see the options

# What are the parameters that are set by the user? What are the defaults?

##########################################################################
# First we are going to do some example runs of the base model


#########################################################################
# Run the model with an example population and no vaccination
no_vaccine <- nimue::run(country = "United Kingdom",
                         max_vaccine = 0,
                         R0 = 2)

# What raw output does this produce?

#########################################################################
# Format the output selecting infection and deaths
out1 <-
  format(no_vaccine,
         compartments = NULL,
         summaries = c("infections", "deaths")) %>%
  mutate(Name = "No vaccine")

# Now examine the outputs


# Plot outputs
ggplot(data = out1, aes(x = t, y = value, group = Name, col = Name)) +
  geom_line(size = 1) +
  facet_wrap(~ compartment, scales = "free_y", ncol = 2) +
  xlim(0, 200) +
  xlab("Time") + 
  theme_bw()

#########################################################################
# Run the model with an example population and infection-blocking vaccine
infection_blocking <- nimue::run(
  country = "United Kingdom",
  R0 = 2.5,
  max_vaccine = 100000,
  vaccine_efficacy_disease = rep(0, 17),
  vaccine_efficacy_infection = rep(0.9, 17)
)

# Format the output selecting infection and deaths
out2 <-
  format(
    infection_blocking,
    compartments = NULL,
    summaries = c("infections", "deaths")
  ) %>%
  mutate(Name = "Infection blocking")

# Create plot data.frame (this function bind_rows basically stitches together your outputs from different runs. You can include additional runs here and stitch them together)
pd <- bind_rows(out1, out2)

# Plot outputs
ggplot(pd, aes(x = t, y = value, group = Name, col = Name)) +
  geom_line(size = 1) +
  facet_wrap(~ compartment, scales = "free_y", ncol = 2) +
  xlim(0, 200) +
  xlab("Time") + 
  theme_bw()

#########################################################################
# Exercise to work through together

# What happens if you try varying the following?
# - vary dose availability
# - vary R0
# - vary vaccine efficacy
# - set to a different country

