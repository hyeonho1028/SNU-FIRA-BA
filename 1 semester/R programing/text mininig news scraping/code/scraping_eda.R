if(!require(wordcloud)){install.packages('wordcloud') ; library(wordcloud)}
if(!require(RColorBrewer )){install.packages('RColorBrewer ') ; library(RColorBrewer )}
if(!require(KoNLP)){install.packages('KoNLP') ; library(KoNLP)}
if(!require(dplyr)){install.packages('dplyr') ; library(dplyr)}
if(!require(tm)){install.packages('tm') ; library(tm)}
if(!require(qgraph)){install.packages('qgraph') ; library(qgraph)}
if(!require(networkD3)){install.packages('networkD3') ; library(networkD3)}
if(!require(plyr)){install.packages('plyr') ; library(plyr)}


library(rvest)
library(stringi)
library(tidyverse)
library(tidytext)
library(rJava)
library(wordVectors)
library(tsne)
library(ggplot2)


require(devtools)
install_github("bmschmidt/wordVectors")
if(!require(tidytext)){install.packages('tidytext') ; library(tidytext)}
if(!require(tidyverse)){install.packages('tidyverse') ; library(tidyverse)}
if(!require(tsne)){install.packages('tsne') ; library(tsne)}
if(!require(ggdendro)){install.packages('ggdendro') ; library(ggdendro)}



useSejongDic()

# total set data ----
scraping_dat <- read.csv('C:/workspace/R/7/study_scraping/scraping_dat2.csv',
                         sep = ',', stringsAsFactors = F)

scraping_dat$description = gsub('\n|\t|<.*?>|&quot;',' ',scraping_dat$description)
scraping_dat$description = gsub('[^가-힣a-zA-Z]',' ',scraping_dat$description)
scraping_dat$description = gsub(' +',' ',scraping_dat$description)

# sort 해야할때
scraping_dat = scraping_dat[order(scraping_dat$pubDate),]

data_unlist <- sapply(scraping_dat$description, extractNoun, USE.NAMES = F) %>% 
                unlist()

data_unlist <- Filter(function(x){nchar(x)>=2}, data_unlist)
# 2글자 이상만 필터링해서 가져온다.

data_unlist <- f_gsub(data_unlist)
data_unlist <- Filter(function(x){nchar(x)>=2}, data_unlist)

wordcount <- table(data_unlist)
wordcount_top <-head(sort(wordcount, decreasing = T),108)



# wordcloud(names(wordcount_top), wordcount_top) 기본형태

palete <- brewer.pal(9, "Set1")  # 색상
wordcloud(names(wordcount_top), freq = wordcount_top, scale=c(5.5, 1.5),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)



# 유사성 검색 ----
data_unlist %>% closest_to('비트코인')


#

# 날짜별로 분리하기 ----
for ( i in 1:length(scraping_dat[[3]]) )
{
  scraping_dat[[3]][i] = substr(scraping_dat[[3]][i], 6, 7)
}

table(scraping_dat[[3]])

# 각 날짜별 뉴스기사 ----
# 18일 뉴스기사
data1 <- scraping_dat[scraping_dat[[3]] == 18,]

data18 <- sapply(data1$description, extractNoun, USE.NAMES = F) %>% unlist()
data18 <- Filter(function(x){nchar(x)>=2}, data18)
data18 <- f_gsub(data18)
data18 <- Filter(function(x){nchar(x)>=2}, data18)

wordcount_top18 <- table(data18) %>% sort(decreasing = T) %>% head(108)

# 19일 뉴스기사
data2 <- scraping_dat[scraping_dat[[3]] == 19,]

data19 <- sapply(data2$description, extractNoun, USE.NAMES = F) %>% unlist()
data19 <- Filter(function(x){nchar(x)>=2}, data19)
data19 <- f_gsub(data19)
data19 <- Filter(function(x){nchar(x)>=2}, data19)

wordcount_top19 <- table(data19) %>% sort(decreasing = T) %>% head(108)

# 20일 뉴스기사
data3 <- scraping_dat[scraping_dat[[3]] == 20,]

data20 <- sapply(data3$description, extractNoun, USE.NAMES = F) %>% unlist()
data20 <- Filter(function(x){nchar(x)>=2}, data20)
data20 <- f_gsub(data20)
data20 <- Filter(function(x){nchar(x)>=2}, data20)

