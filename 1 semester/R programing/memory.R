# 메모리 초기화
rm(list=ls());gc()

dev.off();par(mfrow=c(1,1))
# par설정 초기화


if(!require(ABC)){install.packages("ABC"); library(ABC)}
# 패키지 설치


# ---
# title: "linear algebra"
# author: "hyeonho lee"
# date: "2018년 12월 18일"
# output:
#   pdf_document:
#     toc: true
#     latex_engine: xelatex
#   html_document: default
#   word_document:
#     highlight: tango
# mainfont: NanumGothic
# header-includes :
#   - \usepackage{kotex}
#   - \usepackage{setspace}
#   - \usepackage{booktabs}
# ---