#VJ Davey
#11/11/16
#Machine Learning
#Assignment2.R
rm(list=ls())
   
   
#####################
#### QUESTION 1 #####
#####################
set.seed(5072)
#Using the rnorm() function, create a vector named x, containing 100 observations drawn from a N(0, 1) distribution. 
x<-rnorm(100, mean = 0, sd = 1)
#Using the rnorm() function, create a vector named eps, containing 100 observations drawn from a N(0,0.25) distribution that is, a normal distribution with mean zero and variance 0.25. 
#standard deviation is the square root of the variance. 
eps<-rnorm(100, mean = 0, sd=sqrt(0.25))
#Using x and eps, generate a vector named y according to the model in the pdf
y<- -1 + 0.5*x+eps
#Display the length of y.
length(y)
#On a single comment line, indicate what the values of beta-0 and beta-1 are in this linear model. 
#   beta-0 is -1, beta-1 is 0.5

#Create a scatterplot displaying the relationship between x and y. 
plot(x,y)

#Again on a single comment line, comment briefly on the type of relationship you observe (positive or negative), the degree of linearity what you observe, and the amount of variability you observe.
#   I observe a positive relationship, an obeservable degree of linearity, and a decent amount of variability

#Fit a least squares linear model to predict y using x. 
lm.fit<-lm(y~x)
#What are beta-0-hat and beta-1-hat (recall the coef() extractor function)? 
#   beta-0-hat is -1.003 ; beta-1-hat is .0435
coef(lm.fit)
#How do they compare with beta-0 and beta-1?
#   beta-0-hat is really close to beta-0. beta-1-hat is sort of close too, but its off by several hundreths.

#Display the least squares line on the scatterplot obtained above in black
abline(lm.fit, lwd=3, col="black")
#Display the population regression line on the plot, in red.
abline(-1, 0.5, lwd=3,col="red")
#Use the legend() command to create an appropriate legend. 
legend(-1,legend = c("least squares", "population regression"), col=c("black","red"), lwd=3)
#Fit a polynomial regression model that predicts y using x and x2.
lm.fit2 = lm(y~x+I(x^2))
#Comment on whether or not there is there evidence that the quadratic term improves the model fit, and briefly explain your answer
#   There isn't evidence that the quadratic term has improved the model fit. The F-Statistic is .3277 and the P statistic is not exactly near zero, ergo we must assume there is no discernable difference in the fit of the two models.
anova(lm.fit, lm.fit2)
#Repeat b)-m) after modifying the data generation process in such a way that there is less noise in the data.
#Do this by changing the variance of the model eps in d) to 0.1. Otherwise, the model should remain the same
#   we continue to observe positive linear relationships. We see less variability than the first fit. We have a beta-0-hat near 0.5 and a beta-1-hat near -1.
eps_1<-rnorm(100, mean = 0, sd=sqrt(0.1))
y_1<- -1 + 0.5*x+eps_1
length(y_1)
plot(x,y_1)
lm.fit_1<-lm(y_1~x)
coef(lm.fit_1)
abline(lm.fit_1, lwd=3, col="black")
abline(-1, 0.5, lwd=3,col="red")
legend(-1,legend = c("least squares", "population regression"), col=c("black","red"), lwd=3)

#Repeat b)-m) after modifying the data generation process in such a way that there is more noise in the data
#   we continue to obeserve positive linear relationships. We have more variability than the first fit. We have with a beta-1-hat around -1 and a beta-0-hat that begins to veer toward 0.6
eps_2<-rnorm(100, mean = 0, sd=sqrt(0.5))
y_2<- -1 + 0.5*x+eps_2
length(y_2)
plot(x,y_2)
lm.fit_2<-lm(y_2~x)
coef(lm.fit_2)
abline(lm.fit_2, lwd=3, col="black")
abline(-1, 0.5, lwd=3,col="red")
legend(-1,legend = c("least squares", "population regression"), col=c("black","red"), lwd=3)


#Contrast the closeness of the fit to the population regression line among all three levels of population variance 
#   The less variance, the closer the fit is to the population regression line and vice versa

#Display the 95% confidence intervals for beta-0 and beta-1 based on the original data set, the noisier data set, and the less noisy data set. 
confint(lm.fit, level = 0.95)
confint(lm.fit_1, level = 0.95)
confint(lm.fit_2, level = 0.95)
#Comment on the reason why the widths of the confidence intervals are as observed. 
#   The widths of the confidence intervals are as observed because of changes in the variance between least squares models. Their intervals correspond with the level of variance each fit was given.



