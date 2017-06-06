#Team 8 Dog vs. Fruit Clustering

x = read.csv("Fruits_and_Dogs.csv", header = FALSE)

x[,2:5] = scale(x[2:5])

rownames(x) = x$V1


hc.complete=hclust(dist(x[,2:5]), method="complete")
#hc.average=hclust(dist(x), method="average")
#hc.single=hclust(dist(x), method="single")

par(mfrow=c(1,1))
plot(hc.complete,main="Fruits vs. Dogs", xlab="", ylab ='', sub="", cex=.9, lwd = 2)



## Use dendextend to color branches

# install the package:
if (!require('dendextend')) install.packages('dendextend'); library('dendextend')

d1 <- hc.complete
d2=color_branches(d1,k=2) # auto-coloring 5 clusters of branches.
d3=color_labels(d2,k=2) # auto-coloring 5 clusters of branches.
plot(d3)
d3 = set(d3, "branches_lwd", 4)



