# 대기오염 정보 조회 서비스 api ----

if(!require(httr)){install.packages("httr"); library(httr)}
if(!require(rvest)){install.packages("rvest"); library(rvest)}
if(!require(xml2)){install.packages("xml2"); library(xml2)} # 출력값을 xml형식으로 저장

url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
             "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
             # 여기부터 get방식을 이용한 쿼리문
             "sidoName=서울",
             "&searchCondition=DAILY",
             "&pageNo=",1,
             "&numOfRows=",25,
             "&ServiceKey=", 'np%2Fap7UocR0g16JZJidxa5sRkqO79zaJgmahJrxeDmSPLuB0Egg4971rKeB5SvyzK%2FeGd2xbBN14it2GT5P4ZQ%3D%3D')

url_get = GET(url)
# get으로 읽었다. 가이드북보면 get으로 읽으라고 되어 있다.
url_xml = read_xml(url_get)
# xml로 제공하고 있으니까 xml로 읽었다.
url_xml

item_list = xml_nodes(url_xml, 'items item')
item_list[[1]]

tmp_item = xml_children(item_list[[1]])
tmp_item
tmp_item = xml_text(tmp_item)
tmp_item

item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
# item_list에 차곡차곡 붙었다.

item_dat = do.call('rbind',item_list)
item_dat = data.frame(item_dat, stringsAsFactors = F)
head(item_dat)
# 원하는 형식으로(테이블 형식) 만든다.

tmp = xml_nodes(url_xml, 'items item') 
colnames_dat = html_name(xml_children(tmp[[1]]))
colnames_dat

colnames(item_dat) = colnames_dat
head(item_dat)

air_data = NULL
while(1)
{
  url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
               "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
               "sidoName=서울",
               "&searchCondition=DAILY",
               "&pageNo=",1,
               "&numOfRows=",600,
               "&ServiceKey=",'np%2Fap7UocR0g16JZJidxa5sRkqO79zaJgmahJrxeDmSPLuB0Egg4971rKeB5SvyzK%2FeGd2xbBN14it2GT5P4ZQ%3D%3D')
  url_xml = read_xml(GET(url))
  item_list = url_xml %>% xml_nodes('items item')
  item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
  item_dat = do.call('rbind',item_list)
  item_dat = data.frame(item_dat, stringsAsFactors = F)
  names(item_dat) <- colnames_dat
  air_data = rbind(item_dat, air_data)
  Sys.sleep(3600)
  write.csv(air_data, "air_data.csv", row.names = F)
  cat(item_dat$dataTime[1],'\n')
}

air_data = NULL
for(i in 1:24)
{
  url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
               "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
               "sidoName=서울",
               "&searchCondition=DAILY",
               "&pageNo=",i,
               "&numOfRows=",25,
               "&ServiceKey=",'np%2Fap7UocR0g16JZJidxa5sRkqO79zaJgmahJrxeDmSPLuB0Egg4971rKeB5SvyzK%2FeGd2xbBN14it2GT5P4ZQ%3D%3D')
  url_xml = read_xml(GET(url))
  item_list = url_xml %>% xml_nodes('items item')
  item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
  item_dat = do.call('rbind',item_list)
  item_dat = data.frame(item_dat, stringsAsFactors = F)
  air_data = rbind(item_dat, air_data)
}

# Shiny ----
rm(list=ls())
gc()

library(shiny)

ui = fluidPage(
  titlePanel("Welcome shiny!"),
  sidebarLayout(
    sidebarPanel(
      textInput("input_text", "텍스트를 입력하세요.")
    ),
    mainPanel(
      textOutput("output_text")
    )
  )
)


server = function(input, output)
# start name을 input, output으로 써야됨. 정해진 변수
{
  output$output_text = renderText({
    input$input_text
  })
}
# reactive ui에서 가져옴, render은 sever에서 가져옴

shinyApp(ui = ui, server= server)

ui = fluidPage(
  headerPanel('Iris k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(iris)),
    selectInput('ycol', 'Y Variable', names(iris),
                selected=names(iris)[[2]]),
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 9),
    checkboxInput('center_tf','Center points')
  ),
  mainPanel(
    plotOutput('plot1')
  )
)
shinyApp(ui = ui, server= server)

server = function(input, output)
{
  selectedData = reactive({
    iris[, c(input$xcol, input$ycol)]
  })
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    if(input$center_tf) points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
}
shinyApp(ui = ui, server= server)

# 서버로 받아드릴땐 reactive로 받아드리고, 다시 부를땐 render로 호출한다.



# Shiny web page using fine dust data ----
url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
             "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
             "sidoName=서울",
             "&searchCondition=DAILY",
             "&pageNo=",1,
             "&numOfRows=",600,
             "&ServiceKey=",'np%2Fap7UocR0g16JZJidxa5sRkqO79zaJgmahJrxeDmSPLuB0Egg4971rKeB5SvyzK%2FeGd2xbBN14it2GT5P4ZQ%3D%3D')