wordcount_top20 <- table(data20) %>% sort(decreasing = T) %>% head(108)

# 21일 뉴스기사
data4 <- scraping_dat[scraping_dat[[3]] == 21,]

data21 <- sapply(data4$description, extractNoun, USE.NAMES = F) %>% unlist()
data21 <- Filter(function(x){nchar(x)>=2}, data21)
data21 <- f_gsub(data21)
data21 <- Filter(function(x){nchar(x)>=2}, data21)

wordcount_top21 <- table(data21) %>% sort(decreasing = T) %>% head(108)

# 22일 뉴스기사
data5 <- scraping_dat[scraping_dat[[3]] == 22,]

data22 <- sapply(data5$description, extractNoun, USE.NAMES = F) %>% unlist()
data22 <- Filter(function(x){nchar(x)>=2}, data22)
data22 <- f_gsub(data22)
data22 <- Filter(function(x){nchar(x)>=2}, data22)

wordcount_top22 <- table(data22) %>% sort(decreasing = T) %>% head(108)

# 23일 뉴스기사
data6 <- scraping_dat[scraping_dat[[3]] == 23,]

data23 <- sapply(data6$description, extractNoun, USE.NAMES = F) %>% unlist()
data23 <- Filter(function(x){nchar(x)>=2}, data23)
data23 <- f_gsub(data23)
data23 <- Filter(function(x){nchar(x)>=2}, data23)

wordcount_top23 <- table(data23) %>% sort(decreasing = T) %>% head(108)

# 24일 뉴스기사
data7 <- scraping_dat[scraping_dat[[3]] == 24,]

data24 <- sapply(data7$description, extractNoun, USE.NAMES = F) %>% unlist()
data24 <- Filter(function(x){nchar(x)>=2}, data24)
data24 <- f_gsub(data24)
data24 <- Filter(function(x){nchar(x)>=2}, data24)

wordcount_top24 <- table(data24) %>% sort(decreasing = T) %>% head(108)

---
# 공통 불용어 처리(전체 데이터셋일 때) ----
f_gsub <- function(x)
{
  x = gsub('화폐', '가상화폐', x)
  x = gsub('가상', '가상화폐', x)
  x = gsub('^화폐[[:alnum:]]+', '가상화폐', x)
  x = gsub('^가상[[:alnum:]]+', '가상화폐', x)
  x = gsub('^코인원[[:alnum:]]+', '코인원', x)
  x = gsub('^빗썸[[:alnum:]]+', '빗썸', x)
  x = gsub('^업비트[[:alnum:]]+', '업비트', x)
  x = gsub('^이더리움[[:alnum:]]+', '이더리움', x)
  x = gsub('^코인베이스[[:alnum:]]+', '코인베이스', x)
  x = gsub('^파트너십[[:alnum:]]+', '파트너쉽', x)
  x = gsub('^라이트코인[[:alnum:]]+', '라이트코인', x)
  x = gsub('^코빗[[:alnum:]]+', '코빗', x)
  x = gsub('이날', '', x)
  x = gsub('기준', '', x)
  x = gsub('로이', '', x)
  x = gsub('제공', '', x)
  x = gsub('대장', '', x)
  x = gsub('그림', '', x)
  x = gsub('지미옥', '', x)
  x = gsub('이슬비', '', x)
  x = gsub('경우', '', x)
  x = gsub('김철', '', x)
  x = gsub('한정아', '', x)
  x = gsub('심준보', '', x)
  x = gsub('김민지', '', x)
  x = gsub('박성', '', x)
  x = gsub('손시현', '', x)
  x = gsub('가운데', '', x)
  x = gsub('주요', '', x)
  x = gsub('개월', '', x)
  x = gsub('닷컴', '', x)
  x = gsub('이코노미톡뉴스', '', x)
  x = gsub('전지', '', x)
  x = gsub('대부분', '', x)
  x = gsub('대표적', '', x)
  x = gsub('만삭', '', x)
  x = gsub('공방', '', x)
  x = gsub('비롯', '', x)
  x = gsub('만원', '', x)
  x = gsub('대비', '', x)
  x = gsub('한국경제TV', '', x)
  x = gsub('양상', '', x)
  x = gsub('출처', '', x)
  x = gsub('들이', '', x)
  x = gsub('com', '', x)
  x = gsub('고승', '', x)
  x = gsub('단독', '', x)
  x = gsub('달여', '', x)
  x = gsub('사이트', '', x)
  x = gsub('ajunews', '', x)
  x = gsub('추이', '', x)
  x = gsub('김기태', '', x)
  x = gsub('갈무리', '', x)
}

