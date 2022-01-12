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

##

traindata$date <- as.POSIXct(strptime(traindata$timestamp, format = "%Y-%m-%d"))
traindata$day <- as.integer(format(traindata$date, "%d")) # day
traindata$month <- as.factor(format(traindata$date, "%m")) # month
traindata$year <- as.integer(format(traindata$date, "%Y")) # year
traindata$weekday <- as.factor(format(traindata$date, "%u")) # weekday
traindata$yearmonth <- paste0(traindata$year, traindata$month)
traindata$timestamp <- NULL
traindata$date <- NULL



ggplot(data = traindata, aes(x = as.factor(day), y = price_doc)) + geom_boxplot(fill = "#5C7457") + labs(title = "Date of the month vs Price", x = "Date", y = "Price")
ggplot(data = traindata, aes(x = as.factor(month), y = price_doc)) + geom_boxplot(fill = "#EAC435") + labs(title = "Month vs Price", x = "Month", y = "Price")
ggplot(data = traindata, aes(x = as.factor(year), y = price_doc)) + 
  geom_boxplot(fill = "#345995") +
  coord_cartesian(ylim = c(0,10000000)) + labs(title = "Year vs Price", x = "Year", y = "Price")

ggplot(data = traindata, aes(x = as.factor(weekday), y = price_doc)) + geom_boxplot(fill = "#E40066") + labs(title = "Day of the week vs Price", x = "Day", y = "Price")


## Build year
traindata %>% 
  filter(build_year > 1691 & build_year < 2018) %>% 
  ggplot(aes(x=build_year)) + 
  geom_histogram(fill='lightblue') + 
  ggtitle('Distribution of build year')

## Build year and price relation
traindata %>% 
  filter(build_year > 1691 & build_year < 2018) %>%
  group_by(build_year) %>% 
  summarize(mean_build_price=mean(price_doc)) %>%
  ggplot(aes(x=build_year, y=mean_build_price)) +
  geom_line(stat='identity', color='darkblue') + 
  geom_smooth(color='darkgrey') +
  ggtitle('Mean price by year of build')

# room count
ggplot(aes(x=num_room), data=traindata) + 
  geom_histogram(fill='lightblue', bins=20) + 
  ggtitle('Distribution of room count')

# sales type
ggplot(aes(x=price_doc), data=traindata) + 
  geom_density(fill='lightblue', color='lightblue') + 
  facet_grid(~product_type) + 
  scale_x_continuous(trans='log')

# build year
traindata %>% 
  filter(build_year > 1691 & build_year < 2018) %>% 
  ggplot(aes(x=build_year)) + 
  geom_histogram(fill='lightblue', bins=10) + 
  ggtitle('Distribution of build year')