#####################
#### QUESTION 2 #####
#####################
#a)
set.seed(5072)
x1=runif(100)
x2 = 0.5 *  x1 + rnorm(100)/10 
y= 2+2* x1 + 0.3* x2 + rnorm(100) 
#On a single comment line, indicate what the values of beta-0, beta-1 and beta-2 are in this linear model. 
#   beta-0 is 2, beta-1 is 2, beta-2 is 0.3

#Display the Pearson correlation coefficients of y, x1 and x2. 
cor(y,x1, method="pearson")
cor(y,x2, method="pearson")
cor(x1,x2, method="pearson")
# Create scatterplots displaying the relationship between y, x1 and x2
#first create a dataframe holding all 3 
df = data.frame(y,x1,x2)
pairs(df)
# Comment of the correlations among these variables,
#   x1 and x2 seem to be more correlated to eachother than either is to y 

#Using this data, fit a least squares regression model called lm.fit.both to predict y using x1 and x2. 
lm.fit<- lm(y~x1+x2)
#Display the values of beta-0-hat, beta-1-hat, and beta-2-hat.
coef(lm.fit)
summary(lm.fit)
#Comment on the statistical significance of the beta-hats
#   statistically these values are somewhat near the true beta values. They have high std error rates though.

#Can you reject the null hypothesis H0: beta-1 = 0? How about the null hypothesis H0: beta-2 = 0? Explain how you arrived at this conclusion
#   we reject the null hypothesis for beta-1=0 due to its p-value being below 5%. We cannot reject the null hypothesis for beta-2 because its p-value is greater than 5%

#Fit a least squares regression model called lm.fit.justx1 to predict y using only x1. 
lm.fit.justx1 = lm(y~x1)
summary(lm.fit.justx1)
#   you can reject the null hypothesis that beta-1=0 due to the p-value for beta-1-hat being noticeably lower than 5% and close to zero

#Fit a least squares regression model called lm.fit.justx2 to predict y using only x2. 
lm.fit.justx2 = lm(y~x2)
summary(lm.fit.justx2)
#   you can reject the null hypothesis that beta-2=0 due to the p-value being noticeably lower than 5% and close to zero

#Do the results obtained in j)-m) contradict the results obtained in f)-i)? Explain your answer.
#   No these results do not contradict each other. It becomes difficult to establish linear relationships when several predictors are taken together. By seperating them and evaluating pairs the relationships between sets can be better observed.
#Add a point
x1=c(x1 , 0.1)
x2=c(x2 , 0.8)
y=c(y,6)
#Re-fit the linear models from f)-m) using this new data
lm.fit<- lm(y~x1+x2)
#Display the values of beta-0-hat, beta-1-hat, and beta-2-hat.
coef(lm.fit)
summary(lm.fit)
#   statistically these values are further from the original beta values. The std error rates have decreased though.
#Can you reject the null hypothesis H0: beta-1 = 0? How about the null hypothesis H0: beta-2 = 0? Explain how you arrived at this conclusion
#   we reject the null hypothesis for beta-1=0 due to its p-value being below 5%. We cannot reject the null hypothesis for beta-2 because its p-value is greater than 5%, though it is much closer to 5% this time around
lm.fit.justx1 = lm(y~x1)
summary(lm.fit.justx1)
lm.fit.justx2 = lm(y~x2)
summary(lm.fit.justx2)
#   this new observation effects the lm.fit model by increasing the significance of the p-value of beta-2
#   it effects the second and third models by adjusting their estimates, but their p-values remain below 5%
par(mfrow=c(2,2))
plot(lm.fit) #here we see that point 101 is high leverage, and possibly an outlier
par(mfrow=c(2,2))
plot(lm.fit.justx1) #point 101 is not necessarily high leverage here
par(mfrow=c(2,2))
plot(lm.fit.justx2) #here we see that point 101 is a high leverage point