# 각 날짜별로 주요 언급 단어 ----
par(mfrow = c(4, 2))
barplot(head(wordcount_top18/sum(wordcount_top18), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '18일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top19/sum(wordcount_top19), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '19일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top20/sum(wordcount_top20), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '20일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top21/sum(wordcount_top21), 16)[7:16],  
        xlab = '단어 빈도', col = 'orange',
        main = '21일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top22/sum(wordcount_top22), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '22일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top23/sum(wordcount_top23), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '23일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')
barplot(head(wordcount_top24/sum(wordcount_top24), 16)[7:16], 
        xlab = '단어 빈도', col = 'orange',
        main = '24일 비트코인 기사에서 언급된 단어 빈도 상위 7위부터 16위')

# 각 일별로 점수 부여 ----
posDic = readLines("C:/workspace/R/7/study_scraping/posDic.txt")
negDic = readLines("C:/workspace/R/7/study_scraping/negDic.txt")



sentimental = function(sentences, posDic, negDic){
  
  scores = laply(sentences, function(sentence, posDic, negDic) {
    
    pos.matches = match(sentence, posDic)           # words의 단어를 posDic에서 matching
    neg.matches = match(sentence, negDic)
    
    pos.matches = !is.na(pos.matches)            # NA 제거, 위치(숫자)만 추출
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches)  # 긍정 - 부정   
    return(score)
  }, posDic, negDic)
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

result = sentimental(data18, posDic, negDic)
sum(result$score)
result = sentimental(data19, posDic, negDic)
sum(result$score)
result = sentimental(data20, posDic, negDic)
sum(result$score)
result = sentimental(data21, posDic, negDic)
sum(result$score)
result = sentimental(data22, posDic, negDic)
sum(result$score)
result = sentimental(data23, posDic, negDic)
sum(result$score)
result = sentimental(data24, posDic, negDic)
sum(result$score)


x = c(143, 11, 43, -55, 13, 92, 118)

plot(18:24, x/sum(x), type = 'l', lwd = 2, xlab = 'day', #ylim = c(0.07, 0.2), 
     ylab = 'density', main = 'positive and negative score')




result = sentimental(data_unlist, posDic, negDic)

result$color[result$score >=1] = "blue"
result$color[result$score ==0] = "green"
result$color[result$score < 0] = "red"

plot(result$score, col=result$color, ylab = '긍정단어와 부정단어') # 산포도 색생 적용
barplot(result$score, col=result$color, main ="감성분석 결과화면")

table(result$color)

# -- (2) score 칼럼 리코딩
result$remark[result$score >=1] = "긍정"
result$remark[result$score ==0] = "중립"
result$remark[result$score < 0] = "부정"

sentiment_result= table(result$remark)
round(sentiment_result/sum(sentiment_result) * 100,1)

# -- (3) 제목, 색상, 원크기
pie(sentiment_result, main="감성분석 결과",
    col=c("blue","red","green"), radius=0.8, labels = c('긍정 5.7%', 
                                                        '부정 4.4%', '중립 89.9%')) 

length(result$score)


a = 0
a[1]=sum(result$score[1:1000])
a[2]=sum(result$score[1001:2000])
a[3]=sum(result$score[2001:3000])
a[4]=sum(result$score[3001:4000])
a[5]=sum(result$score[4001:5000])
a[6]=sum(result$score[5001:6000])
a[7]=sum(result$score[6001:7000])
a[8]=sum(result$score[7001:8000])
a[9]=sum(result$score[8001:9000])
a[10]=sum(result$score[9001:10000])
a[11]=sum(result$score[10001:11000])
a[12]=sum(result$score[11001:12000])
a[13]=sum(result$score[12001:13000])
a[14]=sum(result$score[13001:14000])
a[15]=sum(result$score[14001:15000])
a[16]=sum(result$score[15001:16000])
a[17]=sum(result$score[16001:1700])
a[18]=sum(result$score[17001:18000])
a[19]=sum(result$score[18001:19000])
a[20]=sum(result$score[19001:20000])
a[21]=sum(result$score[20001:21000])
a[22]=sum(result$score[21001:22000])
a[23]=sum(result$score[22001:23000])
a[24]=sum(result$score[23001:24000])
a[25]=sum(result$score[24001:25000])
a[26]=sum(result$score[25001:26472])

plot(seq(18, 24, length = 26), cumsum(a), type = 'l', xlab = 'day', ylab = 'Cumulative Sum',
     main = '감성분석 score')
cumsum(a)


wordcount_top18
wordcount_top19
wordcount_top20
wordcount_top21
wordcount_top22
wordcount_top23
wordcount_top24

score18 = 62+35-23+19+14+10-8-8+2.5+9-4+4+3-2+2+3
score19
score20
score21
score22
score23
score24




x = c(957927,	886168,	853650,	598919,	1050793,	1122483,	1085091)
y = c(281,	271,	256,	214,	165,	294,	266)
z = c(130616,	94254,	108309,	62699,	72118,	118670,	151413)
xy =c(827028,	791643,	745083,	536004,	978510,	1003518,	933410)

plot(18:24, x/sum(x), type = 'l', lwd = 2, ylim = c(0.07, 0.2), xlab = 'day', 
     ylab = 'density', main = 'Volume graph per day')
lines(18:24, y/sum(y), type = 'l', col = 'green', lwd = 2)
lines(18:24, z/sum(z), type = 'l', col = 'blue', lwd = 2)
lines(18:24, xy/sum(xy), type = 'l', col = 'red', lwd = 2)
legend('bottomright', c('All Volume',  'CNY Volume', 'USD Volume', 'Others Volume'), 
       lty = 1, col = c('black', 'green', 'blue', 'red'))

# All Volume, CNY Volume, USD Volume, Others Volume



# 각 날짜별로 언급 단어 워드클라우드 ----
palete <- brewer.pal(9, "Set1")  # 색상
par(mfrow = c(4, 2))
wordcloud(names(wordcount_top18), freq = wordcount_top18, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top19), freq = wordcount_top19, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top20), freq = wordcount_top20, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top21), freq = wordcount_top21, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top22), freq = wordcount_top22, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top23), freq = wordcount_top23, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)
wordcloud(names(wordcount_top24), freq = wordcount_top24, scale=c(5, 1.3),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)