url_xml = xml(GET(url))
item_list = url_xml %>% xml_nodes('items item')
item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
item_dat = do.call('rbind',item_list)
item_dat = data.frame(item_dat, stringsAsFactors = F)
item_dat[item_dat == '-'] = 0
tmp = xml_nodes(url_xml, 'items item') 
colnames_dat = xml_tag(xml_children(tmp[[1]]))
colnames(item_dat) = colnames_dat
# 웹api로 데이터를 받아와 데이터프레임으로 만드는 과정

library(ggmap)
uniq_region = unique(item_dat$cityName)
geo_dat = geocode(paste("서울특별시", uniq_region))
geo_dat = cbind(cityName = uniq_region, geo_dat)
head(geo_dat)
# 각 구의 위치 정보를 얻기 위해서 ggmap 패키지 호출
# ggmap패키지의 geocode()를 이용한 구별 위경도 수집

item_dat = merge(item_dat, geo_dat, by = "cityName")
head(item_dat)
write.csv(item_dat, 'C:/workspace/R/7/0726/air_quality.csv', row.names = F)
dat = read.csv('C:/workspace/R/7/0726/air_quality.csv', stringsAsFactors = F)
head(dat)
# 기존에 수집한 item_dat와 geo_dat를 merge
# merge한 데이터를 'air_quality.csv' 파일로 저장

ui = fluidPage(
  titlePanel("Air quality data visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput('region', 'cityName', choices = sort(unique(dat$cityName))),
      selectInput('date', 'dataTime', choices = sort(unique(dat$dataTime))),
      selectInput('category', 'category', choices = colnames(dat)[3:8])
    ),
    mainPanel(
      plotOutput("hist1"),
      plotOutput("hist2")
    )
  )
)
server = function(input, output)
{
  return(NULL)
}
shinyApp(ui = ui, server = server)

server = function(input, output)
{
  selectedData1 = reactive({
    dat[dat$dataTime == input$date, c(input$category)]
  })
  selectedData2 = reactive({
    dat[dat$cityName == input$region, c(input$category)]
  })
  output$hist1 = renderPlot({
    hist(selectedData1(), main = "선택된 시간의 미세먼지", xlab = "", ylab = "",
         col = rainbow(9))
  })
  output$hist2 = renderPlot({
    hist(selectedData2(), main = "선택된 구의 미세먼지", xlab = "", ylab = "",
         col = rainbow(9))
  })
}
shinyApp(ui = ui, server = server)

ui = fluidPage(
  titlePanel("Air quality data visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput('date', 'dataTime', choices = sort(unique(dat$dataTime))),
      selectInput('category', 'category', choices = colnames(dat)[3:8]),
      sliderInput('bins', 'detalied density', min = 5, max = 30, value = 10)
    ),
    mainPanel(
      plotOutput("mapplot"),
      tableOutput("tt")
    )
  )
)
server = function(input, output)
{
  return(NULL)
}
shinyApp(ui = ui, server = server)

library(ggmap)
server = function(input, output)
{
  map_dat = reactive({
    tmp_dat = dat[dat$dataTime == input$date, c(input$category, "lon", "lat")]
    
    values = tmp_dat[,c(input$category)]
    min_value = min(values[values != 0])
    values = values / min_value  
    tmp_dat[,c(input$category)] = values
    with(tmp_dat, tmp_dat[rep(1:nrow(tmp_dat), tmp_dat[,c(input$category)]),])
  })
  map = ggmap(get_googlemap(center = c(lon = 127.02, lat = 37.53),
                            zoom = 11,
                            maptype = "roadmap",
                            color = "bw"))
  # map이 아니라 이런식으로 가져오겠다는 의미
  # 실행은 아래 구문으로 실행
  output$mapplot = renderPlot({
    map  + stat_density2d(aes(x = lon, y = lat, alpha = ..level..),
                          data = map_dat(),
                          size= 2,
                          bins= input$bins,
                          geom="polygon") +
      scale_alpha(range = c(0, 0.3))
  }, height = 1200, width = 1024)
}
shinyApp(ui = ui, server = server)


map_dat = reactive({
  tmp_dat = dat[dat$dataTime == input$date, c(input$category, "lon", "lat")]
  
  values = tmp_dat[,c(input$category)]
  min_value = min(values[values != 0])
  values = values / min_value  
  tmp_dat[,c(input$category)] = values
  with(tmp_dat, tmp_dat[rep(1:nrow(tmp_dat), tmp_dat[,c(input$category)]),])
})
with(tmp_dat, tmp_dat[rep(1:nrow(tmp_dat), tmp_dat[,c(input$category)]),])

# ui에서 입력한 input 값을 통해 데이터를 추출
# 
# 입력한 시간이 dataTime과 일치하는 데이터를 추출
# 확인하고자 하는 미세먼지 데이터와 위 경도 데이터를 추출
# 추출된 데이터를 시각화에 편리하도록 정제
# 
# 미세먼지 데이터는 그 크기가 다양하여 같은 weight를 주기 어려움
# 추출된 미세먼지 column에서 0을 제외한 최소값을 계산
# 각 구별 데이터를 최소값으로 나누어 미세먼지 데이터를 비율로 변경

# reactive 객체를 통해서 위의 값을 출력
# plot을 그리기 위해서 미세먼지 데이터의 비율을 가중치로 사용
# 데이터의 최소값에 대한 비율만큼 데이터를 반복하여 가중치 생성













