library(tidyverse)
library(ggplot2)
library(dplyr)
library(data.table)
library(lubridate)
library(scales)
library(corrplot)
library(DT)

# load dataset
traindata = read.csv('data/train.csv', stringsAsFactors = TRUE)
testdata = read.csv('data/test.csv', stringsAsFactors = FALSE)
data.macro = read.csv('data/macro.csv', stringsAsFactors = FALSE)

str(traindata)


## Missing data

miss_pct <- map_dbl(traindata, function(x) { round((sum(is.na(x)) / length(x)) * 100, 1) })

miss_pct <- miss_pct[miss_pct > 0]

data.frame(miss=miss_pct, var=names(miss_pct), row.names=NULL) %>%
  ggplot(aes(x=reorder(var, -miss), y=miss)) + 
  geom_bar(stat='identity', fill='red') +
  labs(x='', y='% missing', title='Percent missing data by feature') +
  theme(axis.text.x=element_text(angle=90, hjust=1))

## Build year
traindata %>% 
  filter(build_year > 1691 & build_year < 2018) %>% 
  ggplot(aes(x=build_year)) + 
  geom_histogram(fill='lightblue') + 
  ggtitle('Distribution of build year')


# room count
ggplot(aes(x=num_room), data=traindata) + 
  geom_histogram(fill='red', bins=20) + 
  ggtitle('Distribution of room count')

# sales type
ggplot(aes(x=price_doc), data=traindata) + 
  geom_density(fill='red', color='red') + 
  facet_grid(~product_type) + 
  scale_x_continuous(trans='log')

# build year
traindata %>% 
  filter(build_year > 1691 & build_year < 2018) %>% 
  ggplot(aes(x=build_year)) + 
  geom_histogram(fill='red', bins=10) + 
  ggtitle('Distribution of build year')
