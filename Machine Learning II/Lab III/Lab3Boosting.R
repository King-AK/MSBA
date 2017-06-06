#clear workspace
rm(list=ls()) 
library(tree)
library(gbm)
#http://www.rmdk.ca/boosting_forests_bagging.htmlread.csv()
telecomData<-read.csv("Lab3Data.csv")
telecomData<-telecomData[complete.cases(telecomData),]
#drop the first column, which is customerID
telecomData<-telecomData[,-1]
#View(telecomData)
str(telecomData)

#training and testing split 
set.seed(777)
percTrain = 0.75 #specifies the proportion of the data to be withheld for training. The remainder is used for testing.
train = sample(1:nrow(telecomData), nrow(telecomData)*percTrain)
test = telecomData[-train,]
churn.test = telecomData$Churn[-train]
#adjust response variable so that it can be evaluated as bernoulli
telecomData$Churn = ifelse(telecomData$Churn=="Yes",1,0)
#build boosted decision tree with training data
boost.tel = gbm(Churn~., data=telecomData[train,], 
                distribution = "bernoulli", 
                n.trees = 5000, #number of trees
                interaction.depth = 4, #maximum depth of variable interactions
                shrinkage = 0.001, #Default 0.001 #shrinkage parameter
                bag.fraction = 0.3, #Default 0.5 #fraction of training set observations randomly selected to propose the next tree in the expansion. Introduces randomnesses into model fit.
                train.fraction = 1.0,#Default 1.0 #proportion of the first nrows  of data to be used to fit the gbm. The remainder is used for computing out of sample estimates for the loss function 
                n.minobsinnode = 20, #Default 10 #minimum number of observations in the tree's terminal nodes. Actual number of observations, not the total weight
                cv.folds = 10 #Default 0 #number of cross-validation folds to perform
                )


par(mfrow=c(1,1))
plot(boost.tel)
summary(boost.tel) #Contract and tenure are the most important with the testing data

#create particial dependence plots(illustrates the marginal effect of the selected variables on the response after integrating out the other variables)
par(mfrow=c(1,2))
plot(boost.tel,i="Contract")
plot(boost.tel,i="tenure")
#according to the graph, the possibilities of churn decrease as either of them increases.#predict Churn on the test set

#Now look at predictive power of boosted tree
yhat.boost=predict(boost.tel,newdata=telecomData[-train,],n.trees=5000, type = "response")


boost.class<-ifelse(yhat.boost>0.5,"Yes","No")
confusionMatrix = table(churn.test, boost.class, dnn=c("Actual","Predicted"))
percConfMatrx=round(100*confusionMatrix/length(boost.class), digits = 2) #give the table in terms of the percentages to two decimal spots. Table should add up to 100
percConfMatrx
success_rate=percConfMatrx[1,1]+percConfMatrx[2,2]
error_rate=percConfMatrx[1,2]+percConfMatrx[2,1]
typeIErr=percConfMatrx[1,2]
typeIIErr=percConfMatrx[2,1]
percConfMatrx
success_rate
error_rate
typeIIErr

