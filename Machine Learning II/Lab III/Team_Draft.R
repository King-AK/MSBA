#Lab III
#Team 8
rm(list=ls())
library(tree)
library(randomForest)
require(rpart)
require(rpart.plot)
require(rattle)
library(caret)

set.seed(1488)

telecomData = read.csv("Lab3Data.csv")
telecomData = telecomData[complete.cases(telecomData),] #removes NAs

#look at the telecomData dataframe
str(telecomData)
#drop the customerID column 
telecomData<-subset(select=-c(customerID), telecomData)

#EDIT - turn SeniorCitizen into a factor
telecomData$SeniorCitizen <- factor(telecomData$SeniorCitizen)

#remove any correlated columns using caret and turning factors into dummy variables
dummyFrame <- dummyVars(Churn~., data = telecomData)
dummy_matrix<-predict(dummyFrame,newdata = telecomData)
dummyFrame<-data.frame(dummy_matrix)
#remove any correlated columns
dummyFrame2 <- cor(dummyFrame)
hc = findCorrelation(dummyFrame2, cutoff=0.9)
hc=sort(hc)
reduced_data = dummyFrame[,-c(hc)]
#re-add Churn
reduced_data$Churn <- telecomData$Churn
telecomData <- reduced_data

#Create a results data frame
final.results <- data.frame(matrix(ncol = 1, nrow = 4))
colnames(final.results) <- c("Error Rate")
rownames(final.results) <- c("Boosting", "Bagging", "Random Forest", "Classification Tree")

#18.39 is current best

#############################################
################### Boosting ################
#############################################
set.seed(148)
telecomData_Boosting <- telecomData

#change Churn levels to 0 and 1
#telecomData_Boosting$Churn_b[telecomData_Boosting$Churn=="No"] <- 0
#telecomData_Boosting$Churn_b[telecomData_Boosting$Churn=="Yes"] <- 1
#telecomData_Boosting<-telecomData_Boosting[,-20]
#colnames(telecomData_Boosting)[20] <- "Churn"
telecomData_Boosting$Churn <- ifelse(telecomData_Boosting$Churn=="No",0,1)

#training and testing split 
train = sample(1:nrow(telecomData_Boosting), nrow(telecomData)*0.8)
test = telecomData_Boosting[-train,]
churn.test = telecomData_Boosting$Churn[-train]

#create model
boost.tel=gbm(Churn~.,data=telecomData_Boosting[train,],n.trees=5000,interaction.depth=4, n.minobsinnode=5, bag.fraction = .3, cv.folds = 3, shrinkage = 0.001)

#predict Churn on the test set
yhat.boost=predict(boost.tel,newdata=telecomData_Boosting[-train,],n.trees=5000, type="response")

yhat.boost = ifelse(yhat.boost<.5, 0, 1)

#Create confusion matrix
confusionMatrix = table(churn.test, yhat.boost, dnn=c("Actual","Predicted"))
confusionMatrix

right = confusionMatrix[1] + confusionMatrix[4]
wrong = confusionMatrix[2] + confusionMatrix[3]

error_rate = wrong/(right+wrong)*100
success_rate = right/(right+wrong)*100


final.results[1,1] = error_rate

#############################################
################### Bagging #################
#############################################
set.seed(148)
telecomData_Bagging <- telecomData

bag.telecomData = randomForest(Churn~., data=telecomData_Bagging, mtry=19, importance =TRUE)
error_rate <- tail(bag.telecomData$err.rate[,1],1)*100

final.results[2,1] = round(error_rate, 2)

#############################################
################### Random Forest ###########
#############################################
set.seed(148)
telecomData_RandomForest <- telecomData

#Grow a random forest by using a smaller value of the mtry argument


rf.churn = randomForest(Churn~., data=telecomData_RandomForest, mtry=2, ntree = 100, importance =TRUE)
error_rate <- tail(rf.churn$err.rate[,1],1)*100

final.results[3,1] = round(error_rate,2)


#############################################
################### Classification Tree #####
#############################################
set.seed(148)
telecomData_ClassificationTree <- telecomData

#training and testing split 

percTrain = 0.8 #specifies the proportion of the data to be withheld for training. The remainder is used for testing.
train = sample(1:nrow(telecomData_ClassificationTree), nrow(telecomData_ClassificationTree)*percTrain)
test = telecomData_ClassificationTree[-train,]
churn.test = telecomData_ClassificationTree$Churn[-train]

#build Rpart decision tree with training data
tree.trainChurn = rpart(Churn~., telecomData_ClassificationTree, subset = train, method = "class")

#plot the tree
#plot(tree.trainChurn, main="Base Train Churn Decision Tree")
#text(tree.trainChurn, pretty = 0)

#examine the tree cross validation
#printcp(tree.trainChurn) #examine cross validation error results
#plotcp(tree.trainChurn)#plot cross validation error results

#prune the tree by selecting the tree which mininizes cross validation error
minCV = which.min(tree.trainChurn$cptable[,"xerror"])
tree.trainChurn = prune(tree.trainChurn, cp=tree.trainChurn$cptable[minCV, "CP"])

#plot the pruned tree both normally, and with the fancy colored plot
#plot(tree.trainChurn, main="Pruned Churn Decision Tree")
#text(tree.trainChurn, pretty = 0)
#fancyRpartPlot(tree.trainChurn)

#make predictions on the withheld data using the pruned tree
tree.pred = predict(tree.trainChurn, newdata=test, type="class")

#always want actuals as the rows, predicted in the columns ## table(rows,columns), with null hypothesis before the alt
confusionMatrix = table(churn.test, tree.pred, dnn=c("Actual","Predicted"))
percConfMatrx=round(100*confusionMatrix/length(tree.pred), digits = 2) #give the table in terms of the percentages to two decimal spots. Table should add up to 100
success_rate=percConfMatrx[1,1]+percConfMatrx[2,2]
error_rate=percConfMatrx[1,2]+percConfMatrx[2,1]
typeIErr=percConfMatrx[1,2]
typeIIErr=percConfMatrx[2,1]


final.results[4,1] = error_rate


####################### FINAL RESULTS
final.results
