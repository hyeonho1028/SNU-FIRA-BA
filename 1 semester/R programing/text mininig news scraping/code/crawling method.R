if(!require(OpenStreetMap)){install.packages("OpenStreetMap");library(OpenStreetMap)}
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}

map = OpenStreetMap::openmap(upperLeft = c(43, 119), 
                             lowerRight = c(33, 134), type = 'bing')
plot(map)
autoplot(map)
# x와 y축의 좌표계를 볼 수 있는 함수

nm = c("osm", "mapbox", "stamen-toner", 
       "stamen-watercolor", "esri", "esri-topo", 
       "nps", "apple-iphoto", "osm-public-transport")
# 하나하나의 맵타입을 가리키는 character

par(mfrow=c(3,3),  mar=c(0, 0, 0, 0), oma=c(0, 0, 0, 0))

for(i in 1:length(nm)){
  map <- openmap(c(43,119),
                 c(33,134),
                 minNumTiles = 3,
                 type = nm[i])
  plot(map, xlab = paste(nm[i]))
}
par(mfrow = c(1, 1))

map1 <- openmap(c(43.46,119.94),
                c(33.22,133.98))
plot(map1) 
abline(h = 38, col = 'blue')
# 좌표계가 다르기 때문에 아무런 일이 일어나지 않는다
abline(h = 4500000, col = 'blue', lwd = 2)

str(map1)
# tiles 와 bbox로 구성이 되어 있다.
# tiles는 colordata(rgbcolor), bbox가 또 있는데 밑과 같다.
# projection은 구 위에 있는 어떤 정보를 2차원 평면상에 어떻게 하는가, sp라는 
# 패키지에서 관리한다. slot는 어떤 체인이라고 할 수 있다. 리스트와 유사한 기능
# 슬롯을 참조할때는 @를 사용한다. merc라는 방법으로 좌표게를 옮겼다
map1$tiles[[1]]$projection
# projection arugemt가 관심사
# bbox는 p1, p2 / 


map1$tiles
autoplot(map1)
map1$tiles[[1]]$projection

if(!require(sp)){install.packages("sp"); library(sp)}
# 좌표계를 바꾸는 공식
map_p <- openproj(map1, projection = CRS("+proj=longlat"))
str(map_p)
map_p$tiles[[1]]$projection

plot(map_p)
autoplot(map_p)
abline(h = 37.5, lwd = 2, col = 'blue')


map_p <- openproj(map1, projection = 
                    CRS("+proj=utm +zone=52N + datum=WGS84"))
plot(map_p)
abline(h = 4150000, lwd = 2, col = 'blue')
str(map_p)



# Coordinate Reference System ----
# 좌표게 생성
# 1. 좌표계변환 (sp 라이브러리의 활용)
# 2. 좌표 데이터프레임 생성
# 3. sp 클래스로 변환
# 4. projection 설정
# 5. 좌표계 변환
# 6. 지도위에 매핑
if(!require(sp)){install.packages("sp"); library(sp)}

a  <-data.frame(lon =  seq(100,140,by = 0.1), lat =  38) # 2번단계
sp::coordinates(a) = ~ lon + lat                         # 3번단계
str(a)
sp::proj4string(a) = "+proj=longlat"                     # 4번단계
#a@proj4string  = CRS("+proj=longlat")
str(a)

a_tf = spTransform(a,  CRS("+proj=utm +zone=52N + datum=WGS84")) # 5번단계
str(a_tf)

plot(map_p)
points(a_tf@coords[,1], a_tf@coords[,2], type = 'l', col = 'blue')  #6번단계


# Pie chart on openmap ----
if(!require(sp)){install.packages("sp"); library(sp)}
if(!require(mapplots)){install.packages("mapplots"); library(mapplots)}
if(!require(OpenStreetMap)){install.packages("OpenStreetMap"); library(OpenStreetMap)}
if(!require(ggmap)){install.packages("ggmap"); library(ggmap)}


map = openmap(upperLeft = c(43, 119),lowerRight = c(33, 134))
seoul_loc = geocode('Seoul')
coordinates(seoul_loc) = ~lon + lat
proj4string(seoul_loc) = "+proj=longlat +datum=WGS84" 
seoul_loc_Tf = spTransform(seoul_loc,
                           CRS(as.character(map$tiles[[1]]$projection)))
