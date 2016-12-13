#VJ Davey
#11/29/16
#Machine Learning
#Assignment3.R
rm(list=ls())
   
   
#####################
#### QUESTION 1 #####
#####################
library(ISLR) #going to use the Weekly data set
library(MASS) #going to do LDA, QDA
library(class) #for KNN
library(boot)
attach(Weekly)
set.seed(5072)
#function to print the confusionMatrix Statistics for this problem specifically
getConfStats <- function(confmatrix,null,alternate){
  
  #fraction of overall correct predictions
  correct<-(confmatrix[null,null]+confmatrix[alternate,alternate])/sum(confmatrix)
  #overall error rate
  error<-(confmatrix[null,alternate]+confmatrix[alternate,null])/sum(confmatrix)
  #type I error rate
  t1error<-(confmatrix[null,alternate]/sum(confmatrix[null,]))
  #type II error rate
  t2error<-(confmatrix[alternate,null]/sum(confmatrix[alternate,]))
  #power of the model
  power<-1-(confmatrix[alternate,null]/sum(confmatrix[alternate,]))
  #precision of the model
  precision<-(confmatrix[alternate,alternate]/sum(confmatrix[,alternate]))
  
  print(paste("fraction of overall correct predictions:", correct))
  print(paste("overall error rate:", error))
  print(paste("type I error rate:", t1error))
  print(paste("type II error rate:", t2error))
  print(paste("power of the model:", power))
  print(paste("precision of the model:", precision))
  
}
glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data=Weekly, family=binomial)
summary(glm.fit)
#Lag2 seems to have statistical significance according to the summary
glm.probs=predict(glm.fit,type="response")
glm.pred=rep("Down",nrow(Weekly))#Down is the null hypothesis
glm.pred[glm.probs > 0.5] <- "Up"
confmatrix<-table(glm.pred,Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")

train <- (Year<2009)
glm.fit=glm(Direction~Lag2,data=Weekly, family=binomial, subset=train)
test<-Weekly[!train,]
glm.probs=predict(glm.fit,test,type="response")
glm.pred=rep("Down",nrow(test))
glm.pred[glm.probs>0.5]<-"Up"
confmatrix<-table(glm.pred,test$Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")

#LDA -- still use the same sets as previous subproblem, no need to remake
lda.fit=lda(Direction~Lag2,data=Weekly, family=binomial, subset=train)
lda.pred=predict(lda.fit,test)
confmatrix<-table(lda.pred$class,test$Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")
#QDA
qda.fit=qda(Direction~Lag2,data=Weekly, family=binomial, subset=train)
qda.pred=predict(qda.fit,test)
confmatrix<-table(qda.pred$class,test$Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")
#KNN, k=1
  #train,test,k
knn.pred <- knn(as.matrix(Lag2[train]),as.matrix(Lag2[!train]),Direction[train],k=1)
confmatrix<-table(knn.pred,test$Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")
#KNN, k=5
knn.pred <- knn(as.matrix(Lag2[train]),as.matrix(Lag2[!train]),Direction[train],k=5)
confmatrix<-table(knn.pred,test$Direction)
confmatrix
getConfStats(confmatrix,"Down","Up")
#the method that appears to provide the best results is LDA and logistic regression. They have the highest fraction of overall correct predictions and lowest overall error rates.They also provide better power and precision.


#####################
#### QUESTION 2 #####
#####################
set.seed(5072)
mpg01 = rep(0, length(mpg))#binary variable to be appended onto the end of the Auto Dataset
mpg01[mpg > median(mpg)] = 1
#create new dataset for Auto that includes the mpg01 binary variable
Auto.q2 = data.frame(Auto, mpg01)
trainindices<-sample(1:nrow(Auto.q2),size=.8*nrow(Auto.q2))#training set at 80%
train<-Auto.q2[-1][trainindices,]
test<-Auto.q2[-1][-trainindices,]
#create vector of falses and set it to TRUE wherever the training indices are so we can properly subset in the glm function
subvec=rep(FALSE,nrow(Auto.q2))
subvec[trainindices]=TRUE

glm.fit=glm(mpg01~cylinders+displacement+weight,data=Auto,family=binomial,subset=subvec)
glm.probs<-predict(glm.fit,test,type="response")
glm.pred=rep(0,nrow(test))
glm.pred[glm.probs>0.5]=1
confmatrix<-table(glm.pred,test$mpg01)
confmatrix
getConfStats(confmatrix,"0","1")

#LDA
lda.fit=lda(mpg01~cylinders+displacement+weight,data=Auto,subset=subvec)
lda.pred=predict(lda.fit,test)
confmatrix<-table(lda.pred$class,test$mpg01)
confmatrix
getConfStats(confmatrix,"0","1")
#QDA
qda.fit=lda(mpg01~cylinders+displacement+weight,data=Auto,subset=subvec)
qda.pred=predict(qda.fit,test)
confmatrix<-table(qda.pred$class,test$mpg01)
confmatrix
getConfStats(confmatrix,"0","1")
#KNN; k=1
knn.pred <- knn(cbind(cylinders,displacement,weight)[subvec,],cbind(cylinders,displacement,weight)[!subvec,],mpg01[subvec],k=1)
confmatrix<-table(knn.pred,test$mpg01)
confmatrix
getConfStats(confmatrix,"0","1")
#KNN k in a for loop, from 2 to 10
for(k in 2:10){
  knn.pred <- knn(cbind(cylinders,displacement,weight)[subvec,],cbind(cylinders,displacement,weight)[!subvec,],mpg01[subvec],k=k)
  confmatrix<-table(knn.pred,test$mpg01)
  print(paste("The Model Stats for K = ", k))
  getConfStats(confmatrix,"0","1")
}

#for my analysis it appears that the best model came from knn with k=3 since it had the lowest overall error rate and highest precision


#####################
#### QUESTION 3 #####
#####################
#check if above or below the median.
#0 is below
#1 is above
#basically the same as the previous problem
attach(Boston)
crim01 = rep(0, length(crim))#binary variable to be appended onto the end of the Auto Dataset
crim01[crim > median(crim)] = 1
Boston.q3 = data.frame(Boston,crim01)

trainindices<-sample(1:nrow(Boston.q3),size=.8*nrow(Boston.q3))#training set at 80%
train<-Boston.q3[-1][trainindices,]
test<-Boston.q3[-1][-trainindices,]
#create vector of falses and set it to TRUE wherever the training indices are so we can properly subset in the glm function
subvec=rep(FALSE,nrow(Boston.q3))
subvec[trainindices]=TRUE

glm.fit=glm(crim01~nox+rad+dis,data=Boston.q3,family=binomial,subset=subvec)
glm.probs<-predict(glm.fit,test,type="response")
glm.pred=rep(0,nrow(test))
glm.pred[glm.probs>0.5]=1
confmatrix<-table(glm.pred,test$crim01)
confmatrix
getConfStats(confmatrix,"0","1")

#LDA
lda.fit=lda(crim01~nox+rad+dis,data=Boston.q3,subset=subvec)
lda.pred=predict(lda.fit,test)
confmatrix<-table(lda.pred$class,test$crim01)
confmatrix
getConfStats(confmatrix,"0","1")
#QDA
qda.fit=lda(crim01~nox+rad+dis,data=Boston.q3,subset=subvec)
qda.pred=predict(qda.fit,test)
confmatrix<-table(qda.pred$class,test$crim01)
confmatrix
getConfStats(confmatrix,"0","1")
#KNN; k=1
knn.pred <- knn(cbind(nox,rad,dis)[subvec,],cbind(nox,rad,dis)[!subvec,],crim01[subvec],k=1)
confmatrix<-table(knn.pred,test$crim01)
confmatrix
getConfStats(confmatrix,"0","1")
#KNN k in a for loop, from 2 to 10
for(k in 2:10){
  knn.pred <- knn(cbind(nox,rad,dis)[subvec,],cbind(nox,rad,dis)[!subvec,],crim01[subvec],k=k)
  confmatrix<-table(knn.pred,test$crim01)
  print(paste("The Model Stats for K = ", k))
  getConfStats(confmatrix,"0","1")
}
#the best model seems to be KNN with K=2. Lowest Error rate and highest precision.


#####################
#### QUESTION 4 #####
#####################
set.seed(5072)
x=rnorm(100)
y=x-2*x^2+rnorm(100)
muhFrame = data.frame(x,y)
plot(x,y)
set.seed(123)
for(i in 1:4){
  glm.fit = glm(y~poly(x,i))
  print(paste("LOOCV error for model ", i))
  print(cv.glm(muhFrame,glm.fit)$delta)
}
set.seed(456)
for(i in 1:4){
  glm.fit = glm(y~poly(x,i))
  print(paste("LOOCV error for model ", i))
  print(cv.glm(muhFrame,glm.fit)$delta)
}
#my results are the same as what I got in d). This is probably because LOOCV checks a given amount of folds.
#the model in d) that had the smallest LOOCV error was model 2. This makes since because there is an x^2 term in the equation for y and the plot is parabolic
summary(glm.fit)
#there is highest significance with the p-values for the second model,(check the above summary) this is in agreement with the conclusion drawn from the cross validation approach.
