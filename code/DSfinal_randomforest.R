library(ggplot2)
library(readr) 

list.files("input")

# Any results you write to the current directory are saved as output.
train<-read.csv("input/train.csv")
macro<-read.csv("input/macro.csv")
#summary(train)
# Merging train and macro using timestamp
nrow(train)
nrow(macro)
combinedata<- merge(train,macro,by="timestamp",all.y=FALSE)
nrow(combinedata)
#str(combinedata)

#change data type
combinedata$material<-as.factor(combinedata$material)
combinedata$build_year<-as.factor(combinedata$build_year)
combinedata$num_room<-as.factor(combinedata$num_room)
combinedata$state<-as.factor(combinedata$state)
#handling missing values
ncol(combinedata)
ncol(train)
notarget<-combinedata[,-c(1,2,292)]
library(DMwR)
centraldata<-centralImputation(notarget)
#summary(centraldata)
#sum(is.na(notarget))
#sum(is.na(centraldata))
price_doc<-combinedata$price_doc
centraltraintarget<-cbind(centraldata, price_doc)
#summary(centraltraintarget)
nrow(centraltraintarget)

finaltrain<-na.omit(centraltraintarget)
ncol(finaltrain)
summary(finaltrain)

library(caret)

numericdata<-finaltrain[,sapply(finaltrain,is.numeric)]
summary(numericdata)
ncol(numericdata)
factordata<-finaltrain[,sapply(finaltrain,is.factor)]
summary(factordata)
ncol(factordata)
#train.pca<-preP
ncol(finaltrain)

# dummies of categorical

library(dummies)
categorydummy<-dummy.data.frame(factordata)
summary(categorydummy)

finaltrain1<-cbind(numericdata,categorydummy)
#ncol(finaltrain1)
#which(colnames(finaltrain1)=="price_doc")
# standadizing the data
# removing the target variable
price_doc<-finaltrain1$price_doc
notargettrain<-finaltrain1[,-367]
library(vegan)
standardizedtraindata<-decostand(notargettrain, method="normalize")
head(standardizedtraindata)
# pca
pca_train<-prcomp(standardizedtraindata)
pca_traindata<-predict(pca_train, newdata=standardizedtraindata)
#conbining pca data and target
finaltrain2<-cbind(pca_traindata[,c(1:10)],price_doc)
head(finaltrain2)
nrow(finaltrain2)
#library(randomForest)
#rfmodel<-randomForest(price_doc~.,data=finaltrain1 )
# summary(rfmodel)

library(randomForest)
rfmodel<-randomForest(price_doc~.,data=finaltrain2 )
summary(rfmodel)


#test 
test<-read.csv("input/test.csv")
combinedatatest<- merge(test,macro,by="timestamp",all.y=FALSE)
nrow(test)
nrow(combinedatatest)
#summary(combinedatatest)
#summary(combinedata)
#str(combinedata)

#change data type
combinedatatest$material<-as.factor(combinedatatest$material)
combinedatatest$build_year<-as.factor(combinedatatest$build_year)
combinedatatest$num_room<-as.factor(combinedatatest$num_room)
combinedatatest$state<-as.factor(combinedatatest$state)
#handling missing values
ncol(combinedatatest)
ncol(test)
noidtest<-combinedatatest[,-c(1,2)]
library(DMwR)
centraldatatest<-centralImputation(noidtest)
#summary(centraldata)
#sum(is.na(notarget))
#sum(is.na(centraldata))

centraltest<-centraldatatest
#summary(centraltraintarget)
nrow(centraltest)

#finaltrain<-na.omit(centraltraintarget)
ncol(centraltest)
centraltest<-centraltest[colSums(!is.na(centraltest)) > 0]

summary(centraltest)
#sum(is.na(centraltest)
#sum(is.na(finaltrain2)
##library(caret)

numericdatatest<-centraltest[,sapply(centraltest,is.numeric)]
summary(numericdatatest)
ncol(numericdatatest)
factordatatest<-centraltest[,sapply(centraltest,is.factor)]
summary(factordatatest)
ncol(factordatatest)
#train.pca<-preP

#ncol(finaltrain)

# dummies of categorical

library(dummies)
categorydummytest<-dummy.data.frame(factordatatest)
summary(categorydummytest)

finaltest1<-cbind(numericdatatest,categorydummytest)
#ncol(finaltrain1)
#which(colnames(finaltrain1)=="price_doc")
# standadizing the data
# removing the target variable
#price_doc<-finaltrain1$price_doc
#notargettrain<-finaltrain1[,-367]
library(vegan)
standardizedtestdata<-decostand(finaltest1, method="normalize")
head(standardizedtestdata)
# pca
pca_test<-prcomp(standardizedtestdata)
pca_testdata<-predict(pca_test, newdata=standardizedtestdata)
#conbining pca data and target
finaltest2<-cbind(pca_testdata[,c(1:10)])
head(finaltest2)
#library(randomForest)
#rfmodel<-randomForest(price_doc~.,data=finaltrain1 )
# summary(rfmodel)
nrow(finaltest2)
nrow(finaltrain2)
nrow(test)
nrow(combinedatatest)
# predictions
pred<-predict(rfmodel,finaltest2)
data<-data.frame(id=test$id,price_doc=pred)


write.csv(data,file="Submission.csv",row.names=FALSE)

print("End")