plot(map)
add.pie(z=1:2,labels = c('a','b'),
        x = seoul_loc_Tf@coords[1],
        y = seoul_loc_Tf@coords[2], radius = 100000)



# ggmap ----
if(!require(ggmap)){install.packages("ggmap"); library(ggmap)}
data(crime)
head(crime, 2)

violent_crimes = subset(crime,
                        offense != "auto theft" & 
                          offense != "theft" & 
                          offense != "burglary")
violent_crimes$offense <- factor(violent_crimes$offense,
                                 levels = c("robbery", 
                                            "aggravated assault", "rape", "murder"))
violent_crimes = subset(violent_crimes,
                        -95.39681 <= lon & lon <= -95.34188 &
                          29.73631 <= lat & lat <=  29.78400)


HoustonMap = qmap("houston", zoom = 14,
                  color = "bw", legend = "topleft")
HoustonMap + geom_point(aes(x = lon, y = lat,
                            colour = offense, size = offense),
                        data = violent_crimes)
# qmap함수 사용

HoustonMap +
  geom_point(aes(x = lon, y = lat,
                 colour = offense, size = offense),
             data = violent_crimes) +
  geom_density2d(aes(x = lon, y = lat), size = 0.2 , bins = 4, 
                 data = violent_crimes)

HoustonMap +
  geom_point(aes(x = lon, y = lat,
                 colour = offense, size = offense),
             data = violent_crimes) +
  geom_density2d(aes(x = lon, y = lat), size = 0.2 , bins = 4, 
                 data = violent_crimes) +
  stat_density2d(aes(x = lon, y = lat,
                     fill = ..level..,  alpha = ..level..),
                 size = 2 , bins = 4,
                 data = violent_crimes,geom = "polygon")


# exercise ----
load('C:/workspace/code_JJJ/data/airport.Rdata')
head(airport_krjp)
head(link_krjp)

map = ggmap(get_googlemap(center = c(lon=134, lat=36),
                          zoom = 5, maptype='roadmap', color='bw'))
map + geom_line(data=link_krjp,aes(x=lon,y=lat,group=group), 
                col='grey10',alpha=0.05) + 
  geom_point(data=airport_krjp[complete.cases(airport_krjp),],
             aes(x=lon,y=lat, size=Freq), colour='black',alpha=0.5) + 
  scale_size(range=c(0,15))




# exercise2 ----
if (!require(sp)) {install.packages('sp'); library(sp)}
if (!require(gstat)) {install.packages('gstat'); library(gstat)}
if (!require(automap)) {install.packages('automap'); library(automap)}
if (!require(rgdal)) {install.packages('rgdal'); library(rgdal)}
if (!require(e1071)) {install.packages('e1071'); library(e1071)}
if (!require(dplyr)) {install.packages('dplyr'); library(dplyr)}
if (!require(lattice)) {install.packages('lattice'); library(lattice)}
if (!require(viridis)) {install.packages('viridis'); library(viridis)}

seoul032823 <- read.csv ("C:/workspace/code_JJJ/data/seoul032823.csv")
head(seoul032823)

skorea <- raster::getData(name ="GADM", country= "KOR", level=2)
# 지도데이터베이스에서 코리아 레벨2라고 받으면, 지도정보가 들어오게 된다.
# 행정구역도 약간은 포함하고 있다.
# skorea <- readRDS("KOR_adm2.rds")
head(skorea,2)

# -------------------------------------------
class(skorea)
head(skorea@polygons[[1]]@Polygons[[1]]@coords, 3)
# 이 점들을 라인으로 잇는다.
# -------------------------------------------
if (!require(broom)) {install.packages('broom'); library(broom)}

skorea <- broom::tidy(skorea)
# tidy함수를 통해 dcast랑 비슷하지만, 데이터프레임으로 변환
class(skorea)
head(skorea,3)

# -------------------------------------------
ggplot() + geom_map(data= skorea, map= skorea,
                    aes(map_id=id,group=group),fill=NA, colour="black") +
  geom_point(data=seoul032823, aes(LON, LAT, col = PM10),alpha=0.7) +
  labs(title= "PM10 Concentration in Seoul Area at South Korea",
       x="Longitude", y= "Latitude", size="PM10(microgm/m3)")
