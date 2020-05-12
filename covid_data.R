library(tidyverse)
library(tidycovid19)

df <- download_merged_data(cached = TRUE, silent = TRUE)

poland <- df %>% 
  filter(country == "Poland")

poland_trend <- poland %>% 
  filter(date > "2020-03-15") %>% 
  filter(!is.na(confirmed)) %>% 
  select(3:6) %>% 
  mutate(t=1:56)

summary(lm(poland_trend$confirmed ~ poland_trend$t))
  
ggplot(poland_trend, aes(x=date, y=confirmed)) + 
  geom_point() +
  geom_smooth(method = "lm")

write.table(poland_trend, file = "data/covid.csv", sep = ";", dec = ",", row.names = F)
