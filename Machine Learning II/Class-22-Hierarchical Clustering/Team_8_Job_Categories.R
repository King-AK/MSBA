#Team 8 Job Categories Case Study

x = read.csv("jobs.csv", header = FALSE)

x[,2:5] = scale(x[2:8])

rownames(x) = x$V1

hc.complete=hclust(dist(x[-1,2:8]), method="complete")
#hc.average=hclust(dist(x), method="average")
#hc.single=hclust(dist(x), method="single")
par(mfrow=c(1,1))
plot(hc.complete,main="Job Categories", xlab="", ylab ='', sub="", cex=.9, hang = -1)


#abline(h = 170, col = "blue")
#abline(h = 150, col = "blue")
#abline(h = 120, col = "blue")
#abline(h = 80, col = "blue")
#abline(h = 0, col = "blue")
