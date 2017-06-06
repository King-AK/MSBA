######Dendrogram Script#####


#####males####
males = read.csv("males.csv")

use = males[,-c(1,8)]

males.clust = hclust(dist(use))
plot(males.clust)

groups.2 = cutree(males.clust,2)
table(groups.2)

aggregate(use,list(groups.2),median)




groups.3 = cutree(males.clust,3)
table(groups.3)

aggregate(use,list(groups.3),median)



groups.4 = cutree(males.clust,4)
table(groups.4)

aggregate(use,list(groups.4),median)

groups.5 = cutree(males.clust,5)
table(groups.5)

aggregate(use,list(groups.5),median)
results = aggregate(males[,-1],list(groups.5),median)
results = results[order(-results$m_percent_interest),]
results

people  = cbind(males$male_id,groups.5)

people[match(16,people),2]



#####females######
females = read.csv("females.csv")

use = females[,-c(1,8)]

females.clust = hclust(dist(use))
plot(females.clust)

groups.2 = cutree(females.clust,2)
table(groups.2)

aggregate(use,list(groups.2),median)




groups.3 = cutree(females.clust,3)
table(groups.3)

aggregate(use,list(groups.3),median)



groups.4 = cutree(females.clust,4)
table(groups.4)

aggregate(use,list(groups.4),median)


results = aggregate(females[,-1],list(groups.4),median)
results



