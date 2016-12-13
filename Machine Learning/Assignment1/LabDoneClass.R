#install.packages("FNN")
rm(list=ls())
###############################################################################
######### Part 1: Predicting Graduation Rate: The Regression Setting ##########
###############################################################################
print('Predicting Graduation Rates: The Regression Setting')
college<-read.csv('College.csv',header=T)
rownames(college)<-college[,1]
college<-college[,-1]
n<-nrow(college)
print(paste('MSE of predicting the mean:',mean((college$Grad.Rate-mean(college$Grad.Rate))^2)))
print(paste('Variance of the population:',(var(college$Grad.Rate)*(n-1)/n)))
set.seed(5072)
trainindices<-sample(1:nrow(college),.8*nrow(college))
trset<-college[-1][trainindices,]
teset<-college[-1][-trainindices,]
y.name='Grad.Rate'
train.xvals<-scale(trset[setdiff(names(trset),y.name)])
test.xvals<-scale(teset[setdiff(names(teset),y.name)])
train.yvals<-trset$Grad.Rate
test.yvals<-teset$Grad.Rate
require(FNN)
#The knn.reg() function requires 4 parameters:
#   1. A matrix or college frame containing the predictors associated with the training college, here train.xvals
#   2. A matrix or college frame containing the predictors associated with the college for which we wish to make predictions, here test.xvals
#   3. A factor containing the class labels for the training observations, here train.yvals
#   4. A value for K, the number of nearest neighbors to be used by the classifier.
testMSEs<-numeric(0)
trainMSEs<-numeric(0)
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

