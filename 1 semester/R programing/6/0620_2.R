install.packages("rgl")
library(rgl)

persp3d(volcano)
rgl::persp3d(volcano)  #함수명이 같은 경우 패키지명을 명시한다.
image(volcano)


help(persp3d)  #help창을 보고 싶을땐 library 를 먼저 해줘야 된다. 
??persp3d      #??는 웹으로 하는거라서 괜찮은듯함.


z <- 2 * volcano        # Exaggerate the relief
x <- 10 * (1:nrow(z))   # 10 meter spacing (S to N)
y <- 10 * (1:ncol(z))   # 10 meter spacing (E to W)

open3d()
bg3d("slategray")
material3d(col = "black")
persp3d(x, y, z, col = "green3", aspect = "iso", axes = FALSE, box = FALSE)

library(readr)
wine <- read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data", 
                 col_names = FALSE)  #와인데이터 웹에서 가져오기



setwd('C:/workspace/R')
getwd()
save.image('wine.rdata')
load('./wine.rdata')

rm(list = ls())
gc()  #rm()하고 gc()하면 메모리 초기화된다.






