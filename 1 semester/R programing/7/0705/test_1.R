##### 지난시간 리뷰 최종... #####
library(colorspace)
pal = choose_palette()
# 이러면 pal에 자동적으로 저장이 될것임!

##### read.csv #####
surveys = read.csv("C:/workspace/R/6/0705/surveys.csv")
names(surveys)
# 이 함수는 data.frame일 때 사용가능함.

##### column slicing #####
surveys[, c(5, 6, 9)]
# 2차원 벡터의 특징을 이용해서 해도 되지만, 그러면 직관력이 떨어지고, 
# 컬럼순서가 바뀔 수 도 있기 때문에 별로임.

match(c("plot_id", "species_id", "weight"), names(surveys))
surveys[, match(c("plot_id", "species_id", "weight"), names(surveys))]
# 이렇게 하면 순서가 바뀌어도 찾을 수 있음. 직관력도 상승(뭐하는 컬럼인징에 대하여) 

surveys[, c("plot_id", "species_id", "weight")]
# column을 인덱싱하는 부분에 추출하고자 하는 열의 이름에 해당하는 문자열 벡터를 입력한다.

surveys[c("plot_id", "species_id", "weight")]
# data.frame은 list라는 성질을 이용하여 list슬라이싱 방법사용

##### year == 1995 인 데이터 행만 추출 #####
surveys$year == 1995
surveys[surveys$year == 1995, ]
head(surveys[surveys$year == 1995, ])

surveys[surveys$weight < 5, c("plot_id", "species_id", "weight")]
surveys[which(surveys$weight < 5), c("plot_id", "species_id", "weight")]

surveys.ex <- surveys
surveys.ex$weight_kg <- surveys.ex$weight/1000
surveys.ex <- surveys.ex[!is.na(surveys.ex$weight_kg), ]


u = unique(surveys$sex)
# unique함수, unique 구하는 함수
length(u)
class(surveys$sex)
levels(surveys$sex)

mean( surveys$weight[surveys$sex == u[1]], na.rm = T )
mean( surveys$weight[surveys$sex == u[2]], na.rm = T )
mean( surveys$weight[surveys$sex == u[3]], na.rm = T )

##### by함수 #####
a <- by( data = surveys$weight, INDICES =  surveys$sex, 
          FUN  = mean, na.rm = TRUE)
unlist(a)[1]
unlist(a)[2]
unlist(a)[3]
# 불편한게 많아보임 아무리 봐도
# grouping을 더 많이 할 수 있게 aggregate를 사용.

##### aggregate함수 #####
aggregate(formula = weight ~ sex, data = surveys,
          FUN = mean, na.rm = TRUE)
# formula를 사용한다. / 최대장점, 복수개의 그룹핑 가능하다.
aggregate(formula = weight ~ sex + species_id, 
          data = surveys, FUN = mean, na.rm = TRUE)
aggregate(formula = weight ~ sex + species_id, 
          data = surveys, FUN = var, na.rm = TRUE)
aggregate(formula = weight ~ sex + species_id, 
          data = surveys, FUN = sd, na.rm = TRUE)
aggregate(formula = weight ~ sex + species_id, 
          data = surveys, FUN = max, na.rm = TRUE)
aggregate(formula = weight ~ sex + species_id, 
          data = surveys, FUN = min, na.rm = TRUE)
# 여러개의 통계량을 보기엔 또 불편하다.

table(surveys$sex)
table(surveys$sex, surveys$plot_id)

##### ordering #####
a = c(10, 5, 3, 7)
order(a)
a[order(a)]
order(a, decreasing = TRUE)
a[order(a, decreasing = TRUE)]

tmp <- surveys 
tmp <- tmp[order(tmp$plot_id),]
tmp <- tmp[order(tmp$month, decreasing = TRUE),]
head(tmp)
# 먼저 month값을 내림차순으로 정렬하고 그 순서를 유지시키면서 
# plot_id 값의 오름차순으로 surveys 데이터를 정렬하여라.






##### R dplyr #####
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}

a = select(.data = surveys, plot_id, species_id, weight)
# select
head(select(surveys, plot_id, species_id, weight))
select(.data = surveys, plot_id, species_id, weight) %>% head()
# %>% 파이프라인 사용하는 방법