#####################
#### QUESTION 3 #####
#####################
#insert function citation: http://stackoverflow.com/questions/18951248/insert-elements-in-a-vector-in-r
insert.at <- function(a, pos, ...){
  dots <- list(...)
  stopifnot(length(dots)==length(pos))
  result <- vector("list",2*length(pos)+1)
  result[c(TRUE,FALSE)] <- split(a, cumsum(seq_along(a) %in% (pos+1)))
  result[c(FALSE,TRUE)] <- dots
  unlist(result)
}

library(MASS)
set.seed(5072)
attach(Boston)
tbl<-matrix(ncol=5)
#change graphics window up here and plot while for loop runs
par(mfrow=c(3,4))
models<-c("crim~zn","crim~indus","crim~chas","crim~nox", "crim~age", "crim~dis", "crim~rad","crim~tax","crim~ptratio","crim~black","crim~medv","crim~lstat")
for(item in models){
  fit <-lm(paste(item))
  tbl<-rbind(tbl,c(item, summary(fit)$fstatistic[1],anova(fit)$`Pr(>F)`[1], coef(fit)))
  if(anova(fit)$`Pr(>F)`[1] < 0.05){
    plot(fit)
  }
}
#hard add the rm to avoid errors
lm.crim_rm<-lm(crim~rm)
tbl<-rbind(tbl,c("crim~rm", summary(lm.crim_rm)$fstatistic[1],anova(lm.crim_rm)$`Pr(>F)`[1], coef(lm.crim_rm)))
plot(lm.crim_rm)
tbl
#In which of the models is there a statistically significant association between the predictor and the response?
#   There is a statistically significant association between the predictor and the response between all of them except for chas
par(mfrow=c(1,1))
#Fit a multiple regression model to predict the response using all of the predictors. 
lm.all = lm(crim~., data=Boston)
data_matrix<-coef(summary(lm.all))
data_matrix[data_matrix[,4]<0.05,,drop=FALSE]
# Compare your results from (a) to your results from (d)
#create a vector to hold all the x_values
vars = labels(Boston)[[2]][2:14]
x_vals=c()
for(item in vars){
  if (item!=vars[5]){
    x=coef(lm(paste("crim~",item)))[2]
    x_vals<-c(x_vals,x)
  }
}
#hard insert rm coeff at position 5
addition = coef(lm(crim~rm))[2]
x_vals<-insert.at(x_vals, c(5), addition)
y_vals<-coef(lm.all)[2:14]
plot(x_vals,y_vals)

#Use this plot to comment on the level of agreement between the simple and multiple regression approaches. Which approach produces the most accurate reflection of the population parameters

#Is there evidence of non-linear association between any of the predictors and the response? 
poly_models = list()
models = list()
num=1
tbl<-matrix(ncol=3)
for(item in vars){
  #chas will be unincluded since it only has two unique points
  if(item!="chas" & item!="rm"){
  fit<-lm(paste("crim~poly(",item,",3)"))
  poly_models<-c(poly_models,list(fit))
  sapply(poly_models,class)
  
  #create list of models down here, probably should have done it this way up top, but im not about to fix what doesnt appear to be broke
  fit<-lm(paste("crim~",item))
  models<-c(models,list(fit))
  sapply(models,class)
  
  #item_row<-c(item, anova(models[[num]],poly_models[[num]])$F[2], anova(models[[num]],poly_models[[num]])$`Pr(>F)`[2])
  tbl<-rbind(tbl,c(item, anova(models[[num]],poly_models[[num]])$F[2], anova(models[[num]],poly_models[[num]])$`Pr(>F)`[2]))
  num = num + 1
  }
}
#hard add rm statistics
fit<-lm(crim~poly(rm,3))
poly_models<-c(poly_models,list(fit))
sapply(poly_models,class)

fit<-lm(crim~rm)
models<-c(models,list(fit))
sapply(models,class)

#item_row<-c("rm", anova(models[[num]],poly_models[[num]])$F[2], anova(models[[num]],poly_models[[num]])$`Pr(>F)`[2])
tbl<-rbind(tbl,c("rm", anova(models[[num]],poly_models[[num]])$F[2], anova(models[[num]],poly_models[[num]])$`Pr(>F)`[2]))
tbl<-as.table(tbl)
colnames(tbl)<-c("predictor","fstat","pvalueofFstat")
tbl[order(-as.double(tbl[,2])),]
#we can reject the null hyptothesis that there is no difference between the fit of the two models for all of the predictors except for black and chas. black is above 0.05 and chas is not charted

