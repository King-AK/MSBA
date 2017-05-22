#Big Data Assignment 4
#Insurance Dataset -- Predicting TARGET_FLAG and TARGET_AMT
# This assignment will require 3 models: 
#a regression and classification model for TARGET_FLAG 
#and a regression model for TARGET_AMT

###########################
####  GET THE DATA INTO R
###########################
#clear the environment
rm(list=ls())
#read in the insurance csv file
insurance_training_set <- read.csv("insurance-training-set.csv")

#observe the structure of the csv file
str(insurance_training_set) #there are 8161 observations of the 26 variables ; there are only 6045 complete obseravtions of the 26 variables -- will need to impute missing data
#specify which columns contain NA's and will require some kind of imputation
df_NA_status <- apply(insurance_training_set, 2, function(x) any(is.na(x)))
df_NA_cols <- df_NA_status[df_NA_status==TRUE]
cols_w_NAs<-names(df_NA_cols) #columns which need closer inspection/imputation are AGE, YOJ, INCOME, HOME_VAL, CAR_AGE
#check out what exactly is up with these missing columns. Print their target flag ratio among
for (col in cols_w_NAs){
  comand <- paste(sep="","table(insurance_training_set[which(is.na(insurance_training_set$",col,")),]$TARGET_FLAG)")
  comand2 <- paste(sep="","table(insurance_training_set[which(!is.na(insurance_training_set$",col,")),]$TARGET_FLAG)")
  missing_table <- eval(parse(text=comand))
  complete_table <- eval(parse(text=comand2))
  print(col)
  print(missing_table)
  print(complete_table)
}
#As we can see, all the variables except AGE seem to be about in porportion with each other, and there dont seem to be any weird numbers suggesting that the missing data is not in scale with the non-missing data. Its all in the same ballpark

#convert Age to factor, split into 5 year groups using cut()+NAs since R cannot handle vectors with over 53 classes
insurance_training_set$AGE = addNA((cut(insurance_training_set$AGE, c(0, seq(16, 81, by = 5), Inf))))
#ensure NAs from age wont ruin anything
levels(insurance_training_set$AGE)[is.na(levels(insurance_training_set$AGE))] <- "NA"

###########################
####  IMPUTING MISSING DATA
###########################

#For the remaining columns with missing information, we will do imputation
#http://www.stat.columbia.edu/~gelman/arm/missing.pdf
#https://www.r-bloggers.com/imputing-missing-data-with-r-mice-package/
#Data Imputation using the MICE package -- not going to reinvent the wheel here
if (!require('lattice')) install.packages('lattice'); library('lattice')
if (!require('mice')) install.packages('mice'); library('mice')
#initially, lets look at any pattens in the data with mice
md.pattern(insurance_training_set) 
#the pattern function also shows that the columns with missing data are AGE, YOJ, INCOME, HOME_VAL, and CAR_AGE. It also shows number of incidents where each variable is missing and incidents where pairs of variables are missing
#lets use mice() function to impute the missing data and see which method gives us the best imputed data
meths = c("mean","pmm","sample","cart","rf") #vector of the different imputation methods to loop through and consider for data imputation
for (meth in meths){
  tempData<-mice(insurance_training_set, m=5, meth=meth,seed=1738) #impute missing data with specified methods
  titleString <- paste("density distributions for", meth, " imputation")
  print(densityplot(tempData, main=titleString))
  Sys.sleep(1)
  print(meth)
}
##Select the best method from the for loop
#lets stick with the last one, random forest imputation

tempData$imp$YOJ #look at the imputed data for each missing observation of YOJ
impute_predictor_matrix<-tempData$predictorMatrix #hold on to this matrix so we can use it to impute test data as needed with the mice function
#tempData$pad$method #probably just pass in all the data from pad to the test set to impute the data
#temptest <- mice(insurance_test_set, m=1, meth="mean",predictorMatrix = tempData$predictorMatrix)
#complteTest<-complete(temptest)

###Rolling over the imputed data
### Create a new dataset which holds the original+new imputed data
completeInsuranceData <-complete(tempData,action=1) #the missing values are replaced with imputed values in the imputed dataset specified by the second argument




###########################
####  UNSUPERVISED LEARNING EXAMINATION OF DATA
###########################

cID.examine <- completeInsuranceData #make a copy to use for unsupervised learning
#-- look for structure in the data or what clusters the data may break out into
#hiearchical clustering
if (!require('dendextend')) install.packages('dendextend'); library('dendextend')