filter(.data = surveys, year == 1995) %>% head()
filter(.data = surveys, year >= 1995 & weight > 20) %>% head()
filter(.data = surveys, year >= 1995 , weight > 20) %>% head()
# and 연산은 &와 , 로

filter(.data = surveys, year >= 1995 , weight > 20) %>% head(n = 2)

surveys %>%
  filter( !is.na(weight) ) %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight) %>% head()
# weight가 NA인거 제외
# weight가 5미만만 가져와서
# wpecies_id, sex, weight의 head만 보여라

surveys_ex <- surveys %>% filter( !is.na(surveys$weight)) %>%
  mutate(weight_kg = weight / 1000) 
# 컬럼 추가할때 mutate를 사용하면 된다.

surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
# group화 한 후 집계하기
# sex별로 weigth값의 평균을 계산

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
# sex와 species_id 별로 weight값의 평균을 계산

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            var_weight = var(weight),
            min_weight = min(weight),
            max_weight = max(weight)) %>%
  print(n = 5)
# sex, species_id 별로 그룹화 한 후 다양한 통계값 출력

surveys %>%
  group_by(sex) %>%
  tally()

surveys %>%
  group_by(plot_id, sex) %>%
  tally()
# tally는 집계의 개수를 센다.

surveys %>% arrange(month, plot_id) %>% head()
# plot_id 값의 오름차순으로 surveys 데이터를 정렬하여라.

surveys %>% arrange(desc(month), plot_id) %>% head()
# 먼저 month값을 내림차순으로 정렬하고 그 순서를 유지시키면서 plot_id 값의 
# 오름차순으로 surveys 데이터를 정렬하여라.







##### R reshape2 #####
if(!require(reshape2)){install.packages("reshape2"); library(reshape2)}
##### ...L melt #####
names(airquality) <-  tolower(names(airquality))
melt(data = airquality) %>% head(n=3)

names(airquality) <-  tolower(names(airquality))
aql <- melt(data = airquality, id.vars= c("month","day"))
head(aql, n = 3)

##### ...L dcast #####
knitr::include_graphics("./fig/reshape2-1.JPG")

aqw <- dcast(aql, month + day ~ variable, 
             value.var ="value")
aqw





##### text function #####
##### ...L paste #####
paste("감자로","만든","감자칩", sep='-')
paste("감자로","만든","감자칩", sep='')
paste("감자로","만든","감자칩")
paste(c("감자로 만든","고구마로 만든"), c("감자칩", "고구마칩"), sep=' ')
paste0(1:12, c("st", "nd", "rd", rep("th", 9)))
# trend분석은 누구나 하는것.
# 모델링을 해야지 의미가 잇는거. 그러나 불행하게도 모델링은 잘 안되...

paste0(1:12, collapse = "-")
paste(1:4,5:8, sep = ';')
paste(1:4,5:8, sep = ';', collapse = '-')
# collapse 란 뭉개다.. 뭐 그런 의미로..
# paste(sep="") = paste0()


paste(1:12, "")
paste0(1:12)


##### ...L grep #####
grep("pole", c("Equator", "North Pole", "South pole", "poles"))
# 어디에 들어있느냐

##### ...L nchar #####
nchar(c("South Pole", "한글 문자열", NA))
# char개수세기

##### ...L substr #####
substr("Equator", start=2, stop=4)
substr("한글 문자열 추출", start=2,stop=4)
substring("한글 문자열 추출", first=2)
# index몇번째부터 몇번째까지
# substring는 first부터 끝까지

##### ...L strsplit #####
strsplit("6-16-2011", split = '-')
strsplit("6*16*2011", split = '*')
strsplit("6*16*2011", split = '*', fixed = TRUE)
strsplit("6*16*2011", split = '\\*')
# 문자열을 지정한 문자열로 분리
# 이스케이프 문자를 문자로 보고싶은 경우 \\를 사용해서 이스케이프 문자를 문자로 본다
# 혹은 fixed == TRUE를 사용

strsplit(c("6-16-2011", "1-12-2-1-21-2-12-1-2-1-2"), split = '-')
# 리스트로 반환

list.files()
a = strsplit(list.files(), ".", fixed = TRUE)

tmp = c()
for ( i in 1:length(a))
{
  b = a[[i]]
  if (length(b) == 2)
  {
    tmp = c(tmp, tail(b, n = 1))
  }
}
table(tmp)