#--
# 19일과 21일 단어 빈도분석

  
  

# 20개 키워드 연관단어 네트워크 다이어그램(각 기사별로) ----
wordcloud(names(wordcount_top), freq = wordcount_top, scale=c(2, 0.5),
          rot.per = 0.5, random.order = F, random.color = T,
          colors = palete)





write.csv(data_unlist, 'C:/workspace/R/7/study_scraping/data_unlist.csv')

a = read.csv('C:/workspace/R/7/study_scraping/data_unlist.csv')

write.table(data_unlist, 'C:/workspace/R/7/study_scraping/data_unlist.txt')

write.csv(scraping_dat$description, 'C:/workspace/R/7/study_scraping/a.csv')

a = read.csv('C:/workspace/R/7/study_scraping/a.csv')

a = a$x

a = as.character(a)

a=scraping_dat$description


ko.words = function(doc)
{
  d = str_split(doc, ' ')
  extracted = tolower(str_match(d, '([가-힣a-zA-Z]+)./[NVO]'))
  keyword = extracted[,2]
  
  keyword[!is.na(keyword)]
}



corpus <- Corpus(VectorSource(a))

stopWord <- c('기자', '있다', '대비', '따르면', '한시간', '보이고',
              '원에', '만원대에', '있고', '있으며', '로이슈')

tdm <- TermDocumentMatrix(corpus, control = list(tokenize = ko.words,
                                                 removePunctuation = T,
                                                 removeNumbers=T,
                                                 stopwords=stopWord,
                                                 wordLengths=c(4, 10)))

