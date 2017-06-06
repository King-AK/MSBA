#VJ Davey
#ISLR 7.8 Lab
#non-linear modeling
rm(list = ls())
library(ISLR)
attach(Wage)
#Going to analyze the Wage data in order to illustrate that nonlinear fitting procedures can be easly implemented in R

### 7.8.1 Polynomial Regression and Step Functions
fit = lm(wage~poly(age,4),data=Wage)
summary(fit)
coef(summary(fit))
#above: a linear model has been fit using the lm() function in order to predict wage using a 4th degree polynomial. 

#poly() allows us to avoid writing out a long formula with powers of age. 
#the poly() function returns a matrix whose columns are a basis of orthogonal polynomials, which essentially means that each column is a linear combination of the variables age, age^2, age^3, and age^4
#we can use poly() to obtain age, age2, age^3, and age^4 directly by using the raw=TRUE argument 
fit2=lm(wage~poly(age,4,raw=TRUE), data=Wage)
coef(summary(fit2))

#there are several other equivalent ways of fitting this model, which showcase the flexibility of the formula language
#for example:
fit2a=lm(wage~age+I(age^2)+I(age^3)+I(age^4), data=Wage)
coef(fit2a)
#the above simiply creates the polynomial basis functions on the fly, taking care to protect terms like age^2 via the wrapper function I()
#the following will do the same, though more compactly, by using the cbind() function for building a matrix from a collection of vectors
fit2b=lm(wage~cbind(age,age^2,age^3,age^4),data=Wage)

#we now create a grid of values for age at which we want predcitions for wage, and then call predict()
agelims=range(age)
age.grid=seq(from=agelims[1],to=agelims[2])
preds=predict(fit,newdata=list(age=age.grid),se=TRUE)
se.bands=cbind(preds$fit+2*preds$se.fit,preds$fit-2*preds$se.fit)
#finally, we plot the data and add the fit from the degree-4 polynomial
par(mfrow=c(1,2),mar=c(4.5,4.5,1,1), oma=c(0,0,4,0))
plot(age,wage,xlim=agelims,cex=.5,col="darkgrey")
title("Degree-4 Polynomial", outer=T)
lines(age.grid,preds$fit,lwd=2, col="blue")
matlines(age.grid,se.bands,lwd=1,col="blue",lty=3)
#mar and oma arguments allow us to control the margins of the plot
#title function creates a figure title that spans both subplots

#In performing a polynomial regression, we must decide on the degree of the polynomial to use. We can do this using hypothesis tests. We can fit models ranging from linear to degree-p and seek to determine te simplest model which is sufficient to explain the relationship between Wage and Age. 
#we use the anova() function to perform an analysis of variance (ANOVA using an f-test) in order to test the null hypothesis that a model M1 is sufficient to explain the data against the hypothesis that a more complex model M2 is required
#in order to use anova() M1 and M2 must be nested models: the predeictors in M1 must be a subset of the predictors in M2
#in this case, we fit five different models and sequentially compare the simpler model to the more complex model
fit.1=lm(wage~age,data=Wage)
fit.2=lm(wage~poly(age,2),data=Wage)
fit.3=lm(wage~poly(age,3),data=Wage)
fit.4=lm(wage~poly(age,4),data=Wage)
fit.5=lm(wage~poly(age,5),data=Wage)
anova(fit.1,fit.2,fit.3,fit.4,fit.5)
#the p=value comparing the linear model 1 to the quadratic model 2 is essentially 0, indicating that a linear fit is not sufficient
#the p-value comparing the quadratic model 2 to the cubic model 3 is also very low, so the quadratic fit is insufficient
#quartic is around 5%
#quintic is way too much
#So either a cubic or quartic model give the most reasonable fit to the data, but higher or lower order models are not justified via ANOVA
#as an alternative to using hypothesis tests and ANOVA, we could choose polynomial degree using Cross Validation

