##### 7월 9일 #####

charset을 주로 봐라 인코딩 되어 있는 부분
내용은 바디에 주로 있다.
rvest로 불러온다.

if(!require(rvest)){install.packages('rvest') ; library(rvest)}

url_tvcast = 'http://tvcast.naver.com/jtbc.youth'
html_tvcast = read_html(x = url_tvcast, encoding = 'UTF-8')

# ------------------------
html_tvcast %>% html_nodes(".title a") %>% head(n=3)

# -----------------------
html_tvcast %>% html_nodes(".title a") %>% html_text()%>%head(n=3)

html_text()함수가 text만 가져오는듯.

html_tvcast %>% html_nodes("body.ch_home div#u_skip a") %>% html_text()

##### 예제1 #####

url_tvcast = 'https://tv.naver.com/mbc.kingloves'
html_tvcast = read_html(x = url_tvcast, encoding = 'UTF-8')

# ------------------------
html_tvcast %>% html_nodes(".title a") %>% head(n=3)

# -----------------------
html_tvcast %>% html_nodes(".title a") %>% html_text()%>%head(n=3)

# -----------------------
html_tvcast %>% html_nodes("a") %>% html_text()



url_tvcast = 'http://tv.naver.com/mbc.kingloves'
html_tvcast = read_html(x = url_tvcast, encoding = 'UTF-8')
html_tvcast %>% html_nodes(".title a") %>% html_text() %>% data.frame() %>% head(n = 3)


encoding의 경우 CP949 UTF-8 EuC-KR

url_tvcast = 'https://en.wikipedia.org/wiki/Student%27s_t-distribution'
html_wiki = read_html(x = url_tvcast, encoding = 'UTF-8')
html_wiki %>% html_nodes(".wikitable") %>% html_table()

#header = False 를 넣으면 첫줄이 제대로 붙는다.
MLB_base_url <- "http://www.baseball-reference.com/leagues/MLB/"
url <- paste0(MLB_base_url, "2017.shtml")
webpage <- read_html(url)
webpage %>% html_nodes("#teams_standard_batting") %>% html_table() %>% data.frame() %>% head(n = 1)

webpage %>% html_nodes('div#div_teams_standard_batting table') %>% 
  html_table() %>% data.frame() %>% head(n = 3)



years = 2008:2017
batting_table = vector("list", length(years))
names(batting_table) <- years
for (i in 1:length(years))
{
  url <- paste0(MLB_base_url, years[i],".shtml")
  webpage <- read_html(url)
  batting_table[[i]] <- webpage %>% html_nodes('div#div_teams_standard_batting table') %>% 
    html_table() %>% data.frame()
  batting_table[[i]] <- batting_table[[i]] <- batting_table[[i]][1:(nrow(batting_table[[i]])-3),]
  batting_table[[i]] <- batting_table[[i]][-1] <- Map(as.numeric, batting_table[[i]][-1])
  cat(i, "\n")
}


##### 기상청 #####

url = "http://www.weather.go.kr/weather/observation/currentweather.jsp?auto_man=m&type=t99&tm=2017.09.06.13%3A00&x=19&y=3"
webpage <- read_html(url, encoding = "EUC-KR")

Sys.setlocale("LC_ALL", "Korean")

webpage %>% html_nodes("table.table_develop3")
tmp <- webpage %>% html_nodes("table.table_develop3") %>% 
  html_table(header = FALSE, fill=TRUE)%>%
  data.frame()
head(tmp)

# fill은 true인 경우 결측치로 받는다.

url = "http://www.weather.go.kr/weather/observation/currentweather.jsp?auto_man=m&type=t99&tm=2017.09.06.13%3A00&x=19&y=3"
webpage <- read_html(url, encoding = "EUC-KR")

Sys.setlocale("LC_ALL", "English")

webpage %>% html_nodes("table.table_develop3")
tmp <- webpage %>% html_nodes("table.table_develop3") %>% 
  html_table(header = FALSE, fill=TRUE)%>%
  data.frame()
head(tmp)

# -----------------------
Sys.setlocale("LC_ALL", "Korean")
# 받아들이는 시스템상의 인코딩인듯...?
for(i in 1:ncol(tmp)){
  tmp[,i] = rvest::repair_encoding(tmp[,i])
}
head(tmp)



##### 네이버 영화 #####
if(!require(httr)){install.packages('httr') ; library(httr)}

