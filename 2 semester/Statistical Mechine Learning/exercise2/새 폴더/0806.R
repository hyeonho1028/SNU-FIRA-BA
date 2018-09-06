# The Elements of Statistical Learning
# MOOC by Hastie and Tibshirani
# www-bcf.usc.edu/~gareth/ISL/index

if(!require(ISLR)){install.packages("ISLR"); library(ISLR)}
# classification는 error rate 반드시 명시

advertising <- read.csv('http://www-bcf.usc.edu/~gareth/ISL/Advertising.csv')

lm.fit <- lm(sales ~ TV, advertising)
summary(lm.fit)

head(Credit)


my_cols <- c("#00AFBB", "#E7B800", "#FC4E07")
pairs(~Income+Limit+Rating+Cards+Age+Education+Balance, Credit, 
      col = my_cols[Credit$Ethnicity], pch = 19, cex = 0.8)

pairs(~Income+Limit+Rating+Cards+Age+Education+Balance, Credit, col = Credit$Student)






