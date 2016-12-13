#VJ Davey
#10/23/16
#Machine Learning
#Assignment1.R
rm(list=ls())
   
   
#####################
#### QUESTION 1 #####
#####################

homePrices<-read.table("HomePrices.txt", header=TRUE)
n<-nrow(homePrices)
print(paste('MSE of predicting the mean of medv:',mean((homePrices$medv-mean(homePrices$medv))^2)))
print(paste('Variance of medv (assuming data represents a population): ',var(homePrices$medv)* (n-1)/n))
set.seed(5072)
#create training and test sets
trainindices<-sample(1:nrow(homePrices),.8*nrow(homePrices))
trainset<-homePrices[-1][trainindices,]
testset<-homePrices[-1][-trainindices,]
y.name='medv'
train.xvals<-scale(trainset[setdiff(names(trainset),y.name)])
test.xvals<-scale(testset[setdiff(names(testset),y.name)])
train.yvals<-trainset$medv
test.yvals<-testset$medv
require(FNN)
testMSEs<-numeric(0)
trainMSEs<-numeric(0)
#
biggestk=19
kset<-seq(1,biggestk,by=2)           
for(k in kset) {
  knn.class.model<-knn.reg(train.xvals,test.xvals,train.yvals,k=k)
  testMSEs[k%/%2 +1]<-mean((test.yvals-knn.class.model$pred)^2)
  knn.class.model<-knn.reg(train.xvals,train.xvals,train.yvals,k=k)
  trainMSEs[k%/%2 +1]<-mean((train.yvals-knn.class.model$pred)^2)
}
par(mfrow=c(2,1))
plot(kset,testMSEs,type='n',xlim=c(biggestk,1),xlab='Increasing Flexibility (Decreasing k)',ylab='Test MSE',main='Test MSEs as a function of Flexibility for KNN Prediction')
lines(seq(biggestk,1,by=-2),testMSEs[order(length(testMSEs):1)],type='b')
plot(kset,trainMSEs,type='n',xlim=c(biggestk,1),xlab='Increasing Flexibility (Decreasing k)',ylab='Training MSE',main='Training MSEs as a function of Flexibility for KNN Prediction')
lines(seq(biggestk,1,by=-2),trainMSEs[order(length(trainMSEs):1)],type='b')
par(mfrow=c(1,1))
print(paste("Best test k is",kset[which.min(testMSEs)],"with a test MSE of",testMSEs[which.min(testMSEs)]))
print(paste("Best training k is",kset[which.min(trainMSEs)],"with training MSE of",trainMSEs[which.min(trainMSEs)]))
set.seed(seed=NULL)
detach(package:FNN)

#####################
#### QUESTION 2 #####
#####################

loanData <- read.csv("LoanData.csv", header=TRUE)
#print the error rate that would result from always predicting yes
print(paste('The error rate that would result from always predicting Yes:', sum(loanData$loan_repaid!="Yes")/nrow(loanData) ))
#set seed
set.seed(5072)
#create training and test sets
trainindices<-sample(1:nrow(loanData),.8*nrow(loanData))
trainset<-loanData[-1][trainindices,]
testset<-loanData[-1][-trainindices,]
y.name='loan_repaid'
train.xvals<-scale(trainset[setdiff(names(trainset),y.name)])
test.xvals<-scale(testset[setdiff(names(testset),y.name)])
train.yvals<-trainset$loan_repaid
test.yvals<-testset$loan_repaid
require(FNN)
testErrorRate<-numeric(0)
trainErrorRate<-numeric(0)
biggestk=19
kset<-seq(1,biggestk,by=2)           
for(k in kset) {
  knn.class.model<-knn(train.xvals,test.xvals,train.yvals,k=k)
  mytable1<-table(knn.class.model, test.yvals)
  testErrorRate[k%/%2 +1]<-(mytable1["Yes","No"]+mytable1["No","Yes"])/sum(mytable1)
  knn.class.model<-knn(train.xvals,train.xvals,train.yvals,k=k)
  mytable2<-table(knn.class.model, train.yvals)
  trainErrorRate[k%/%2 +1]<-(mytable2["Yes","No"]+mytable2["No","Yes"])/sum(mytable2)
  
}
par(mfrow=c(2,1))
plot(kset,testErrorRate,type='n',xlim=c(biggestk,1),xlab='Increasing Flexibility (Decreasing k)',ylab='Test Error Rate',main='Test Error Rates as a function of Flexibility for KNN Prediction')
lines(seq(biggestk,1,by=-2),testErrorRate[order(length(testErrorRate):1)],type='b')
plot(kset,trainErrorRate,type='n',xlim=c(biggestk,1),xlab='Increasing Flexibility (Decreasing k)',ylab='Training Error Rate',main='Training Error Rates as a function of Flexibility for KNN Prediction')
lines(seq(biggestk,1,by=-2),trainErrorRate[order(length(trainErrorRate):1)],type='b')
par(mfrow=c(1,1))
print(paste("Best test k is",kset[which.min(testErrorRate)],"with a test Error Rate of",testErrorRate[which.min(testErrorRate)]))
print(paste("Best training k is",kset[which.min(trainErrorRate)],"with training Error Rate of",trainErrorRate[which.min(trainErrorRate)]))
set.seed(seed=NULL)
detach(package:FNN)
