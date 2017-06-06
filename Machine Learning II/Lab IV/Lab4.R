library(e1071)
library(ROCR)
library(ISLR)

###A
set.seed(5082)
n=dim(OJ)[1]
train_inds=sample(1:n,800)
test_inds=(1:n)[-train_inds]

#B
support = svm(Purchase~.,data=OJ[train_inds,], kernel="linear", cost=.01)
summary(support)
plot(support, OJ[train_inds,], PriceMM~PriceCH)

##C
pred = predict(support,newx=OJ[-train_inds,])
true=OJ[-train_inds,"Purchase"]
table(true,pred)
