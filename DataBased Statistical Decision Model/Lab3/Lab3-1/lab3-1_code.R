#####################################################################################
#                           Many statistical analyses                               #
#                                   2018.08.22                                      #
#                   Instructor : Sungkyu Jung, TA : Boyoung Kim                     #
#                                                                                   #
#####################################################################################



#--- Australian twin sample biometric data

library(tidyr)
library(dplyr)

#install.packages("OpenMx")
library(OpenMx)
data(twinData)
twinData <- as_tibble(twinData)

help(twinData)


#scatter plot
library(ggplot2)
twinData %>% ggplot(mapping = aes(ht1, ht2)) + 
  geom_point() 

#check correlation
cor(twinData$ht1, twinData$ht2, use="complete.obs")

#test whether two variables are correlated
twinData %>% 
  with(cor.test(~ ht1 + ht2, alternative = "greater"))

#test for each subgroup
twinData %>% 
  group_by(cohort,zygosity) %>% 
  summarise(cor.test(~ ht1 + ht2, data = .))


??tidy


#--- Combine results from multiple analyses using broom

library(broom)
cor_result <- cor.test(~ ht1 + ht2, data = twinData)
tidy_cor_result <- tidy(cor_result)

str(cor_result) #list

str(tidy_cor_result) #data frame

# summarize() must be of the form "var=value"
twinData %>% 
  group_by(cohort,zygosity) %>%  
  summarize(tidy( cor.test(~ ht1 + ht2, alternative = "greater" , data = . )))

# do() returns either a data frame or arbitrary objects
twinData %>% 
  group_by(cohort,zygosity) %>%  
  do(tidy( cor.test(~ ht1 + ht2, alternative = "greater" , data = . )))