#we can also do classification much in the same way. We make sure we have an appropriate response vector and then apply the glm() function using the appropriate family (binomial, multinomial) in order to fit a polynomial logistic regression model
fit=glm(I(wage>250)~poly(age,4), data=Wage,family=binomial)
preds=predict(fit,newdata=list(age=age.grid),se=TRUE)
#calculating the confidence intervals is more involved than in the linear regression case. 
pfit=exp(preds$fit)/(1+exp(preds$fit))
se.bands.logit = cbind(preds$fit +2* preds$se.fit , preds$fit-2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit))
#plot the fit
plot(age,I(wage>250),xlim=agelims,type="n",ylim=c(0,0.2))
points(jitter(age), I((wage>250)/5), cex=.5, pch="|", col="darkgrey")
lines(age.grid,pfit,lwd=2,col="blue")
matlines(age.grid, se.bands,lwd=1,col="blue",lty=3)
#step functions

###7.8.2 Splines
#regression splines can be fit by constructing an appropriate matrix of basis functions
#the bs() function generates the entire matrix of basis functions for splines with the specified set of knots. By default, cubic splines are produced. 
library(splines)
fit <- lm(wage ~ bs(age, knots = c(25, 40, 60)), data = Wage)
pred <- predict(fit, newdata = list(age = age.grid), se = TRUE)
plot(age, wage, col = "gray")
lines(age.grid, pred$fit, lwd = 2)
lines(age.grid, pred$fit + 2*pred$se, lty = "dashed")
lines(age.grid, pred$fit - 2*pred$se, lty = "dashed")
#we specified knots at ages 25, 40 and 60. This produces a spline with six basis functions. 
#we could also use the df() function to produce a spline with knots at uniform quantiles of the data
dim(bs(age,knots=c(25,40,60)))
dim(bs(age,df=6))
attr(bs(age,df=6),"knots")
#In this case, R would choose knots at 33.8, 42.0 and 51.0, which correspond to the 25th, 50th and 75th percentiles of age
#the bs() function also has a degree argument, so we can fit splines of any degree, rather than the default of 3 for cubic splines

#in order to fit a natural spline, we use the ns() function
fit2=lm(wage~ns(age,df=4),data=Wage)
pred2=predict(fit2,newdata=list(age=age.grid),se=TRUE)
lines(age.grid,pred2$fit,col="red",lwd=2)
#as with the bs() function we could instead specify the knots directly using the knots option

#in order to fit a smoothing spline, we use the smooth.spline() function
plot(age,wage,xlim=agelims,cex=.5,col="darkgrey")
title("Smoothing Spline")
fit=smooth.spline(age,wage,df=16)
fit2=smooth.spline(age,wage,cv=TRUE)
fit2$df
lines(fit,col="red",lwd=2)
lines(fit2,col="blue",lwd=2)
legend("topright",legend=c("16 DF", "6.8 DF"), col=c("red","blue"),lty=1,lwd=2,cex=.8)
#in the first call of smooth.spline() we specified the df as being 16
#in the second call to smooth.spline() we selected the smoothness level with cross validation, yielding a lambda value that yields 6.8 degrees of freedom

#in order to perform local regression we use the loess() function
plot(age,wage,xlim=agelims,cex=.5,col="darkgrey")
title("Local Regression")
fit=loess(wage~age,span=.2,data=Wage)
fit2=loess(wage~age,span=.5,data=Wage)
lines(age.grid,predict(fit,data.frame(age=age.grid)),col="red",lwd=2)
lines(age.grid,predict(fit2,data.frame(age=age.grid)),col="blue",lwd=2)
legend("topright",legend=c("Span=0.2","Span=0.5"),col=c("red","blue"),lty=1,lwd=2,cex=.8)
#we havev performed local regression using spans of 0.2 and 0.5: that is, each neighborhood consists of 20 or 50% of the observations. The larger the span, the smoother the fit. 