#use index as an identifier for customers since its the closest thing we have to names/ID
rownames(cID.examine) = cID.examine$INDEX
#remove index column
cID.examine<-cID.examine[-1]
#scale numeric data
indices <- sapply(cID.examine, is.numeric)
cID.examine[indices] <- lapply(cID.examine[indices], scale)
#build hclust and dendrogram
hc.complete=hclust(dist(cID.examine), method="complete")
#dendrogram plotting function
plotDend <- function(hc.item, titlestring, numClust){
  dend <- hc.item
  #Note: k = number of clusters to color. 
  dend=color_branches(dend,k=numClust)
  dend=color_labels(dend,k=numClust)
  dend=set(dend, "branches_lwd",2) #makes the branches thicker 
  plot(dend, main = titlestring)
}
clusts=10
plotDend(hc.complete, "Insurance Data Dendrogram: first few rows", clusts)
#some extra oomph to let us know what these clusters are showing us
#determine how many observations are in each of the clusters
groups = cutree(hc.complete,clusts)
table(groups)
#cluster summary statistics for target_flag and target_amt
aggregate(cID.examine[1:2],list(groups), mean) #do a write up on the trends seen among clustered data points
#examine the data in the nonscaled datastructure
insurance_training_set[groups==7,]

###########################
####  PREPROCESSING
###########################
#create a preserved imputed df 
preservedImputed <- completeInsuranceData
library(caret)

#get rid of index column and scale non response variables which are numeric
completeInsuranceData = preservedImputed[,-1]
set.seed(1738)
#split training data into training and validation 
train = sample(1:nrow(completeInsuranceData), nrow(completeInsuranceData)*0.8)
insurance.test.target_flag=completeInsuranceData[-train,"TARGET_FLAG"]
insurance.test.target_amt=completeInsuranceData[-train,"TARGET_AMT"]

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=5) #should probably be higher, but I dont have the time to run this all day
# run the RFE algorithm for each type of model we will be building to automate predictor selection
results.target_flag.classification <- rfe(x=completeInsuranceData[train,3:25], y=as.factor(completeInsuranceData[train,"TARGET_FLAG"]), sizes=c(1:22), rfeControl=control)#, testX=completeInsuranceData[-train,3:25], testY=as.factor(completeInsuranceData[-train,"TARGET_FLAG"]) )
results.target_flag.regression <- rfe(x=completeInsuranceData[train,3:25], y=completeInsuranceData[train,"TARGET_FLAG"], sizes=c(1:22), rfeControl=control)#, testX=completeInsuranceData[-train,3:25], testY=completeInsuranceData[-train,"TARGET_FLAG"])
results.target_amt.regression <- rfe(x=completeInsuranceData[train,3:25], y=completeInsuranceData[train,"TARGET_AMT"], sizes=c(1:22), rfeControl=control)#, testX=completeInsuranceData[-train,3:25], testY=y=completeInsuranceData[-train,"TARGET_AMT"])

# summarize the results for each
print(results.target_flag.classification)
print(results.target_flag.regression)
print(results.target_amt.regression)

# list the chosen features
predictors(results.target_flag.classification)
predictors(results.target_flag.regression)
predictors(results.target_amt.regression)

#list subsets for the dataframe for when we make predictive model
target_flag.classification.names<-c("TARGET_FLAG",predictors(results.target_flag.classification))
target_flag.regression.names<-c("TARGET_FLAG",predictors(results.target_flag.regression))
target_amt.regression.names<-c("TARGET_AMT",predictors(results.target_amt.regression))

# plot the results
plot(results.target_flag.classification, type=c("g", "o"), main="TARGET_FLAG classifier optimal num predictors")
plot(results.target_flag.regression, type=c("g", "o"), main="TARGET_FLAG regressor optimal num predictors")
plot(results.target_amt.regression, type=c("g", "o"), main="TARGET_AMT regressor optimal num predictors")




###########################
####  SUPERVISED LEARNING TRAINING AND TESTING ON TRAINING DATA
###########################

#after messing around in rattle, found that logistic regression tends to outperform randomforests or perform close enough with less type II error
library('randomForest')
set.seed(1738)
#build models not including the response variable not being predicted in the data
  #glm to classify TARGET_FLAG
glm.insurance.target_flag.classification = glm(as.factor(TARGET_FLAG)~.,data=completeInsuranceData[train,target_flag.classification.names], family=binomial)
  #glm to predict TARGET_FLAG likeliehood
glm.insurance.target_flag.regression = glm(TARGET_FLAG~.,data=completeInsuranceData[train,target_flag.regression.names], family=poisson)

# Inspect formula objects
glm.insurance.target_flag.classification
glm.insurance.target_flag.regression

