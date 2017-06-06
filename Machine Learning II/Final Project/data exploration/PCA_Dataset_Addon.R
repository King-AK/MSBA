#make sure WD is set to file location
#load in the dataset
dataset <- read.csv("Copy of speeddating_April_13_with_avg.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

#specify roles for each variable
input_vars <- c("order", "interest_corr", "samerace", "f_est_matches",
                "f_age", "f_field", "f_field_num", "f_race",
                "f_imp_race", "f_imp_relig", "f_goal", "f_dat_freq",
                "f_out_freq", "f_career", "f_career_num", "f_like_sports",
                "f_like_tvsports", "f_like_exercise", "f_like_dining", "f_like_museums",
                "f_like_art", "f_like_hiking", "f_like_gaming", "f_like_clubbing",
                "f_like_reading", "f_like_tv", "f_like_theater", "f_like_movies",
                "f_like_concerts", "f_like_music", "f_like_shopping", "f_like_yoga",
                "f_exp_happy", "f_pref_attr", "f_pref_sinc", "f_pref_intel",
                "f_pref_fun", "f_pref_amb", "f_pref_shar", "f_genderpref_attr",
                "f_genderpref_sinc", "f_genderpref_intel", "f_genderpref_fun", "f_genderpref_amb",
                "f_genderpref_shar", "f_oppgender_pref_attr", "f_oppgender_pref_sinc", "f_oppgender_pref_intel",
                "f_oppgender_pref_fun", "f_oppgender_pref_amb", "f_oppgender_pref_shar", "f_rate_self_attr",
                "f_rate_self_sinc", "f_rate_self_fun", "f_rate_self_intel", "f_rate_self_amb",
                "f_avg_attr", "f_avg_sinc", "f_avg_fun", "f_avg_intel",
                "f_avg_amb", "f_avg_like", "m_est_matches", "m_age",
                "m_field", "m_field_num", "m_race", "m_imp_race",
                "m_imp_relig", "m_goal", "m_dat_freq", "m_out_freq",
                "m_career", "m_career_num", "m_like_sports", "m_like_tvsports",
                "m_like_exercise", "m_like_dining", "m_like_museums", "m_like_art",
                "m_like_hiking", "m_like_gaming", "m_like_clubbing", "m_like_reading",
                "m_like_tv", "m_like_theater", "m_like_movies", "m_like_concerts",
                "m_like_music", "m_like_shopping", "m_like_yoga", "m_exp_happy",
                "m_pref_attr", "m_pref_sinc", "m_pref_intel", "m_pref_fun",
                "m_pref_amb", "m_pref_shar", "m_gender_pref_attr", "m_gender_pref_sinc",
                "m_gender_pref_intel", "m_gender_pref_fun", "m_gender_pref_amb", "m_gender_pref_shar",
                "m_opp_gender_pref_attr", "m_opp_gender_pref_sinc", "m_opp_gender_pref_intel", "m_opp_gender_pref_fun",
                "m_opp_gender_pref_amb", "m_opp_gender_pref_shar", "m_rate_self_attr", "m_rate_self_sinc",
                "m_rate_self_fun", "m_rate_self_intel", "m_rate_self_amb", "m_avg_attr",
                "m_avg_sinc", "m_avg_fun", "m_avg_intel", "m_avg_amb",
                "m_avg_like")
numeric_vars<-c("order", "interest_corr", "samerace", "f_est_matches",
                "f_age", "f_field_num", "f_race", "f_imp_race",
                "f_imp_relig", "f_goal", "f_dat_freq", "f_out_freq",
                "f_career_num", "f_like_sports", "f_like_tvsports", "f_like_exercise",
                "f_like_dining", "f_like_museums", "f_like_art", "f_like_hiking",
                "f_like_gaming", "f_like_clubbing", "f_like_reading", "f_like_tv",
                "f_like_theater", "f_like_movies", "f_like_concerts", "f_like_music",
                "f_like_shopping", "f_like_yoga", "f_exp_happy", "f_pref_attr",
                "f_pref_sinc", "f_pref_intel", "f_pref_fun", "f_pref_amb",
                "f_pref_shar", "f_genderpref_attr", "f_genderpref_sinc", "f_genderpref_intel",
                "f_genderpref_fun", "f_genderpref_amb", "f_genderpref_shar", "f_oppgender_pref_attr",
                "f_oppgender_pref_sinc", "f_oppgender_pref_intel", "f_oppgender_pref_fun", "f_oppgender_pref_amb",
                "f_oppgender_pref_shar", "f_rate_self_attr", "f_rate_self_sinc", "f_rate_self_fun",
                "f_rate_self_intel", "f_rate_self_amb", "f_avg_attr", "f_avg_sinc",
                "f_avg_fun", "f_avg_intel", "f_avg_amb", "f_avg_like",
                "m_est_matches", "m_age", "m_field_num", "m_race",
                "m_imp_race", "m_imp_relig", "m_goal", "m_dat_freq",
                "m_out_freq", "m_career_num", "m_like_sports", "m_like_tvsports",
                "m_like_exercise", "m_like_dining", "m_like_museums", "m_like_art",
                "m_like_hiking", "m_like_gaming", "m_like_clubbing", "m_like_reading",
                "m_like_tv", "m_like_theater", "m_like_movies", "m_like_concerts",
                "m_like_music", "m_like_shopping", "m_like_yoga", "m_exp_happy",
                "m_pref_attr", "m_pref_sinc", "m_pref_intel", "m_pref_fun",
                "m_pref_amb", "m_pref_shar", "m_gender_pref_attr", "m_gender_pref_sinc",
                "m_gender_pref_intel", "m_gender_pref_fun", "m_gender_pref_amb", "m_gender_pref_shar",
                "m_opp_gender_pref_attr", "m_opp_gender_pref_sinc", "m_opp_gender_pref_intel", "m_opp_gender_pref_fun",
                "m_opp_gender_pref_amb", "m_opp_gender_pref_shar", "m_rate_self_attr", "m_rate_self_sinc",
                "m_rate_self_fun", "m_rate_self_intel", "m_rate_self_amb", "m_avg_attr",
                "m_avg_sinc", "m_avg_fun", "m_avg_intel", "m_avg_amb",
                "m_avg_like")
categoric_vars <- c("f_field", "f_career", "m_field", "m_career")
target_var  <- "match"
ident_var   <- "pair_id"

############################
#Build Principal Components for a few subsets of the data to better profile individuals
#############################
##
#Female Preferences
#########
pca_targets <- c("f_pref_attr", "f_pref_sinc", "f_pref_intel", "f_pref_fun",
                  "f_pref_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
f_pref_pca_vec_1<-pc$scores[,1]
f_pref_pca_vec_2<-pc$scores[,2]
f_pref_pca_vec_3<-pc$scores[,3]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(dataset,f_pref_pca_vec_1,f_pref_pca_vec_2, f_pref_pca_vec_3)
head(pca_dataset)

##
#Female Perception of Men
#########
pca_targets <- c("f_oppgender_pref_attr", "f_oppgender_pref_sinc", "f_oppgender_pref_intel", "f_oppgender_pref_fun",
                 "f_oppgender_pref_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
f_oppgender_perception_pca_vec_1<-pc$scores[,1]
f_oppgender_perception_pca_vec_2<-pc$scores[,2]
biplot(pc)
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,f_oppgender_perception_pca_vec_1,f_oppgender_perception_pca_vec_2)
head(pca_dataset)

##
#Female Perception of of Themselves
#########
pca_targets <- c("f_rate_self_attr", "f_rate_self_sinc", "f_rate_self_fun", "f_rate_self_intel",
                  "f_rate_self_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
biplot(pc, main="Female Self-Perception")
pc
summary(pc)
#take actual values based on PC vectors
f_self_perception_pca_vec_1<-pc$scores[,1]
f_self_perception_pca_vec_2<-pc$scores[,2]
f_self_perception_pca_vec_3<-pc$scores[,3]
f_self_perception_pca_vec_4<-pc$scores[,4]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,f_self_perception_pca_vec_1,f_self_perception_pca_vec_2, f_self_perception_pca_vec_3, f_self_perception_pca_vec_4)
head(pca_dataset)

##
#Female Interests
#########
pca_targets <- c("f_like_sports", "f_like_tvsports", "f_like_exercise", "f_like_dining",
                 "f_like_museums", "f_like_art", "f_like_hiking", "f_like_gaming",
                 "f_like_clubbing", "f_like_reading", "f_like_tv", "f_like_theater",
                 "f_like_movies", "f_like_concerts", "f_like_music", "f_like_shopping",
                 "f_like_yoga")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
f_interests_pca_vec_1<-pc$scores[,1]
f_interests_pca_vec_2<-pc$scores[,2]
f_interests_pca_vec_3<-pc$scores[,3]
f_interests_pca_vec_4<-pc$scores[,4]
f_interests_pca_vec_5<-pc$scores[,5]
f_interests_pca_vec_6<-pc$scores[,6]
f_interests_pca_vec_7<-pc$scores[,7]
f_interests_pca_vec_8<-pc$scores[,8]
f_interests_pca_vec_9<-pc$scores[,9]
f_interests_pca_vec_10<-pc$scores[,10]
f_interests_pca_vec_11<-pc$scores[,11]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,f_interests_pca_vec_1,f_interests_pca_vec_2, f_interests_pca_vec_3,f_interests_pca_vec_4,f_interests_pca_vec_5,f_interests_pca_vec_6,f_interests_pca_vec_7,f_interests_pca_vec_8,f_interests_pca_vec_9,f_interests_pca_vec_10,f_interests_pca_vec_11)
head(pca_dataset)


##
#Male Preferences
#########
##FIRST MUST IMPUTE FUN AND AMBITION AS THEY HAVE MISSING VALUES FOR SOME OBSERVATIONS
#impute using median
dataset$m_pref_fun[is.na(dataset$m_pref_fun)]<-median(dataset[["m_pref_fun"]], na.rm=TRUE)
dataset$m_pref_amb[is.na(dataset$m_pref_amb)]<-median(dataset[["m_pref_amb"]], na.rm=TRUE)
###
pca_targets <- c("m_pref_attr", "m_pref_sinc", "m_pref_intel", "m_pref_fun",
                 "m_pref_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
m_pref_pca_vec_1<-pc$scores[,1]
m_pref_pca_vec_2<-pc$scores[,2]
m_pref_pca_vec_3<-pc$scores[,3]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,m_pref_pca_vec_1,m_pref_pca_vec_2, m_pref_pca_vec_3)
head(pca_dataset)

##
#Male Perception of Women
#########
pca_targets <- c("m_opp_gender_pref_attr", "m_opp_gender_pref_sinc", "m_opp_gender_pref_intel", "m_opp_gender_pref_fun",
                 "m_opp_gender_pref_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
m_oppgender_perception_pca_vec_1<-pc$scores[,1]
m_oppgender_perception_pca_vec_2<-pc$scores[,2]
m_oppgender_perception_pca_vec_3<-pc$scores[,3]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,m_oppgender_perception_pca_vec_1,m_oppgender_perception_pca_vec_2, m_oppgender_perception_pca_vec_3)
head(pca_dataset)

##
#Male Perception of of Themselves
#########
pca_targets <- c("m_rate_self_attr", "m_rate_self_sinc", "m_rate_self_fun", "m_rate_self_intel",
                 "m_rate_self_amb")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
m_self_perception_pca_vec_1<-pc$scores[,1]
m_self_perception_pca_vec_2<-pc$scores[,2]
m_self_perception_pca_vec_3<-pc$scores[,3]
m_self_perception_pca_vec_4<-pc$scores[,4]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,m_self_perception_pca_vec_1,m_self_perception_pca_vec_2,m_self_perception_pca_vec_3,m_self_perception_pca_vec_4)
head(pca_dataset)

