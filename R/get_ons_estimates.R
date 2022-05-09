library("readr")
library("dplyr")
library("lubridate")
library("here")
library("tidyr")

regional_estimates <-
	read_csv(paste0("https://raw.githubusercontent.com/epiforecasts/inc2prev/",
			"master/outputs/estimates_regional.csv"))
national_estimates <-
	read_csv(paste0("https://raw.githubusercontent.com/epiforecasts/inc2prev/",
			"master/outputs/estimates_national.csv"))

estimates <- national_estimates %>%
        bind_rows(regional_estimates) %>%
        filter(!is.na(date)) %>%
	filter(date >= max(date) - weeks(12),
	       level %in% c("national", "regional")) %>%
	mutate(ValueType = case_when(
	         name == "infections" ~ "incidence",
		 name == "est_prev" ~ "prevalence",
		 name == "r" ~ "growth_rate",
		 name == "R" ~ "R")) %>%
	filter(!is.na(ValueType)) %>%
	rename(q05 = q5) %>% ## for sorting
	select(-name) %>%
	filter(ValueType %in% c("R", "growth_rate", "incidence", "prevalence")) %>%
	mutate(Group = "LSHTM",
	       `Creation Day` = day(today()),
	       `Creation Month` = month(today()),
	       `Creation Year` = year(today()),
	       `Day of Value` = day(date),
	       `Month of Value` = month(date),
	       `Year of Value` = year(date)) %>%
	pivot_longer(matches("^q[0-9]")) %>%
	arrange(name) %>%
	mutate(name = paste("Quantile", as.integer(sub("^q", "", name)) / 100)) %>%
	pivot_wider() %>%
	mutate(Value = `Quantile 0.5`,
	       Model = "EpiNow ONS Positivity",
	       Scenario = "Nowcast",
	       ModelType = "Survey",
	       Version = "0.1") %>%
	select(Group, `Creation Day`, `Creation Month`, `Creation Year`, `Day of Value`,
	       `Month of Value`, `Year of Value`, Geography = variable, ValueType, Model,
	       Scenario, ModelType, Version, starts_with("Quantile "))

file_name <- paste(today(), "time-series-ons-cis-lshtm.csv", sep = "-")
write_csv(estimates, here::here("remote", "submit", file_name))