#make predictions with models on scaled predictors
  #predict class for TARGET_FLAG
yhat.glm.target_flag.classification = predict(glm.insurance.target_flag.classifcation, newdata=completeInsuranceData[-train,target_flag.classification.names], type = 'response')#be sure to omit the response variables!
yhat.glm.target_flag.classification = ifelse(yhat.glm.target_flag.classification>0.5,1,0)
  #predict value for TARGET_FLAG likelihood
yhat.glm.target_flag.regression = predict(glm.insurance.target_flag.regression,newdata=completeInsuranceData[-train,target_flag.regression.names], type = 'response')
yhat.glm.target_flag.regression[yhat.glm.target_flag.regression>1]<-.99

  #rf to predict TARGET_AMT using predictions on TARGET_FLAG, as stated in the assignment instructions
temp_col<-completeInsuranceData[train,"TARGET_FLAG"]
rf.insurance.target_amt.regression = randomForest(TARGET_AMT~.,data=data.frame(temp_col,completeInsuranceData[train,target_amt.regression.names]), mtry=4, importance=TRUE)
  #Inspect rf object
rf.insurance.target_amt.regression

  #predict value for TARGET_AMT
temp_col<-yhat.glm.target_flag.classification
yhat.rf.target_amt.regression = predict(rf.insurance.target_amt.regression,newdata=data.frame(temp_col,completeInsuranceData[-train,target_amt.regression.names]))
yhat.rf.target_amt.regression[yhat.rf.target_amt.regression<0]<-0

#test accuracy with confusion matrix and MSE
#test accuracy of crasher classification, TARGET_FLAG -- confusion matrix
confusionMatrix.target_flag.classification = table(insurance.test.target_flag, yhat.glm.target_flag.classification, dnn=c("Actual","Predicted"))
confusionMatrix.target_flag.classification
percConfMatrx=round(100*confusionMatrix.target_flag.classification/length(yhat.glm.target_flag.classification), digits = 2)
percConfMatrx #look at associated percentages

#test accuracy of crasher probability, TARGET_FLAG -- MSE + MAE for more accurate read
mean((yhat.glm.target_flag.regression-insurance.test.target_flag)^2)
mean(abs(yhat.glm.target_flag.regression-insurance.test.target_flag))
#test accuracy of crash payout, TARGET_AMT -- MSE + MAE for a more accurate read
mean((yhat.rf.target_amt.regression-insurance.test.target_amt)^2)
mean(abs(yhat.rf.target_amt.regression-insurance.test.target_amt))
###########################
####  SUPERVISED LEARNING TESTING ON TEST DATA USING BUILT MODELS
###########################
insurance_test_set <- read.csv("insurance-test-set.csv")
#impute the set as needed using the established imputation model
  #first do conversions on age
insurance_test_set$AGE = addNA((cut(insurance_test_set$AGE, c(0, seq(16, 81, by = 5), Inf))))
levels(insurance_test_set$AGE)[is.na(levels(insurance_test_set$AGE))] <- "NA"
  #second impute with established method
temp_test_set <- mice(insurance_test_set, m=1, meth="rf",predictorMatrix = impute_predictor_matrix)
  #last, add imputed data to get a complete set to test with
complete_test_set<-complete(temp_test_set)

#make predictions using column subsets the models expect
  #predict class for TARGET_FLAG
yhat.glm.target_flag.classification = predict(glm.insurance.target_flag.classifcation, newdata=complete_test_set[,target_flag.classification.names], type = 'response')#be sure to omit the response variables!
yhat.glm.target_flag.classification = ifelse(yhat.glm.target_flag.classification>0.5,1,0)
  #predict value for TARGET_FLAG likelihood
yhat.glm.target_flag.regression = predict(glm.insurance.target_flag.regression,newdata=complete_test_set[,target_flag.regression.names], type = 'response')
yhat.glm.target_flag.regression[yhat.glm.target_flag.regression>1]<-.99 #topcode values where it appears a person is incredibly likely to crash


  #predict value for TARGET_AMT -- dependent on the predictions before it
temp_col<-yhat.glm.target_flag.classification
yhat.rf.target_amt.regression = predict(rf.insurance.target_amt.regression,newdata=data.frame(temp_col,complete_test_set[,target_amt.regression.names]))
yhat.rf.target_amt.regression[yhat.rf.target_amt.regression<0]<-0

predictions <- data.frame(yhat.glm.target_flag.regression,yhat.glm.target_flag.classification,yhat.rf.target_amt.regression)
write.csv(file="predictions.csv",x=predictions)
