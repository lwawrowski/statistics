library(tidyverse)
library(tidycovid19)

df <- download_merged_data(cached = TRUE, silent = TRUE)

poland <- df %>% 
  filter(country == "Poland")

poland_trend <- poland %>% 
  filter(date > "2020-04-29") %>% 
  filter(!is.na(confirmed)) %>% 
  select(3:6) 

summary(lm(poland_trend$confirmed ~ poland_trend$t))
  
ggplot(poland_trend, aes(x=date, y=confirmed)) + 
  geom_point() +
  geom_smooth(method = "lm")

write.table(poland_trend, file = "data/covid2020.csv", sep = ";", dec = ",", row.names = F)

poland_dynamic <- poland %>% 
  filter(date > "2020-04-29") %>% 
  filter(!is.na(confirmed)) %>% 
  select(3:6) %>% 
  mutate(l_conf=lag(confirmed),
         new_cases=confirmed-l_conf) %>% 
  filter(!is.na(new_cases)) %>% 
  select(date, new_cases)

write.table(poland_dynamic, file = "data/covidPL_may.csv", sep = ";", dec = ",", row.names = F)
