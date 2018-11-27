install.packages("yaml")
devtools::install_version("binman")
devtools::install_version("wdman")
devtools::install_github("ropensci/RSelenium")

if(!require(rvest)){install.packages('rvest') ; library(rvest)}
if(!require(httr)){install.packages('httr') ; library(httr)}
if(!require(RSelenium)){install.packages('RSelenium') ; library(RSelenium)}
if(!require(dplyr)){install.packages('dplyr') ; library(dplyr)}


client_id = 'hmrFwapSOkbeP3DyPdkF';
client_secret = 'mPgS5i94vl';
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret)

query = '비트코인'
# encoding 변화
query = iconv(query, to = 'UTF-8', toRaw = T)
query = paste0('%', paste(unlist(query), collapse = '%'))
query = toupper(query)
query


# url = "https://openapi.naver.com/v1/search/blog?query=" 
# 블로그
url = "https://openapi.naver.com/v1/search/news.xml?query="
  # "%EC%A3%BC%EC%8B%9D&display=10&start=1&sort=sim"

end_num = 1000
display_num = 100
start_point = seq(1,end_num,display_num)
i = 1
url = paste0('https://openapi.naver.com/v1/search/news.xml?query=',
             query,'&display=',display_num,'&start=',
             start_point[i],'&sort=sim')
url

url_body = read_xml(GET(url, header))
# get방식으로 불러온다.
# url_body = read_xml(GET(url))
# header 헤더, id, pw부분 없으면 불러와지질 않음

title = url_body %>% xml_nodes('item title') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
bloggername = url_body %>% xml_nodes('item bloggername') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
postdate = url_body %>% xml_nodes('postdate') %>% xml_text()
# 필요한 부분만 찾아오는거 xml_nodes
link = url_body %>% xml_nodes('item link') %>% xml_text()
#  필요한 부분만 찾아오는거 xml_nodes
description = url_body %>% xml_nodes('item description') %>% html_text()


final_dat = NULL
for(i in 1:length(start_point))
{
  # request xml format
  url = paste0('https://openapi.naver.com/v1/search/news.xml?query=',query,
               '&display=',display_num,'&start=',start_point[i],'&sort=sim')

  #option header
  url_body = read_xml(GET(url, header), encoding = "UTF-8")
  title = url_body %>% xml_nodes('item title') %>% xml_text()
  # bloggername = url_body %>% xml_nodes('item bloggername') %>% xml_text() 블로그
  # postdate = url_body %>% xml_nodes('postdate') %>% xml_text() 블로그
  pubDate = url_body %>% xml_nodes('pubDate') %>% xml_text()
  link = url_body %>% xml_nodes('item link') %>% xml_text()
  description = url_body %>% xml_nodes('item description') %>% html_text()
  temp_dat = cbind(title, pubDate, link, description)
  final_dat = rbind(final_dat, temp_dat)
  cat(i, '\n')
}

final_dat <- as.data.frame(final_dat)
head(final_dat)

?write.table
?write.csv
write.table(final_dat, 'C:/workspace/R/7/study_scraping/scraping_dat')
write.csv(scraping_dat, 'C:/workspace/R/7/study_scraping/scraping_dat2')
write.csv(final_dat, 'C:/workspace/R/7/study_scraping/scraping_dat3')

scraping_dat <- read.csv('C:/workspace/R/7/study_scraping/scraping_dat2.csv',
                         sep = ',')

head(scraping_dat)
# 그냥 누적데이터 형태소






# url을 사용해서 discription 가져오기
html_url = 'http://www.thebigdata.co.kr/view.php?ud=201807220130023419edd30e1eac_23'
html_url = read_html(x = html_url, encoding = 'UTF-8')
html_url %>% html_nodes(".") %>% html_text()


html_url = 'http://www.nbnnews.co.kr/news/articleView.html?idxno=156908'
html_url = read_html(x = html_url, encoding = 'UTF-8')
html_url %>% html_nodes("#article-view-content-div") %>% html_text() %>% head(n=3)


html_url = 'http://www.sisamagazine.co.kr/news/articleView.html?idxno=135694#08zx'
html_url = read_html(x = html_url, encoding = 'UTF-8')
html_url = read_html(x = html_url, encoding = 'cp949')
html_url %>% html_nodes(".content border-box") %>% html_text() %>% head(n=3)







