library(dplyr)
library(ggplot2)
library(reshape2)

adata <- tbl_df(read.csv(file = "~/extractDataPR.csv")[ ,2:8])

cutGroup <- function(agid, asem) {
  g <- filter(adata, gid == agid & semnum == asem)
  cg <- g[,c("stid", "discid", "sum")]
  return(cg)
}

B11 <- cutGroup(222,2)
B12 <- cutGroup(278,2)

getDiscName <- function(id) {
  name <- filter(adata, discid == id)
  return(pull(name, discname)[1])
}

isB11sem2 <- dcast(cutGroup(222,2), stid ~ discid)
isB12sem2 <- dcast(cutGroup(278,2), stid ~ discid)
# isB13sem2 <- dcast(cutGroup(333,2), stid ~ discid)

n_clusters <- 3
k1 <- kmeans(isB11sem2[,2:ncol(isB11sem2)],n_clusters)
k2 <- kmeans(isB12sem2[,2:ncol(isB12sem2)],n_clusters)

isB11sem2$cluster <- factor(k1$cluster)
isB12sem2$cluster <- factor(k2$cluster)

# Cluster Dendrogram
plot(hclust(dist(isB11sem2[, 2:ncol(isB11sem2)])), xlab="", ylab= "distance", sub="", main=NULL)
  abline(h=60, col="red", lwd=2, lty=3)
plot(hclust(dist(isB12sem2[, 2:ncol(isB11sem2)])), xlab="", ylab= "distance", sub="", main=NULL)
  abline(h=45, col="red", lwd=2, lty=3)
  abline(h=50, col="red", lwd=2, lty=3)
  
# IQR
  discB11 <- B11 %>% group_by(discid) %>% summarise(n(), IQR(sum))
  discB12 <- B12 %>% group_by(discid) %>% summarise(n(), IQR(sum))
  studB11 <- B11 %>% group_by(stid) %>% summarise(n(), median(sum))
  studB12 <- B12 %>% group_by(stid) %>% summarise(n(), median(sum))

  plot(isB11sem2[,c("6")], isB11sem2[,c("23")], col=k1$cluster,
    xlab=getDiscName(6), ylab=getDiscName(23))
  plot(isB12sem2[,c("6")], isB12sem2[,c("21")], col=k2$cluster,
    xlab=getDiscName(6), ylab=getDiscName(21)) 
  
# Statistika
  shapiro.test(B11$sum)
  shapiro.test(B12$sum)
  
  wilcox.test(B11$sum, B12$sum)
  
  
  