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

#perform PCA on the numeric variables -- possibly consider a recode of categoricals??
pc <- princomp(na.omit(dataset[,numeric_vars]), scale=TRUE, center=TRUE, tol=0)
#show output of PCA Analysis and summarize
pc
summary(pc)

#take actual values based on PC vectors
names(pc)

#NOTE: data is missing from observations prior to the 883 row due to the gender_pref scores missing prior to this row
PCAVector1<-pc$scores[,1]
PCAVector2<-pc$scores[,2]

#get indices of obs used in the PCA analysis
obs_inds<-as.numeric(names(PCAVector1))

#create dataframe consisting of PCAs and target
pca_dataset <- data.frame(PCAVector1,PCAVector2,dataset[obs_inds,categoric_vars], dataset$match[obs_inds])
head(pca_dataset)

#build svm based on PCA analysis
write.csv(file="pca_match_dataset.csv", x=pca_dataset)
#did a quick rattle run



###################
#build SVM locally
train = sample(1:nrow(pca_dataset),nrow(pca_dataset)*0.8)
require(e1071)
require(ROCR)
pca_svm = svm(dataset.match.obs_inds.~., data=pca_dataset[train,], kernel="radial",gamma=1,cost=1e5)
#use tun to select the best choice for gamma and cost for SVM with radial kernel
set.seed(1)
tune.out=tune(svm, dataset.match.obs_inds.~., data=pca_dataset[train,], kernel="radial", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out)
#best parameters involve cost 1 and gamma 0.5
#look at conf matrix for the data based on tune's best model
true=pca_dataset[-train,"dataset.match.obs_inds."]
temp = pca_dataset[-train,]
pred=predict(tune.out$best.model,newdata=temp, type="response")
#blech