#Rscript DSfinal2-xgbfix.R
library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(data.table)
library(lubridate)
library(caret)
library(xgboost)
library(methods)

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory

traindata <- fread("input/fixTrain.csv",stringsAsFactors=TRUE)
testdata <- fread("input/fixTest.csv",stringsAsFactors=TRUE)
data.macro <- fread("input/macro.csv",stringsAsFactors=TRUE)

seed <- 3701
set.seed(seed)

#Create lists for later use
train_ids <- traindata$id
test_ids <- testdata$id
train_price_doc <- traindata$price_doc

# Combine the data
testdata$price_doc <- -1
traintest_womacro <- rbind(traindata,testdata)
#print(head(traintest_womacro))
# Convert Macro Data to Numeric
data.macro$child_on_acc_pre_school <- as.numeric(factor(toString(data.macro$child_on_acc_pre_school)))
data.macro$modern_education_share  <- as.numeric(factor(toString(data.macro$modern_education_share )))
data.macro$old_education_build_share <- as.numeric(factor(toString(data.macro$old_education_build_share)))
print("2")
#Merge the Macro Economic Data
traintest <- as.data.table(merge(traintest_womacro, data.macro, by="timestamp", all.x=TRUE));gc()
traintest_id <- traintest$id
print("3")
# Convert datevalues to individual components
traintest$timestamp <- as.POSIXct(traintest$timestamp)

traintest$saledate <- day(traintest$timestamp)
traintest$salemonth <- month(traintest$timestamp)
traintest$saleyear <- year(traintest$timestamp)
traintest$saleweekday <- wday(traintest$timestamp)
traintest$timestamp  <- NULL


traintest$culture_objects_top_25 <- as.numeric(factor(traintest$culture_objects_top_25))
traintest$thermal_power_plant_raion <- as.numeric(factor(traintest$thermal_power_plant_raion))
traintest$incineration_raion <- as.numeric(factor(traintest$incineration_raion))
traintest$big_market_raion <- as.numeric(factor(traintest$big_market_raion))
traintest$nuclear_reactor_raion <- as.numeric(factor(traintest$nuclear_reactor_raion))
traintest$detention_facility_raion <- as.numeric(factor(traintest$detention_facility_raion))
traintest$sub_area <- as.numeric(factor(traintest$sub_area))
traintest$product_type <- as.numeric(factor(traintest$product_type))
traintest$oil_chemistry_raion <- as.numeric(factor(traintest$oil_chemistry_raion))
traintest$railroad_terminal_raion <- as.numeric(factor(traintest$railroad_terminal_raion))
traintest$radiation_raion <-as.numeric(factor(traintest$radiation_raion))
traintest$sub_area <- as.numeric(factor(traintest$sub_area))
traintest$water_1line <- as.numeric(factor(traintest$water_1line))
traintest$sub_area <- as.numeric(factor(traintest$sub_area))
traintest$big_road1_1line <- as.numeric(factor(traintest$big_road1_1line))
traintest$ecology <- as.numeric(factor(traintest$ecology))
traintest$sub_area <- as.numeric(factor(traintest$sub_area))
traintest$ID_bus_terminal <-as.numeric(factor(toString(traintest$ID_bus_terminal)))
traintest$sub_area <- as.numeric(factor(toString(traintest$sub_area)))
traintest$railroad_1line <- as.numeric(factor(toString(traintest$railroad_1line)))
traintest$ID_railroad_terminal <- as.numeric(factor(toString(traintest$ID_railroad_terminal)))
traintest$ID_metro <- as.numeric(factor(toString(traintest$ID_metro)))


traintest[,":="(rel_floor = floor/max_floor
                ,diff_floor = max_floor-floor
                ,diff_life_sq = full_sq-life_sq
                #,building_age = 2017 - build_year
                ,avg_room_space = full_sq/num_room
)]


#Clean up dataset from unnecessary variables
traintest$price_doc <- NULL
traintest$id <- traintest_id

# Split the data
train <- traintest[traintest$id %in% train_ids,]
test <- traintest[traintest$id %in% test_ids,]
train$id <- NULL
test$id <- NULL

nrow(train)

length(train_price_doc)

# Prepare XGBoost Model
dtest <- xgb.DMatrix(data.matrix(test))
dtrain <- xgb.DMatrix(data.matrix(train), 
                      label = data.matrix(train_price_doc))

xgb_params = list(booster="gbtree",
                  colsample_bytree= 0.7,
                  subsample = 0.7,
                  eta = 0.05,
                  objective= 'reg:linear',
                  max_depth= 5,
                  min_child_weight= 1,
                  eval_metric= "rmse")


gbdt = xgb.train(params = xgb_params,
                 data = dtrain,
                 nrounds = 300,
                 watchlist = list(train = dtrain),
                 print_every_n = 50)


my_preds <- predict(gbdt, dtest, reshape = TRUE)
predictions.xgbm <- cbind (test_ids, my_preds)
predictions.xgbm <- as.data.frame(predictions.xgbm)
names(predictions.xgbm)=c("id","price_doc")
write.csv(predictions.xgbm,"prop_price_xgb_fix.csv",row.names = FALSE)

print("End")