##
#Male Interests
#########
pca_targets <- c("m_like_sports", "m_like_tvsports", "m_like_exercise", "m_like_dining",
                 "m_like_museums", "m_like_art", "m_like_hiking", "m_like_gaming",
                 "m_like_clubbing", "m_like_reading", "m_like_tv", "m_like_theater",
                 "m_like_movies", "m_like_concerts", "m_like_music", "m_like_shopping",
                 "m_like_yoga")
#Remember: perform PCA only on the numeric variables
pc <- princomp(na.omit(dataset[,pca_targets]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)
#take actual values based on PC vectors
m_interests_pca_vec_1<-pc$scores[,1]
m_interests_pca_vec_2<-pc$scores[,2]
m_interests_pca_vec_3<-pc$scores[,3]
m_interests_pca_vec_4<-pc$scores[,4]
m_interests_pca_vec_5<-pc$scores[,5]
m_interests_pca_vec_6<-pc$scores[,6]
m_interests_pca_vec_7<-pc$scores[,7]
m_interests_pca_vec_8<-pc$scores[,8]
m_interests_pca_vec_9<-pc$scores[,9]
m_interests_pca_vec_10<-pc$scores[,10]
m_interests_pca_vec_11<-pc$scores[,11]
#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(pca_dataset,m_interests_pca_vec_1,m_interests_pca_vec_2, m_interests_pca_vec_3,m_interests_pca_vec_4,m_interests_pca_vec_5,m_interests_pca_vec_6,m_interests_pca_vec_7,m_interests_pca_vec_8,m_interests_pca_vec_9,m_interests_pca_vec_10,m_interests_pca_vec_11)
head(pca_dataset)

##############################
#Impute Missing necessary variables for categorical analysis on the established PCA dataset
##############################
#male field number, male career number, female career number -- impute with zeroes for missing obs -- make sure to observe as categorical in analysis
pca_dataset$m_field_num[is.na(pca_dataset$m_field_num)]<-0
pca_dataset$m_career_num[is.na(pca_dataset$m_career_num)]<-0
pca_dataset$f_career_num[is.na(pca_dataset$f_career_num)]<-0
#male date frequency, male age, female age -- impute with median for now. Possibly consider other methods in future
pca_dataset$f_age[is.na(pca_dataset$f_age)]<-median(pca_dataset[["f_age"]], na.rm=TRUE)
pca_dataset$m_age[is.na(pca_dataset$m_age)]<-median(pca_dataset[["m_age"]], na.rm=TRUE)
pca_dataset$m_dat_freq[is.na(dataset$m_dat_freq)]<-median(pca_dataset[["m_dat_freq"]], na.rm=TRUE)




###############################
#build svm based on PCA analysis and data imputes
##########################
write.csv(file="pca_addon_dataset.csv", x=pca_dataset)

