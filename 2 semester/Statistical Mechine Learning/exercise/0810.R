setwd("D:/second semester/statistical bigdata/data/data")
mpg <- read.csv("mpg.csv")


mpg <- na.omit(mpg)
mpg$mpg <- ifelse(mpg$mpg>median(mpg$mpg), 1, 0)

model_lda <- LDA()


