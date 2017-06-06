#VJ Davey
#Lab 1 MLII
rm(list=ls())
#Objectives
#Get comfortable with PCA and then develop regression models 
#using two common approaches to dimension reduction: 
    #Principal Component Regression
    #Partial Lease Squares Regression

#####################
#### SECTION 1   ####
#####################
X <- matrix(c(1,0,1,3,3,1,0,11,2,1,1,7), nrow=4, ncol=3)
  #center columns of X
I <- matrix(c(rep(1,nrow(X))),nrow = nrow(X), ncol=1)
X <- X-I%*%t(I)%*%X*(1/nrow(X)) #NOTE: t function is matrix transpose
  #report means of each column 
for(i in 1:ncol(X)){
  print(paste("mean of column", i, "is: ", mean(X[,i])))
}
  #scale each column by dividing each element by its columns sd
X <- apply(X, 2, function(m) m/sd(m))
  #report sds of each column -- could be done / apply function, but going for readability here
for(i in 1:ncol(X)){
  print(paste("sd of column", i, "is: ", sd(X[,i])))
}
  #calculate covariance matrix
sigma <- (t(X)%*%X)/(nrow(X)-1) #would be equivalent to running the cov() function -- cov dimensions are n by n for an m row by n column starting matrix
sigma
cov(X)
  #extract eignvectors for the covariance matrix.. these are the principal components of the centered and scaled X
eigens <- eigen(sigma)
eigens
  #check calculations
  #recreate original X
X <- matrix(c(1,0,1,3,3,1,0,11,2,1,1,7), nrow=4, ncol=3)
X <- scale(X, center = TRUE, scale = TRUE)
  #compute principal components of centered and scaled X
prcomp(X) #Rotation values should match eigenvectors from eigen
  #project 3D values from scaled and centered X onto a 2D plane using the first two principal components
  #U is a matrix whose columns are the first two principal components
U <- matrix(prcomp(X)$rotation[,1:2], nrow=3,ncol=2)
Z <- X%*%U
Z
plot(Z, xlab="PC1", ylab="PC2", main = "Display of Z")


#####################
#### SECTION 2   ####
#####################
  #work through ISLR Lab Section 6.7 on pp.256 of textbook
library(pls)
library(ISLR)
  #load in Hitters Data
Hitters=na.omit(Hitters)
x<-model.matrix(Salary~.,Hitters)[,-1]
y<-Hitters$Salary
  #SECTION 6.7.1
set.seed(1)
train=sample(1:nrow(x),nrow(x)/2)
test=(-train)
y.test=y[test]
set.seed(2)
  #perform principal components regression using the pcr() function from the pls library
  #syntax is similar to lm() function with some additional options  
    #scale=TRUE standardizes each predictor prior to generating principal components
    #validation="CV" causes pcr() to compute 10-fold CV error for each possible value of M, where M is the number of principal components used
pcr.fit=pcr(Salary~., data=Hitters, scale=TRUE, validation="CV")
summary(pcr.fit)  
  #plot cross validation scores using validationplot()
    #using val.type="MSEP" will cause the cross validation MSE to be plotted
validationplot(pcr.fit, val.type = "MSEP")
  #perform PCR on a training data set and evaluate its test set performance
set.seed(1)
pcr.fit=pcr(Salary~.,data=Hitters, subset=train, scale=TRUE, validation="CV")
validationplot(pcr.fit,val.type = "MSEP")
summary(pcr.fit) #we see that the lowest CV error (adjcv) occurs when M=7
  #compute test MSE
pcr.pred=predict(pcr.fit,x[test,],ncomp=7)
mean((pcr.pred-y.test)^2) #this test MSE is competetive with results from RR and Lasso, however the final model may be more difficult to interpret since it does not perform variable selection or directly produce coefficient estimates
  #fit PCR on the full dataset using M=7, the number of components identified by Cross Validation
pcr.fit=pcr(y~x,scale=TRUE, ncomp=7)
summary(pcr.fit)

  #SECTION 6.7.2
set.seed(1)
  #implement partial least squares (PLS) using pslr(), which is also in the pls library
  #syntax is just like pcr()
pls.fit=plsr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
summary(pls.fit)#lowest CV-error occurs when M=2 partial least square directions are used
validationplot(pls.fit,val.type = "MSEP")
pls.pred=predict(pls.fit,x[test,],ncomp=2)
mean((pls.pred-y.test)^2)#test MSE is comparable to, but slightly higher than, test MSE obtained with ridge regression, lasso and PCR
  #perform PLS using the full dataset using M=2
pls.fit=plsr(Salary~.,data=Hitters,scale=TRUE,ncomp=2)
summary(pls.fit)
  #two component PLS fit explains almosts as much variance as the seven model PCR fit does. This is because PLS searches for directions that explain variance in both the predictors and the response.

#####################
#### SECTION 3   ####
#####################
  #create data frame using URL in HW sheet
data <- read.csv("https://raw.githubusercontent.com/Jonasyao/Machine-Learning-Specialization-University-of-Washington-/master/Regression/Assignment_four/kc_house_data.csv")
  #cleaning - remove NAs, remove first two columns, center and scale data
data <- na.omit(data)
price<-data$price
data <- data[,-(1:2)]
data <- as.data.frame(scale(data, center = TRUE, scale=TRUE)) #NOTE: scale transforms the data frame into a matrix! need to use as.data.frame to make sure it stays a data frame!
data[["price"]]<-price  
  #create 80/20 train/test split on the data
set.seed(1)
train=sample(1:nrow(data),nrow(data)*0.8)
test=(-train)
  #construct a linear regression model of the training data using lm() that predicts price using all the remaining predictors in the dataset
lm.fit = lm(price~.,data=data, subset = train)
summary(lm.fit)
  #discover multicollinearity using the alias function
alias(lm.fit)#we see that sqft_basement=sqft_living-sqft_above
  #remove sqft_basement
data<-data[,-which(names(data) == "sqft_basement")]
  #reconstruct linear model and make sure the error is gone
lm.fit = lm(price~.,data=data, subset = train)
summary(lm.fit)
  #calculate and save test MSE 
lm.pred=predict(lm.fit,data[test,])
mse=mean((data$price[test] - lm.pred)^2)
mse 
  #create a principal component regression model
set.seed(1)
pcr.fit=pcr(price~., data=data, validation="CV")
summary(pcr.fit)
validationplot(pcr.fit, val.type = "MSEP")
  #Im choosing 17 because my machine says the adjcv is the lowest in the summary and it appears to be lowest on the graph 
pcr.pred=predict(pcr.fit,data[test,],ncomp=17)
pcr_mse<-mean((pcr.pred-data$price[test])^2)
pcr_mse

#####################
#### SECTION 4   ####
#####################
set.seed(1)
pls.fit=plsr(price~., data=data, validation="CV")
summary(pls.fit)
validationplot(pls.fit, val.type = "MSEP")
  #Im going to choose 9
pls.pred=predict(pls.fit,data[test,],ncomp=7)
pls_mse<-mean((pls.pred-data$price[test])^2)
pls_mse

#comments on model performace:
mse#OLS regression MSE
pcr_mse#PCR regression MSE
pls_mse#PLS regression MSE

#They all appear to be in the same ballpark, but PCR and PLS seem to outperorm OLS, with PCR being the best of the two