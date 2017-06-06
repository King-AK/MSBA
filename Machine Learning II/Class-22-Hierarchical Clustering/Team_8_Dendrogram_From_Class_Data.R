x=read.csv("data.csv")

#get rid of timestamp
x = x[,-1] 

#set column names
colnames(x) <- c("name", "breakfast", "procrastinate", "age", "workout", "snooze", "nap")

#set names as rownames
rownames(x) = x$name

#get rid of name column
x = x[-1]

#scale the variables
x= scale(x)

#create the dendrogram, using the "complete" linkage method
hc.complete=hclust(dist(x), method="complete")

#optional: try using different linkage methods
#hc.average=hclust(dist(x), method="average")
#hc.single=hclust(dist(x), method="single")

par(mfrow=c(1,1))

#get dendextend library
if (!require('dendextend')) install.packages('dendextend'); library('dendextend')

###### Use the dendextend library to color branches, color labels, thicken branches:
dend <- hc.complete
#Note: k = number of clusters to color. 
dend=color_branches(dend,k=4, col = c("dark turquoise", "blue", "dark green", "purple","orange"))
dend=color_labels(dend,k=4, col = c("dark turquoise", "blue", "dark green", "purple","orange"))
dend=set(dend,"branches_lwd",2) #makes the branches thicker 
plot(dend)