tdm.matrix <- as.matrix(tdm)

word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=TRUE)
freq.words <- tdm.matrix[word.order[1:20], ]

co.matrix <- freq.words %*% t(freq.words)
par(family="Apple SD Gothic Neo")
qgraph(co.matrix, labels=rownames(co.matrix),
       diag=FALSE, layout='spring', threshold=2,
       vsize=log(diag(co.matrix)) * 1.2)




corpus <- Corpus(VectorSource(a))


tdm.matrix <- as.matrix(tdm)

word.count <- rowSums(tdm.matrix)



word.order <- order(word.count, decreasing=TRUE)

freq.words <- tdm.matrix[word.order[1:20], ]
rownames(tdm.matrix)[word.order[1:20],]

co.matrix <- freq.words %*% t(freq.words)


qgraph(co.matrix, 
             labels = rownames(co.matrix),
             diag=F, 
             layout = 'spring',
             edge.color = 'blue', 
             vsize = log(diag(co.matrix))*1)



--

# 명사 vector들의 리스트가 나온다. extractNoun을 쓰면 ----
nouns[1:5]
newdic=data.frame(V1=c("떡락장","포스팅","블로그"),"ncn")
KoNLP::mergeUserDic(newdic)
# 조사를 제거할때 사전에 새롭게 넣어주어서 ncn이라는 명사라는걸 알려줘서
# 조사를 제거한다.
nouns=KoNLP::extractNoun(scraping_dat$description)
nouns[1:5]
names(nouns)

wordcloud(nouns, table(nouns), scale=c(5,0.5),random.order = FALSE, 
          random.color = TRUE, family = "font")
?wordcloud

palete <- brewer.pal(9, "Set1")  # 색상
wordcloud(names(table(unlist(nouns))), freq=table(unlist(nouns)), scale=c(4, 0.5),
          rot.per=0.3 ,min.freq=10,random.order=F,random.color=T,colors=palete)


wordcloud(names(table(unlist(nouns))), freq=table(unlist(nouns)), scale=c(6, 1),
          rot.per=0.5 ,min.freq=5,max.words=Inf,
          random.order=F,random.color=T,colors=palete)



# 연습 ----

# wordcloud()
# 
# scale 가장 빈도가 큰 단어와 가장 빈도가 작은단어 폰트사이의 크기차이 scale=c(10,1)
# minfreq 출력될 단어들의 최소빈도
# maxwords 출력될 단어들의 최대빈도(inf:제한없음)
# random.order(true면 랜덤, false면 빈도수가 큰 단어를 중앙에 배치하고 작은순)
# random.color(true면 색 랜덤, false면 빈도순)
# rot.per(90도 회전된 각도로 출력되는 단어비율)
# colors 가장 작은빈도부터 큰 빈도까지의 단어색
# family 글씨체

# 예시
word <- c("사과","바나나","키위","망고","오렌지","딸기","파인애플")
fre <- c(30,20,10,4,5,6,3)
wordcloud(word, fre)

# 사전추가하는 함수
useSejongDic()

# 명사 추출작업
data <- sapply(data, extractNoun, USE.NAMES = F)
data_unlist <- unlist(data)
head(data_unlist)
wordcount <- table(data_unlist)

table(wordcount)

wordcount_top <-head(sort(wordcount, decreasing = T),100)
wordcount_top

wordcloud(names(wordcount_top), wordcount_top)

# 사전등록
mergeUserDic()
# http://kkma.snu.ac.kr/documents/index.jsp?doc=postag 
# 형태소 분석 관련 

mergeUserDic(data.frame(c("노잼"), "ncn"))
# 예시

# setwd()를 이용해 경로를 새로 만든 단어집이 있는 곳으로 재설정해주는 과정을 거치거나, 
# 현재 진행중인 코드가 있는 폴더에서 단어집을 만들어야 합니다.
setwd("D:/R_Practice/Practice")
add_dic <- readLines("addNoun.txt")

for(i in 1:length(add_dic)){
  mergeUserDic(data.frame(add_dic[i], "ncn"))
}

mergeUserDic(data.frame(readLines("addNoun.txt"), "ncn"))
# 위의 코드와 같다는데 확인


data <- sapply(data, extractNoun, USE.NAMES = F)
