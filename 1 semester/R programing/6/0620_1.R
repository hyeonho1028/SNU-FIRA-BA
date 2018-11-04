a<-c()
b<-c(1,2,3,4,5)
ls()

save.image('test.rdata')
save.image('C:/workspace/R/test.rdata')
save.image('C:/workspace/Github/bigdata2018/test.rdata')
save.image('../Github/bigdata2018/test3.rdata')
#동일하다. 상위폴더 가르킬때 ..으로

getwd()
setwd('C:\\workspace\\R')


rm(list=ls())
ls()

getwd()
load('C:/workspace/R/test.rdata')
load('./test.rdata')  #동일하다.



