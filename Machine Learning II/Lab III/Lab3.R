#VJ Davey
#Lab III --Base Tree with Pruning
#Boils down to fitting a classifcation tree and doing some pruning with CV as done in ISLR 8

#predicting churn for a company with decision trees
rm(list=ls())
library(tree)
require(rpart)
require(rattle)
telecomData = read.csv("Lab3Data.csv")
telecomData = telecomData[complete.cases(telecomData),] #removes NAs

#look at the telecomData dataframe
telecomData$SeniorCitizen = as.factor(telecomData$SeniorCitizen)
telecomData$Churn =factor(ifelse(telecomData$Churn=="Yes",1,0))
str(telecomData)
#drop the customerID column 
telecomData<-subset(select=-c(customerID), telecomData)

#build normal tree to look at with no pruning -- using rpart instead of normal tree library
tree.churn = rpart(Churn~., telecomData,method="class")
summary(tree.churn)
#graphically display w/ plot() and text() functions
par(mfrow=c(1,1))
plot(tree.churn, main="Base Churn Decision Tree Full Data")
text(tree.churn, pretty = 0)
fancyRpartPlot(tree.churn)


#training and testing split 
set.seed(2016)
percTrain = 0.8 #specifies the proportion of the data to be withheld for training. The remainder is used for testing.
train = sample(1:nrow(telecomData), nrow(telecomData)*percTrain)
test = telecomData[-train,]
churn.test = telecomData$Churn[-train]
#build Rpart decision tree with training data
tree.trainChurn = rpart(Churn~., telecomData, subset = train, method = "class")
#plot the tree
plot(tree.trainChurn, main="Base Train Churn Decision Tree")
text(tree.trainChurn, pretty = 0)
#examine the tree cross validation
printcp(tree.trainChurn) #examine cross validation error results
plotcp(tree.trainChurn)#plot cross validation error results
  #prune the tree by selecting the tree which mininizes cross validation error
minCV = which.min(tree.trainChurn$cptable[,"xerror"])
tree.trainChurn = prune(tree.trainChurn, cp=tree.trainChurn$cptable[minCV, "CP"])
#plot the pruned tree both normally, and with the fancy colored plot
plot(tree.trainChurn, main="Pruned Churn Decision Tree")
text(tree.trainChurn, pretty = 0)
fancyRpartPlot(tree.trainChurn)

#make predictions on the withheld data using the pruned tree
tree.pred = predict(tree.trainChurn, newdata=test, type="class")
#always want actuals as the rows, predicted in the columns ## table(rows,columns), with null hypothesis before the alt
confusionMatrix = table(churn.test, tree.pred, dnn=c("Actual","Predicted"))
percConfMatrx=round(100*confusionMatrix/length(tree.pred), digits = 2) #give the table in terms of the percentages to two decimal spots. Table should add up to 100
success_rate=percConfMatrx[1,1]+percConfMatrx[2,2]
error_rate=percConfMatrx[1,2]+percConfMatrx[2,1]
typeIErr=percConfMatrx[1,2]
typeIIErr=percConfMatrx[2,1]
percConfMatrx
success_rate
error_rate
typeIIErr #would likely want to minimize this first and foremost. Would be better to falsely predict churn than miss a customer that is churning