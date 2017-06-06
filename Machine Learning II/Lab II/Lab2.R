#VJ Davey
#Lab 2 MLII
rm(list=ls())

###Objectives
#Excercise recently developed skills in Polynomial Regression, Step Functions and Basis Functions, Regression Splines, Smoothing Splines, and Local Regression

#####################
#### SECTION 1   ####
#####################
#Further analyze Wage data set
library(ISLR)
library(boot)
library(ggplot2)
attach(Wage)

#perform POLYNOMIAL REGRESSION to predict Wage using age with polynomial degrees from 1 to 10
for(d in 1:10){
  fit = lm(wage~poly(age,d),data=Wage)
  print(paste("Looking at polynomial regressionw ith degree", d))
  print(summary(fit))
}
#set seed and use CV to select the optimal degree d for the polynomial
set.seed(5082)
degree=1:10
cv.error=rep(NA,10)
for(d in degree){
  glm.fit = glm(wage~poly(age, d), data=Wage)
  cv.error[d] = cv.glm(Wage,glm.fit,K=10)$delta[1]
}
#best degree
best_degree=which.min(cv.error)
paste("The degree chosen was", best_degree)
#plot the resulting polynomial fit and the original data
wage_plot<-ggplot(Wage,aes(x=age,y=wage))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Polynomial Fit with Degree", best_degree ,"Chosen by C.V."))
wage_plot+stat_smooth(method = 'lm', formula = y ~ poly(x,degree[which.min(cv.error)]), colour =c("red"),se= FALSE)

#fit a STEP FUNCTION to predict wage using age(use the cut() function)
#set seed and then investigate step functions using steps from 1 to 12. Use 10-fold CV to choose the optimal number of steps
set.seed(5082)
steps=1:12
cv.error=rep(NA,12)
for(s in steps){
  Wage$age.cut = cut(age,s+1)
  glm.fit = glm(wage ~ age.cut, data=Wage)
  cv.error[s] = cv.glm(Wage,glm.fit,K=10)$delta[1]
}
#optimal number of steps
best_steps=which.min(cv.error)
paste("The optimal number of steps is",best_steps)
paste("The optimal number of cuts is",best_steps+1)
wage_plot<-ggplot(Wage,aes(x=age,y=wage))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Step Function Using Number of Steps(", best_steps+1,")Chosen with C.V."))
wage_plot+stat_smooth(method = 'lm', formula = y ~ cut(x,best_steps+1), colour =c("red"),se= FALSE)

#####################
#### SECTION 2   ####
#####################
#Use Boston Data to do some spline work
library(MASS)
#use poly() to fit a cubic polynomical regression to predict nox using dis
fit=lm(nox~poly(dis,3),data=Boston)
#plot the data and the resulting polynomial fit
nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Plot of Cubic Polynomial Regression to Predict nox using dis"))
nox_plot+stat_smooth(method = 'lm', formula = y~poly(x,3), colour =c("red"),se= FALSE)

#plot the polynomial fits for polynomial degrees from 1 to 10
degree=1:10
colorvec=rainbow(10)
nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
  ylim(0.38,max(Boston$nox))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Polynomial fit with various degrees of freedom"))
#build polynomial fit eval String **Figure out why ggplot cant plot these polynomial fits in a normal for loop
evalString<-"nox_plot<-nox_plot"
#create RSS vector
RSS<-rep(NA,10)
for(d in degree){
  fit<-lm(nox~poly(dis,d),data=Boston)
  RSS[d]<-sum(resid(fit)^2)
  evalString<-paste(evalString,"+ stat_smooth(method = 'lm', formula = y ~ poly(x,",d,"), colour = colorvec[",d,"],se= FALSE,show.legend=TRUE)")
}
print(eval(parse(text=evalString))) #legend is becoming a problem here
#report the associated RSSs in a table
RSStable<-data.frame(degree,RSS)
RSStable


#set seed to 5082 then perform CV to select the optimal degree for the polynomial 
set.seed(5082)
degree=1:10
cv.error=rep(NA,10)
for(d in degree){
  glm.fit = glm(nox~poly(dis, d), data=Boston)
  cv.error[d] = cv.glm(Boston,glm.fit,K=10)$delta[1]
}
#plot the resulting fit with the data
nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Polynomial fit with min cv error"))
nox_plot+stat_smooth(method = 'lm', formula = y ~ poly(x,degree[which.min(cv.error)]), colour =c("red"),se= FALSE)

#use bs() function to fit a regression spline to predict nox using dis, requesting 4 degrees of freedom
fit <- lm(nox ~ bs(dis, df = 4), data = Boston)
#report output for the fit 
summary(fit)
attr(bs(dis,df=4),"knots")
#knots were chosen using f-statitics
#knot was placed at 3.2
nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Spline fit with 4 DF"))
nox_plot+stat_smooth(method = 'lm', formula = y ~ bs(x, df = 4), colour =c("red"),se= FALSE)


#Fit regression splien for a range of df from 1 to 10, plot the resulting fits and report associated RSSs in a table
#create RSS vector
RSS<-rep(NA,10)
#run spline loop
for(d in degree){
  fit<-lm(nox ~ bs(dis, df = d), data = Boston)
  RSS[d]<-sum(resid(fit)^2)
  nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
    geom_point(shape=1,size=2, col="black")+
    ggtitle(paste("Spline fit with", d,"DF"))
  print(nox_plot+stat_smooth(method = 'lm', formula = y ~ bs(x, df = d), colour =c("red"),se= FALSE))
}
#report RSS table
RSStable<-data.frame(degree,RSS)
RSStable
#Set seed and perform 10-fold CV to select the best DF from 3 to 10
set.seed(5082)
for(d in 3:10){
  glm.fit = glm(nox ~ bs(dis, df = d), data = Boston)
  cv.error[d] = cv.glm(Boston,glm.fit,K=10)$delta[1]
}
best_df<-which.min(cv.error)
#plot the best one
nox_plot<-ggplot(Boston,aes(x=dis,y=nox))+
  geom_point(shape=1,size=2, col="black")+
  ggtitle(paste("Polynomial Regression Spline with Best DF(",best_df,")chosen with CV"))
nox_plot+stat_smooth(method = 'lm', formula = y ~ bs(x, df = best_df), colour =c("red"),se= FALSE)

