
####################################################################################
# what about comparing impact in different income settings?

# Load the functions script
source("R/functions.R")

# set some parameters
R0 <- 2.5
Rt1 <- 0.9
Rt2 <- 3
reduction1 <- 1-Rt1/R0
reduction2 <- 1-Rt2/R0
timing1 <- 50
timing2 <- 350
income_group <- c("HIC", "UMIC", "LMIC", "LIC")
duration_R <- 365
coverage <- c(0.8, 0)
vaccine_coverage_mat <- "Elderly"
vaccine_period <- 30
vaccine_start <- 365

# set up a dataframe of scenarios
scenarios <- expand_grid(R0 = R0,
                         reduction1 = reduction1,
                         reduction2 = reduction2,
                         coverage = coverage,
                         income_group = income_group,
                         duration_R = duration_R,
                         vaccine_period = vaccine_period,
                         vaccine_start = vaccine_start,
                         vaccine_coverage_mat = vaccine_coverage_mat,
                         timing1 = timing1,
                         timing2 = timing2)
# run the model
out <- future_pmap(scenarios, run_scenario, .progress = TRUE, .options = furrr_options(seed = T))

# format the output
df <- bind_cols(scenarios, bind_rows(out)) %>%
  unnest(output) %>%
  filter(compartment %in% c("deaths", "infections"))

# summarise
df_summary <- df %>%
  group_by(compartment, income_group, coverage) %>%
  summarise(value = sum(value, na.rm = T)) %>%
  mutate(income_group = factor(income_group, levels = c("LIC", "LMIC", "UMIC","HIC")))

# calculate averted deaths
df_summary_zero_vacc <- df_summary %>%
  filter(coverage == 0) %>%
  mutate(value_no_vacc = value) %>%
  select(compartment, income_group, value_no_vacc)

df_summary <- left_join(df_summary, df_summary_zero_vacc) %>%
  filter(coverage != 0) %>%
  mutate(events_averted = value_no_vacc - value)

# create plot
ggplot(data = df_summary, 
       aes(x = factor(income_group), y = events_averted)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~compartment, scales = "free") +
  theme_bw() +
  scale_fill_viridis_d(end = 0.8) +
  labs(x = "income setting", y = "events averted")