# geom_map 함수를 이용하여, GADM 데이터를 지도위에 plotting
# geom_point 함수를 이용하여, 미세먼지 데이터를 점으로 표기
# 보다 나은 시각화를 위해 점과 점 사이에 미세먼지 값의 내삽


# -------------------------------------------
class(seoul032823)
coordinates(seoul032823) <- ~LON+LAT
class(seoul032823)
# coordinates를 생성

# -------------------------------------------
LON.range <- c(126.5, 127.5)
LAT.range <- c(37, 38)
seoul032823.grid <- expand.grid(
  LON = seq(from = LON.range[1], to = LON.range[2], by = 0.01),
  LAT = seq(from = LAT.range[1], to = LAT.range[2], by = 0.01))

# -------------------------------------------
plot(seoul032823.grid)
points(seoul032823, pch= 16,col="red")


# -------------------------------------------
coordinates(seoul032823.grid)<- ~LON+LAT ## sp class
gridded(seoul032823.grid)<- T
plot(seoul032823.grid)
points(seoul032823, pch= 16,col="red")
# 할당하고 제대로 그리고 찍는다.

# -------------------------------------------
if(!require(automap)){install.packages("autoKrige"); library(automap)}

seoul032823_OK <- autoKrige(formula = PM10~1,
                            input_data = seoul032823,
                            new_data = seoul032823.grid )

# -------------------------------------------
head(seoul032823_OK$krige_output@coords, 2)
head(seoul032823_OK$krige_output@data$var1.pred,2)
# 새로 만든 격자, 아래의 데이터는 예측값/짝이된다. 짝을 맞춰서 

# -------------------------------------------
myPoints <- data.frame(seoul032823)
myKorea <- data.frame(skorea)
myKrige <- data.frame(seoul032823_OK$krige_output@coords, 
                      pred = seoul032823_OK$krige_output@data$var1.pred)   
# 짝을 맞춰서 이 데이터프레임을 만든다.

# -------------------------------------------
if(!require(viridis)){install.packages("viridis"); library(viridis)}

ggplot()+ theme_minimal() +
  geom_tile(data = myKrige, aes(x= LON, y= LAT, fill = pred)) +
  # tile을 만드는게 가장 중요하다.
  geom_map(data= myKorea, map= myKorea, aes(map_id=id,group=group),
           fill=NA, colour="black") +
  coord_cartesian(xlim= LON.range ,ylim= LAT.range) +
  labs(title= "PM10 Concentration in Seoul Area at South Korea",
       x="Longitude", y= "Latitude")+
  theme(title= element_text(hjust = 0.5,vjust = 1,face= c("bold")))+
  scale_fill_viridis(option="magma")




# API(Aplication Programming Interface) ----------------------------------------
rm(list = ls()); gc(reset = T)

# --------------------------------
if(!require(httr)){install.packages("httr"); library(httr)}
if(!require(rvest)){install.packages("rvest"); library(rvest)}

# --------------------------------교육자료에는 ****로 표시되어 있습니다.
service_key = "%2FTx8UW5QkXse141bToOh9SO%2FbpFMoFAm4th151RoR4VW75y%2BGv3XzlqxeF80oGKEcWZ8pSoXvEi6%2BNnzlR%2FRrQ%3D%3D"

# --------------------------------
url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
             "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
             "sidoName=서울",
             "&searchCondition=DAILY",
             "&pageNo=",1,
             "&numOfRows=",25,
             "&ServiceKey=",service_key)

# --------------------------------
if(!require(httr)){install.packages("httr"); library(httr)}

url_get = GET(url)

# --------------------------------
if(!require(xml2)){install.packages("xml2"); library(xml2)}

url_xml = read_xml(url_get)
url_xml

# --------------------------------
if(!require(rvest)){install.packages("rvest"); library(rvest)}

item_list = xml_nodes(url_xml, 'items item')

item_list[[1]]

# --------------------------------
tmp_item = xml_children(item_list[[1]])
tmp_item

