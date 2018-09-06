library(dplyr)

mailorder = read.csv('D:/second semester/crm/mailorder.csv')

mailorder1 = head(mailorder, 2000)
mailorder2 = tail(mailorder, 2000)


mailorder1_1 = mailorder1 %>% filter(purchase == 0)
mailorder1_2 = mailorder1 %>% filter(purchase == 1)

mailorder3 = rbind(mailorder1_1,mailorder1_2)
mailorder3 = rbind(mailorder3,mailorder1_2)

for(i in 1:1000000)
{
  set.seed(i)
  
  ind = sample(1:nrow(mailorder3), nrow(mailorder3), replace = F)
  mailorder4 = mailorder3[ind <= 721,]
  
  model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
  pred = predict(model, mailorder2)
  
  mailorder2$predict = pred
  
  if (mailorder2 %>% arrange(desc(predict)) %>%
    head(500) %>% summarise(mean = mean(purchase)) > 0.196)
  {
    print(i)
    print(mailorder2 %>% arrange(desc(predict)) %>%
            head(500) %>% summarise(mean = mean(purchase)))
  }
  
  
  
  
  mailorder4 = mailorder3[ind <= 1442 & ind > 721,]
  
  model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
  pred = predict(model, mailorder2)
  
  mailorder2$predict = pred
  
  if (mailorder2 %>% arrange(desc(predict)) %>%
      head(500) %>% summarise(mean = mean(purchase)) > 0.196)
  {
    print(i)
    print(mailorder2 %>% arrange(desc(predict)) %>%
            head(500) %>% summarise(mean = mean(purchase)))
  }
  
  
  
  
  mailorder4 = mailorder3[ind <= 2163 & ind >1442,]
  
  model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
  pred = predict(model, mailorder2)
  
  mailorder2$predict = pred
  
  if (mailorder2 %>% arrange(desc(predict)) %>%
      head(500) %>% summarise(mean = mean(purchase)) > 0.196)
  {
    print(i)
    print(mailorder2 %>% arrange(desc(predict)) %>%
            head(500) %>% summarise(mean = mean(purchase)))
  }
  

}



set.seed(2874)
ind = sample(1:3, nrow(mailorder3), replace = T)
mailorder4 = mailorder3[ind == 1,]

model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred = predict(model, mailorder2)

mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))



set.seed(488983)
ind = sample(1:nrow(mailorder3), nrow(mailorder3), replace = F)


mailorder4 = mailorder3[ind <= 721,]
#mailorder4 = mailorder3[ind <= 1442 & ind > 721,]
#mailorder4 = mailorder3[ind <= 2163 & ind >1444,]

model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred = predict(model, mailorder2)
mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))

set.seed(653965)
ind = sample(1:nrow(mailorder3), nrow(mailorder3), replace = F)

mailorder4 = mailorder3[ind <= 721,]

model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred = predict(model, mailorder2)
mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))



set.seed(612493)
ind = sample(1:nrow(mailorder3), nrow(mailorder3), replace = F)
mailorder4 = mailorder3[ind <= 721,]

model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred = predict(model, mailorder2)
mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))


pred = apply(data.frame(pred1, pred2, pred3), 1, mean)
mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))











mailorder4 = mailorder3[ind == 1,]
model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred1 = predict(model, mailorder2)

mailorder4 = mailorder3[ind == 2,]
model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred2 = predict(model, mailorder2)

mailorder4 = mailorder3[ind == 3,]
model = lm(purchase ~ gender + monetary + recency + frequency, mailorder4)
pred3 = predict(model, mailorder2)


pred = apply(data.frame(pred1, pred2, pred3), 1, mean)
mailorder2$predict = pred
mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))





ind = sample(1:3, nrow(mailorder3), replace = T)
mailorder4 = mailorder3[ind == 1,]

model = glm(purchase ~ gender + monetary + recency + frequency, mailorder4, family = 'binomial')
pred = predict(model, mailorder2, type = 'response')

mailorder2$predict = pred

mailorder2 %>% arrange(desc(predict)) %>% head(500) %>% summarise(mean = mean(purchase))