url = paste0("https://movie.naver.com/movie/point/af/list.nhn?&page=1")
mov_html = read_html(GET(url), Encoding = "UTF-8")

content = html_nodes(mov_html, '.title') %>% html_text()
content = gsub('\n|\t|<.*?>|&quot;','',content)
# gsub 패턴 찾아서 바꿈..줄바꿈문자 탭문자 태크부분 지우고 html따옴표 지우고 ''로 바꾸겠다.

sub_con = strsplit(content, "\r")
data.frame(do.call(rbind, lapply(sub_con, function(x) {x[x != "" & x != "신고"]}))) %>% head(3)

total_con = NULL

for(i in 1:10){
  url = paste0("https://movie.naver.com/movie/point/af/list.nhn?&page=",i)
  mov_html = read_html(GET(url), encoding = "CP949")
  
  content = html_nodes(mov_html, '.title') %>% html_text()
  content = gsub('\n|\t|<.*?>|&quot;','',content)
  
  part_con = data.frame(do.call(rbind, 
                                lapply(strsplit(content, "\r"), function(x) {x[x != "" & x != "신고"]})))
  
  total_con = rbind(total_con, part_con)
  
  cat(i, "\n")
}


# Application interface: 서버컴퓨터가 어떤 서비스를 제공하기 위해서 클라이언트 
# 컴퓨터와 데이터를 주고 받기 위한 메세지 형식
# API를 이용하여 클라이언트 컴퓨터가 서버 컴퓨터에게 메세지를 보내고, 정해진 형식에 맞춰 
# 데이터를 받게 됨.
# 검색 API를 받아보자


##### 웹 api #####
client_id = 'hmrFwapSOkbeP3DyPdkF';
client_secret = 'mPgS5i94vl';
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret)

url = "https://openapi.naver.com/v1/search/blog?query="

query = '새우깡'
# encoding 변화
query = iconv(query, to = 'UTF-8', toRaw = T)
# iconv(query, to = "UTF-8", toRaw = F)
# query를 row형태로 변환
query = paste0('%', paste(unlist(query), collapse = '%'))
query = toupper(query)
query

if(!require(httr)){install.packages("httr"); library(httr)}

end_num = 1000
display_num = 100
start_point = seq(1,end_num,display_num)
i = 1
url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',
             query,'&display=',display_num,'&start=',
             start_point[i],'&sort=sim')
url
url_body = read_xml(GET(url, header))
# get방식으로 불러온다.
url_body = read_xml(GET(url))
# header를 넣지않으면 권한이 없다고 안보내준다.

title = url_body %>% xml_nodes('item title') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
bloggername = url_body %>% xml_nodes('item bloggername') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
postdate = url_body %>% xml_nodes('postdate') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
link = url_body %>% xml_nodes('item link') %>% xml_text()
#  필요한 부분만 찾아오는거 xml_nodes
description = url_body %>% xml_nodes('item description') %>% html_text()




##### 웹 api 아시아나로 해보기 #####
client_id = 'hmrFwapSOkbeP3DyPdkF';
client_secret = 'mPgS5i94vl';
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret)

url = "https://openapi.naver.com/v1/search/blog?query="
query = "아시아나"
query = iconv(query, to = 'UTF-8', toRaw = T)
query = paste0('%', paste(unlist(query), collapse = '%'))
query = toupper(query)

if(!require(httr)){install.packages("httr"); library(httr)}

end_num = 1000
display_num = 100
start_point = seq(1,end_num,display_num)
i = 1
url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',
             query,'&display=',display_num,'&start=',
             start_point[i],'&sort=sim')

url_body = read_xml(GET(url, header))

description = url_body %>% xml_nodes('item description') %>% html_text()


mat_list = list()
mat_list[[1]]<-matrix(1:9, 3, 3)
mat_list[[2]]<-matrix(1:9 + 1, 3, 3)
mat_list[[3]]<-matrix(1:9 + 2, 3, 3)
apply(mat_list[[1]], 1, sum)
apply(mat_list[[2]], 1, sum)
lapply(list(1:3, 4:6), sum)

mat_list_neg = Map("-", mat_list)
# Map은 하나하나 함수를 적용시킨다?
Reduce("+", mat_list_neg)
# 하나하나 더해주는 함수래요 reduce는
do.call(rep, list(x = 1:3, each = 3))
rep(x = 1:3, each = 3)







