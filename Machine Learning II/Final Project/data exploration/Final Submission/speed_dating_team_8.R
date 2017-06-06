#Team 8 Speed Dating Data Evaluation
# Load the data -- make sure you have set your WD properly
speed_datingdataset <- read.csv("pca_addon_dataset.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

# Transform specified variables into a factors.
#----------------------------------------------
speed_datingdataset[["TFC_samerace"]] <- as.factor(speed_datingdataset[["samerace"]])
speed_datingdataset[["TFC_f_field_num"]] <- as.factor(speed_datingdataset[["f_field_num"]])
speed_datingdataset[["TFC_f_race"]] <- as.factor(speed_datingdataset[["f_race"]])
speed_datingdataset[["TFC_f_goal"]] <- as.factor(speed_datingdataset[["f_goal"]])
speed_datingdataset[["TFC_f_dat_freq"]] <- as.factor(speed_datingdataset[["f_dat_freq"]])
speed_datingdataset[["TFC_f_out_freq"]] <- as.factor(speed_datingdataset[["f_out_freq"]])
speed_datingdataset[["TFC_m_field_num"]] <- as.factor(speed_datingdataset[["m_field_num"]])
speed_datingdataset[["TFC_m_race"]] <- as.factor(speed_datingdataset[["m_race"]])
speed_datingdataset[["TFC_m_goal"]] <- as.factor(speed_datingdataset[["m_goal"]])
speed_datingdataset[["TFC_m_dat_freq"]] <- as.factor(speed_datingdataset[["m_dat_freq"]])
speed_datingdataset[["TFC_m_out_freq"]] <- as.factor(speed_datingdataset[["m_out_freq"]])
ol <- levels(speed_datingdataset[["TFC_samerace"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_samerace"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_f_field_num"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_f_field_num"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_f_race"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_f_race"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_f_goal"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_f_goal"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_f_dat_freq"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_f_dat_freq"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_f_out_freq"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_f_out_freq"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_m_field_num"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_m_field_num"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_m_race"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_m_race"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_m_goal"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_m_goal"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_m_dat_freq"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_m_dat_freq"]]) <- nl

ol <- levels(speed_datingdataset[["TFC_m_out_freq"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(speed_datingdataset[["TFC_m_out_freq"]]) <- nl
#---------------------------------------------------------------------------------------------------
# Transform variables by rescaling.  The 'reshape' package provides the 'rescaler' function.
#----------------------------------------------------------------------------------------------------
# Rescale f_age.
speed_datingdataset[["R01_f_age"]] <- scale(speed_datingdataset[["f_age"]])
# Rescale f_imp_race.
speed_datingdataset[["R01_f_imp_race"]] <- scale(speed_datingdataset[["f_imp_race"]])
# Rescale f_imp_relig.
speed_datingdataset[["R01_f_imp_relig"]] <- scale(speed_datingdataset[["f_imp_relig"]])

# Rescale m_age.
speed_datingdataset[["R01_m_age"]] <- scale(speed_datingdataset[["m_age"]])
# Rescale m_imp_race.
speed_datingdataset[["R01_m_imp_race"]] <- scale(speed_datingdataset[["m_imp_race"]])
# Rescale m_imp_relig.
speed_datingdataset[["R01_m_imp_relig"]] <- scale(speed_datingdataset[["m_imp_relig"]])

#--------------------------------------------------------------------------
# Now we go on to building the models
#--------------------------------------------------------------------------
# Build the training/validate/test datasets.
set.seed(42) 
speed_datingnobs <- nrow(speed_datingdataset) # 4105 observations 
speed_datingsample <- speed_datingtrain <- sample(nrow(speed_datingdataset), 0.7*speed_datingnobs) # 2873 observations
speed_datingvalidate <- sample(setdiff(seq_len(nrow(speed_datingdataset)), speed_datingtrain), 0.15*speed_datingnobs) # 615 observations
speed_datingtest <- setdiff(setdiff(seq_len(nrow(speed_datingdataset)), speed_datingtrain), speed_datingvalidate) # 617 observations

# The following variables will actually be used for analysis. Pretty much just the averaged rating variables, recoded variables, and pcas
speed_datinginput <- c("f_avg_attr", "f_avg_sinc", "f_avg_fun", "f_avg_intel",
     "f_avg_amb", "m_avg_attr", "m_avg_sinc", "m_avg_fun",
     "m_avg_intel", "m_avg_amb", "f_pref_pca_vec_1", "f_pref_pca_vec_2",
     "f_pref_pca_vec_3", "f_oppgender_perception_pca_vec_1", "f_oppgender_perception_pca_vec_2", "f_self_perception_pca_vec_1",
     "f_self_perception_pca_vec_2", "f_self_perception_pca_vec_3", "f_self_perception_pca_vec_4", "f_interests_pca_vec_1",
     "f_interests_pca_vec_2", "f_interests_pca_vec_3", "f_interests_pca_vec_4", "f_interests_pca_vec_5",
     "f_interests_pca_vec_6", "f_interests_pca_vec_7", "f_interests_pca_vec_8", "f_interests_pca_vec_9",
     "f_interests_pca_vec_10", "f_interests_pca_vec_11", "m_pref_pca_vec_1", "m_pref_pca_vec_2",
     "m_pref_pca_vec_3", "m_oppgender_perception_pca_vec_1", "m_oppgender_perception_pca_vec_2", "m_oppgender_perception_pca_vec_3",
     "m_self_perception_pca_vec_1", "m_self_perception_pca_vec_2", "m_self_perception_pca_vec_3", "m_self_perception_pca_vec_4",
     "m_interests_pca_vec_1", "m_interests_pca_vec_2", "m_interests_pca_vec_3", "m_interests_pca_vec_4",
     "m_interests_pca_vec_5", "m_interests_pca_vec_6", "m_interests_pca_vec_7", "m_interests_pca_vec_8",
     "m_interests_pca_vec_9", "m_interests_pca_vec_10", "m_interests_pca_vec_11", "TFC_samerace",
     "TFC_f_field_num", "TFC_f_race", "TFC_f_goal", "TFC_f_dat_freq",
     "TFC_f_out_freq", "TFC_m_field_num", "TFC_m_race", "TFC_m_goal",
     "TFC_m_dat_freq", "TFC_m_out_freq", "R01_f_age", "R01_f_imp_race",
     "R01_f_imp_relig", "R01_m_age", "R01_m_imp_race", "R01_m_imp_relig")
speed_datingtarget1="male_dec"

#-------------------------------------------------------------------------
# Build a Decision Tree for males and females
#-------------------------------------------------------------------------
library(rpart, quietly=TRUE)
library(rpart.plot)
#require(rattle)
set.seed(42)
# Build the Decision Tree model.
speed_datingrpart <- rpart(male_dec ~ .,
    data=speed_datingdataset[speed_datingtrain, c(speed_datinginput, speed_datingtarget1)],
    method="class",
    parms=list(split="information"),
      control=rpart.control(cp=0.005000,
        usesurrogate=0, 
        maxsurrogate=0))
#Examine results from the tree
print(speed_datingrpart)
printcp(speed_datingrpart)
# Plot the resulting Decision Tree. 
#fancyRpartPlot(speed_datingrpart, main="Decision Tree male_dec")

#--------------------------------------------------------------------------
# Build a Random Forest for male decision and female decision
#--------------------------------------------------------------------------
library(randomForest, quietly=TRUE)
set.seed(42)
# Build the Random Forest model for males
speed_datingrf <- randomForest::randomForest(as.factor(male_dec) ~ .,
      data=speed_datingdataset[speed_datingsample,c(speed_datinginput, speed_datingtarget1)], 
      ntree=800,
      mtry=30,
      importance=TRUE,
      na.action=randomForest::na.roughfix,
      replace=FALSE)

#Examine results from the tree
speed_datingrf
rn <- round(randomForest::importance(speed_datingrf), 2)
rn[order(rn[,3], decreasing=TRUE),]

#---------------------------------------------------------------------
# Boosting Tree w/ Ada Boost 
#---------------------------------------------------------------------
# Build the Ada Boost model for males
set.seed(42)
speed_datingada <- ada::ada(male_dec ~ .,
                    data=speed_datingdataset[speed_datingtrain,c(speed_datinginput, speed_datingtarget1)],
                    control=rpart::rpart.control(maxdepth=30,
                                                 cp=0.001000,
                                                 minsplit=20,
                                                 xval=10),
                    iter=420)

# Examine results from the tree
print(speed_datingada)
round(speed_datingada$model$errs[speed_datingada$iter,], 2)
#cat('Variables actually used in tree construction:\n')
#print(sort(names(listAdaVarsUsed(speed_datingada))))
#cat('\nFrequency of variables actually used:\n')
#print(listAdaVarsUsed(speed_datingada))

#--------------------------------------------------------------------
# Support vector machine w/ ksvm (Rattle). 
#--------------------------------------------------------------------
library(kernlab, quietly=TRUE)
# Build a Support Vector Machine model for males
set.seed(42)
speed_datingksvm <- ksvm(as.factor(male_dec) ~ .,
      data=speed_datingdataset[speed_datingtrain,c(speed_datinginput, speed_datingtarget1)],
      kernel="rbfdot",
      prob.model=TRUE)
speed_datingksvm

#-----------------------------------------------------------------
# Evaluate model performances. 
#----------------------------------------------------------------
# Generate the confusion matrix showing proportions.
pcme <- function(actual, cl)
{
  x <- table(actual, cl)
  nc <- nrow(x) # Number of classes.
  nv <- length(actual) - sum(is.na(actual) | is.na(cl)) # Number of values.
  tbl <- cbind(x/nv,
               Error=sapply(1:nc,
                 function(r) round(sum(x[r,-r])/sum(x[r,]), 2)))
  names(attr(tbl, "dimnames")) <- c("Actual", "Predicted")
  return(tbl)
}
# Generate an Error Matrix for the Decision Tree model
speed_datingpr <- predict(speed_datingrpart, newdata=speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)], type="class")
# Generate the confusion matrix showing counts.
table(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$male_dec, speed_datingpr,
        useNA="ifany",
        dnn=c("Actual", "Predicted"))

per <- pcme(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$male_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the Ada Boost model.
speed_datingpr <- predict(speed_datingada, newdata=speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])
# Generate the confusion matrix showing counts.
table(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$male_dec, speed_datingpr,
        useNA="ifany",
        dnn=c("Actual", "Predicted"))

# Generate the confusion matrix showing proportions.
per <- pcme(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$male_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the Random Forest model.
speed_datingpr <- predict(speed_datingrf, newdata=na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]))
# Generate the confusion matrix showing counts.
table(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$male_dec, speed_datingpr,
        useNA="ifany",
        dnn=c("Actual", "Predicted"))
# Generate the confusion matrix showing proportions.
per <- pcme(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$male_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the SVM model.
speed_datingpr <- kernlab::predict(speed_datingksvm, newdata=na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]))
# Generate the confusion matrix showing counts.
table(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$male_dec, speed_datingpr,
        useNA="ifany",
        dnn=c("Actual", "Predicted"))
# Generate the confusion matrix showing proportions.
per <- pcme(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$male_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


speed_datingtarget1="female_dec"
#-------------------------------------------------------------------------
# Build a Decision Tree for males and females
#-------------------------------------------------------------------------
library(rpart, quietly=TRUE)
library(rpart.plot)
#require(rattle)
set.seed(42)
# Build the Decision Tree model.
speed_datingrpart <- rpart(female_dec ~ .,
                           data=speed_datingdataset[speed_datingtrain, c(speed_datinginput, speed_datingtarget1)],
                           method="class",
                           parms=list(split="information"),
                           control=rpart.control(cp=0.005000,
                                                 usesurrogate=0, 
                                                 maxsurrogate=0))
#Examine results from the tree
print(speed_datingrpart)
printcp(speed_datingrpart)
# Plot the resulting Decision Tree. 
#fancyRpartPlot(speed_datingrpart, main="Decision Tree female_dec")

#--------------------------------------------------------------------------
# Build a Random Forest for male decision and female decision
#--------------------------------------------------------------------------
library(randomForest, quietly=TRUE)
set.seed(42)
# Build the Random Forest model for males
speed_datingrf <- randomForest::randomForest(as.factor(female_dec) ~ .,
                                             data=speed_datingdataset[speed_datingsample,c(speed_datinginput, speed_datingtarget1)], 
                                             ntree=800,
                                             mtry=30,
                                             importance=TRUE,
                                             na.action=randomForest::na.roughfix,
                                             replace=FALSE)

#Examine results from the tree
speed_datingrf
rn <- round(randomForest::importance(speed_datingrf), 2)
rn[order(rn[,3], decreasing=TRUE),]

#---------------------------------------------------------------------
# Boosting Tree w/ Ada Boost 
#---------------------------------------------------------------------
# Build the Ada Boost model for males
set.seed(42)
speed_datingada <- ada::ada(female_dec ~ .,
                            data=speed_datingdataset[speed_datingtrain,c(speed_datinginput, speed_datingtarget1)],
                            control=rpart::rpart.control(maxdepth=30,
                                                         cp=0.001000,
                                                         minsplit=20,
                                                         xval=10),
                            iter=420)

# Examine results from the tree
print(speed_datingada)
round(speed_datingada$model$errs[speed_datingada$iter,], 2)
#cat('Variables actually used in tree construction:\n')
#print(sort(names(listAdaVarsUsed(speed_datingada))))
#cat('\nFrequency of variables actually used:\n')
#print(listAdaVarsUsed(speed_datingada))

#--------------------------------------------------------------------
# Support vector machine w/ ksvm (Rattle). 
#--------------------------------------------------------------------
library(kernlab, quietly=TRUE)
# Build a Support Vector Machine model for males
set.seed(42)
speed_datingksvm <- ksvm(as.factor(female_dec) ~ .,
                         data=speed_datingdataset[speed_datingtrain,c(speed_datinginput, speed_datingtarget1)],
                         kernel="rbfdot",
                         prob.model=TRUE)
speed_datingksvm

#-----------------------------------------------------------------
# Evaluate model performances. 
#----------------------------------------------------------------
# Generate the confusion matrix showing proportions.
pcme <- function(actual, cl)
{
  x <- table(actual, cl)
  nc <- nrow(x) # Number of classes.
  nv <- length(actual) - sum(is.na(actual) | is.na(cl)) # Number of values.
  tbl <- cbind(x/nv,
               Error=sapply(1:nc,
                            function(r) round(sum(x[r,-r])/sum(x[r,]), 2)))
  names(attr(tbl, "dimnames")) <- c("Actual", "Predicted")
  return(tbl)
}
# Generate an Error Matrix for the Decision Tree model
speed_datingpr <- predict(speed_datingrpart, newdata=speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)], type="class")
# Generate the confusion matrix showing counts.
table(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$female_dec, speed_datingpr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))

per <- pcme(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$female_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the Ada Boost model.
speed_datingpr <- predict(speed_datingada, newdata=speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])
# Generate the confusion matrix showing counts.
table(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$female_dec, speed_datingpr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))

# Generate the confusion matrix showing proportions.
per <- pcme(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]$female_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the Random Forest model.
speed_datingpr <- predict(speed_datingrf, newdata=na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]))
# Generate the confusion matrix showing counts.
table(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$female_dec, speed_datingpr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))
# Generate the confusion matrix showing proportions.
per <- pcme(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$female_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))


# Generate an Error Matrix for the SVM model.
speed_datingpr <- kernlab::predict(speed_datingksvm, newdata=na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)]))
# Generate the confusion matrix showing counts.
table(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$female_dec, speed_datingpr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))
# Generate the confusion matrix showing proportions.
per <- pcme(na.omit(speed_datingdataset[speed_datingtest, c(speed_datinginput, speed_datingtarget1)])$female_dec, speed_datingpr)
round(per, 2)
# Calculate the overall error percentage.
cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))
}