# --------------------------------
tmp_item = xml_text(tmp_item)
tmp_item

# --------------------------------
item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
item_list[[1]]
item_list[[2]]

# --------------------------------
item_dat = do.call('rbind',item_list)
item_dat = data.frame(item_dat, stringsAsFactors = F)
head(item_dat)

tmp = xml_nodes(url_xml, 'items item') 
colnames_dat = html_name(xml_children(tmp[[1]]))
colnames_dat

# --------------------------------
colnames(item_dat) = colnames_dat
head(item_dat)

# --------------------------------
air_data = NULL
for(i in 1:24)
{
  url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
               "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
               "sidoName=서울",
               "&searchCondition=DAILY",
               "&pageNo=",i,
               "&numOfRows=",25,
               "&ServiceKey=",service_key)
  url_xml = read_xml(GET(url))
  item_list = url_xml %>% xml_nodes('items item')
  item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
  item_dat = do.call('rbind',item_list) 
  # list를 하나씩 떼서 앞에있는 함수를 계속 붙여줌
  # O <- rbind(O, item_list[[i]]) 이것과 동일
  item_dat = data.frame(item_dat, stringsAsFactors = F)
  air_data = rbind(item_dat, air_data)
}

# --------------------------------
# 샤이니 코드
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
{
  return(NULL)
}

shinyApp(ui = ui, server= server)

# --------------------------------
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
{
  output$output_text = renderText({
    input$input_text
  })
}

server = function(input, output)
{
  output$output_text = renderText({
    paste(input$input_text, '만세')
  })
}


shinyApp(ui = ui, server= server)

# --------------------------------
ui = fluidPage(
  headerPanel('Iris k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(iris)),
    # 이름을 이렇게 해야지 된다고 한다
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

server = function(input, output)
{
  return(NULL)
}

shinyApp(ui = ui, server = server)

# --------------------------------
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

shinyApp(ui = ui, server = server)



# shinyApp 안쓰고 ----
names(iris)
selectedData <- iris[,c(1,3)]
cluster <- kmeans(selectedData, 5)
plot(selectedData, col = cluster$cluster, pch= 20, cex = 3)



# --------------------------------
url = paste0("http://openapi.airkorea.or.kr/openapi/services/rest/",
             "ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?",
             "sidoName=서울",
             "&searchCondition=DAILY",
             "&pageNo=",1,
             "&numOfRows=",600,
             "&ServiceKey=",service_key)
url_xml = xml(GET(url))
item_list = url_xml %>% xml_nodes('items item')
item_list = lapply(item_list, function(x) return(xml_text(xml_children(x))))
item_dat = do.call('rbind',item_list)
item_dat = data.frame(item_dat, stringsAsFactors = F)
item_dat[item_dat == '-'] = 0
tmp = xml_nodes(url_xml, 'items item') 
colnames_dat = xml_tag(xml_children(tmp[[1]]))
colnames(item_dat) = colnames_dat

library(ggmap)
uniq_region = unique(item_dat$cityName)
geo_dat = geocode(paste("서울특별시", uniq_region))
geo_dat = cbind(cityName = uniq_region, geo_dat)
head(geo_dat)

geo_dat = read.csv('geo_dat.csv', stringsAsFactors = F)
head(geo_dat)

item_dat = merge(item_dat, geo_dat, by = "cityName")
head(item_dat)
write.csv(item_dat, 'air_quality.csv', row.names = F)

dat = read.csv('air_quality.csv', stringsAsFactors = F)
head(dat)

# --------------------------------
library(shiny)

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

# --------------------------------
library(shiny)

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
  selectedData1 = reactive({
    dat[dat$dataTime == input$date, c(input$category)]
  })
  selectedData2 = reactive({
    dat[dat$cityName == input$region, c(input$category)]
  })
  output$hist1 = renderPlot({
    hist(selectedData1(), main = "선택된 시간의 미세먼지", xlab = "", ylab = "")
  })
  output$hist2 = renderPlot({
    hist(selectedData2(), main = "선택된 구의 미세먼지", xlab = "", ylab = "")
  })
}

shinyApp(ui = ui, server = server)

# --------------------------------
library(shiny)

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


# --------------------------------
library(shiny)

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









































