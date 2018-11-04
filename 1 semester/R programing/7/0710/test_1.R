##### 7월 10일 text_function #####
# 스크랩핑 중요
# 텍스트의 패턴을 정의하는  --  정규표현식 중요
# 
# Text를 거리공간으로 맵핑을 한다.
# 2차원공간으로 맵핑
# ->'word embeding'라고 한다.
# word embeding 종류 1. wordtovec(구글), 2. fastext(페북)
# 
# 좌표로 넣으면 연속형 변수로 넣어진다. 즉 변경
# 연속형 변수를 원하는 모든 모델링 가능하다.
# 
# []는 하나의 문자다.
# ^시작[1-9] 한글자인데 1부터 9까지[1-9]또 한글자인데 1부터 9*는 올수도 있고 안올수도 있다.
# $는 그것으로 끝나는 패턴.
# 
# ()자연수 0을 포함한 자연수
# {}반복{1, 2} 1번에서 2번 반복
# ?와도 되고 안와도 되고

# ^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*$
# 1. 시작과 끝 확인
# jj.__.jeon@gmail.kr.com
# 은 생성된 패턴에 포함되는
# jj. = ^[_a-z0-9-]
# .__.jeon = (\\.[_a-z0-9-]+)
# +가 반복인듯
# gmail = @[a-z0-9-]+ 5번 반복

hw <- "Hadley Wickham"

# R로 시작하고 exe로 끝나는거
# ^R[a-z/0-9]*(.exe)+$  /0이거 공집합 같은 모양임.

if(!require(stringr)){install.packages("stringr"); library(stringr)}

fruit <- c("apple", "banana", "pear", "pinapple")
str_detect(fruit, "^a")

fruit[str_detect(fruit, "^a")]

shopping_list <- c("apples x4", "flour", "sugar", "milk x2")
str_extract(shopping_list, "\\d")
# 숫자로 표현된 부분을 가져와라.

shopping_list <- c("apples x244", "flour", "sugar", "milk x2")
str_extract(shopping_list, "(\\d)+")
str_extract(shopping_list, "[0-9]+")
# 1개 초과도 된다.

shopping_list <- c("apples x244 607", "flour사과", "맛잇sugar", "milk x2")
str_extract_all(shopping_list, "[0-9]+")
str_extract(shopping_list, "[가-힣]+")
# 이렇게하면 리스트로 변환 되서 나온다.

fruits <- c("one apple", "two pears", "three bananas")
str_replace(fruits, "[aeiou]", "-")
str_replace_all(fruits, "[aeiou]", "-")
# replace 바꾸는법


# 인터넷 태그를 표현하는 정규표현식
# http://maedoop.dothome.co.kr/2231 여기에 좋게 잘 되있네

strsplit("6lk-  0-  0-  --  00", split = "\\t")
strsplit("6lk-  0-  0-  --  00", split = "\\n")
strsplit("6lk-  0-  0-  --  00", split = "\\d")
strsplit("6lk-  0-  0-  --  00", split = "[0-9]")

strsplit("6-16-2011", split = '-')
# 문자열을 지정한 문자로 분리시켜주는 함수
strsplit("6*16*2011", split = '*')
# 특수문자를 이용한 분리


# gsub 어떤 패턴에 해당하는 문자열을 정해진 문자열로 바꿔라



# ()는 문자열을 하나로 취급한다.

# "[아자차카]" 하나의 문자이다. 그러나 4개가 된다.
# [아자]{2} 는 2개의 문자. 2회반복인듯..?

# (ab){2}랑 ab{2}는 다른의미이다.
# abab , abb 이렇게 달름.

# \\. .으로 시작하고..
# *는 반복이 0번부터임







##### 텍스트 마이닝 #####
# 1. 빈도분석
# 2. 연관분석
# 3. 주제 모형화
# 4. 텍스트데이터로부터 정보 추출
# 5. 텍스트요약

# sampling bias
# 1. 전문가가 필요
# 2. 마그넷 키워드의 선정이 매우 중요
# 3. 키워드를 잡고 하위키워드를 마그넷 키워드라고 하는듯.(seed keyword)
# 4. 얘를 가지고 데이터수집을 하는것.
# ----수집이 매우 중요하다. 작업의 70%정도 수준..

?readLines
?file
con <- url("http://ranking.uos.ac.kr")
a <- readLines(con=con)
close(con)
str(a)
a[10:30]


##### 스크랩핑 #####
if(!require(rvest)){install.packages('rvest') ; library(rvest)}
if(!require(httr)){install.packages("httr"); library(httr)}

url_tvcast = 'http://tvcast.naver.com/jtbc.youth'
html_tvcast = read_html(x = url_tvcast, encoding = 'UTF-8')

html_tvcast %>% html_nodes(".title a") %>% html_text() %>% head(n=3)



# 1. 페이지마다 다르게 크롤링을 해야한다. 페이지 구조가 다르다.
# 2. 크롤링은 유지보수해야된다. (웹페이지 보수로 인해서)
# 3. 크롤링을 자주하면 서버에서 보안상 막는다.(우회해야 한다.)
# ...L AWS에 X대 등록한다. 여러개의 가상머신(여러개의 OS).. 여러개의
# 인터넷 익스플로러, 크롬, 파이어폭스...등등으로 돌리면 여러사람으로 인식
# 시킬 수 있음. 계속하는건 좀.. 아니래.. + 규칙 지키면서





##### 오늘의 하이라이트 #####
# 1. API, crawling를 통해 : data collection 을 한다.
# 2. dplyr 을 통해 : data structure를 구성(분석 목적에 맞게)
# 3. analysis(lm, glm, svm, lasso, nnet)
# 4. result 는 : visualization(ggplot, plot, ggmap)
# 이게 analysis system



# system이 된다...
# batch작업만 이야기해줬어...
# analysis랑 시각화랑 같이 자동화하고 싶다는 느낌...
# 근데 analysis가 heavy한 작업이기 때문에~
# 작업을 더 확장을 하고 싶다. 
# 시각화 + 모델링 + preprocessing까지 전처리까지 이것까지 확장
# 얼마나 더 많은 사람에게 서비스 할거냐 라는 문제..
# 예산에 따른... 부분도 있은듯.