tmp = rep(NA, length(a))
for ( i in 1:length(a))
{
  b = a[[i]]
  if (length(b) == 2)
  {
    tmp[i] = tail(b, n = 1)
  }
}
table(tmp, na.rm = T)

tmp = c()
# tmp = rep(NA, length(a))
for (i in 1:length(a)){
  b = a[[i]]
  if (length(b) == 2){
    tmp = c(tmp, tail(b, n = 1))
    #tmp[i] = tail(b, n = 1)
  }
}
tmp

##### ...L regexpr #####
regexpr("감자", "맛있는 감자칩")
a <- regexpr("감자", "맛있는 감자칩")
attr(a, 'match.length')
attr(a, 'useBytes')
# 문자열 내에서 지정한 문자와 처음으로 일치한 위치를 알려주는 함수

##### ...L gregexpr #####
a <- gregexpr("감자", "머리를 감자마자 감자칩을 먹었다.")
a
attr(a[[1]], 'match.length')
# 문자열에서 지정한 문자/패턴과 일치한 모든 위치를 알려주는 함수
# 출력값이 list형임
# attr함수를 통해 결과값의 attribute값을 알 수 있다.


##### ...L gsub  #####
gsub(pattern = "감자", replacement='고구마',
     x= "머리를 감자마자 감자칩을 먹었다.")
gsub(pattern = "<br>", replacement='',
     x= "머리를 감자마자 <br>감자칩을 먹었다.")
# 어떤 패턴에 해당하는 문자열을 정해진 문자열로 대치하는 함수



##### 정규표현식 #####
##### ...L OR #####
strsplit('감자, 고구마, 양파 그리고 파이어볼', split ='(,)|(그리고)')
# OR은 |로 표현
# 문자열을 하나로 표현하기 위해 ()로 표현

grep(pattern = '^(감자)', x = '감자는 고구마를 좋아해')
grep(pattern = '^(감자)', x = '고구마는 감자를 안 좋아해')
# 생성패턴 : 처음에 ~로 시작하는 문자(기호는 '^'를 사용한다.)

grep(pattern = '(좋아해)$', x = '감자는 고구마를 좋아해')
grep(pattern = '(좋아해)$', x = '고구마는 감자를 안 좋아해')
# ~로 끝나는 문자열 (기호는 '$'를 사용한다.)

gregexpr(pattern = '[아자차카]', text = '고구마는 감자를 안 좋아해')
# 생성 패턴: 이중에 어느 하나라도 해당하는 문자열(기호는 []를 사용한다.)

gregexpr(pattern = '[(사과)(감자)(양파)]', text = '고구마는 감자를 안 좋아해')
gregexpr(pattern = '^[(사과)(감자)(양파)]', text = '고구마는 감자를 안 좋아해')
# []안에서는 ()작동을 안한다.

grep(pattern = '^[^(사과)(감자)(양파)]', x = '감자는 고구마를 좋아해')
# 생성 패턴: 다음을 제외한 나머지 중 어느 하나라도 해당하는 문자열
# [^]를 사용한다. (bracket 안쪽에 hat과 바깥쪽의 hat을 구별하여라.)

# [a-z] 알파벳 소문자 이외의 문자 중 아무것이나 1개
# [A-Z] 알파벳 대문자 이외의 문자 중 아무것이나 1개
# [0-9] 숫자 이외의 문자 중 아무것이나 1개
# [a-zA-Z] 알파벳 소문자나 대문자 중 아무것이나 1개
# [가-힣] 한글중에 아무거나 1개
# [^가-힣]

# [ab]{2, 4}의 경우 aaa bbb 는 가능, acb는 불가능

grep(pattern = '^ab{2,3}', x = 'ab')
grep(pattern = '^ab{2,3}', x = 'abab')
grep(pattern = '^ab{2,3}', x = 'abbb')
grep(pattern = '^(ab){2,3}', x = 'abab')
# ^ab{2,3}: 시작은 a로 시작하고 다음 b가 2번에서 3번까지 반복되는 패턴
# 소괄호.. 작동해 여기선

# abbreviation in {,}
# *: {0,}
# +: {1,}
# ?: {0,1}
# .: 어떠한 문자라도 1개

# []은 하나의 문자로 취급한다.........이게 중요하다는데....













