y = c(1,1,0,1,1)
dbinom(y, size = 1, prob = 0.5, log = TRUE )
loglike <- like <- c()
theta.vec <- seq(0,1,length = 100)
for (i in 1:100)
{
  theta <- theta.vec[i]
  like[i] <- prod(dbinom(y, size = 1, prob = theta,
                         log = FALSE ))
  loglike[i] <- sum(dbinom(y, size = 1, prob = theta,
                           log = TRUE ))
}
plot(theta.vec, loglike, type = 'l', col = 'blue')
plot(theta.vec, like, type = 'l', col = 'blue')

################################################################################
n = 100
y<- c(0.1,0.5,0.3,0.15,0.2)
sigma.vec <- seq(0.1,0.3, length = n)
mu.vec <- seq(0,0.5, length = n)
z <- matrix(0,n,n)
for (i in 1:n)
  for (j in 1:n)
    z[i,j] <- sum(dnorm(y,mu.vec[i], sigma.vec[j],
                        log = T), na.rm = T)
filled.contour(mu.vec, sigma.vec, z, nlevels = 20,
               col = heat.colors(20))

##### 조건부 분포와 우도함수 #####
x <-seq(0,1,length = 100)
y = log(x/(1-x))
plot(x, y, type = 'l')

z = seq(-10, 10, length = 1000)
y= exp(z)/(1+exp(z))
plot(z, y, type = 'l')



# t-test
n = 1000
testResult <- rep(0,n)
for (i in 1:n)
{
  x <- rep(0,20)
  for (j in 2:20) x[j] <- 0.9*x[j-1] + rnorm(1)
  testfit <- t.test(x,mu=0)
  testResult[i] <- testfit$p.value
}
mean(testResult>0.05)


##### ggplot2 #####
head(msleep[,c(3, 6 ,11)])

rm(list = ls()); gc(reset = T)

# ----------------------
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
if(!require(reshape2)){install.packages("reshape2"); library(reshape2)}
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}

# ----------------------
head(msleep[,c(3, 6 ,11)])

# ----------------------
ggplot(data = msleep, aes(x = bodywt, y = sleep_total)) + geom_point()

# ----------------------
ggplot(data = msleep, aes(x = log(bodywt), y = sleep_total)) + geom_point()

# ----------------------
scatterplot = ggplot(data = msleep, 
                     aes(x = log(bodywt), y = sleep_total, col = vore)) + 
  geom_point()
scatterplot

# ----------------------
scatterplot = ggplot(data = msleep, 
                     aes(x = log(bodywt), y = sleep_total, col = vore)) + 
  geom_point() + facet_grid(~vore)
scatterplot


# ggplot xlab와 ylab와 title ----
scatterplot <- scatterplot + geom_point(size=5)+
  xlab('Log Body Weight') + ylab('Total Hours Sleep')+
  ggtitle('Some Sleep Data')
scatterplot


# ----
stripchart <- ggplot(msleep, aes(x = vore, y = sleep_total)) + geom_point()
stripchart

# ----
stripchart <- ggplot(msleep, aes(x = vore, y = sleep_total, col = vore)) + 
  geom_jitter(position =  position_jitter(width = 0.2), size = 5, alpha = 0.5)
stripchart

# ----
dane <- data.frame(mylevels=c(1,2,5,9), myvalues=c(2, 5, 3, 4))
head(dane)

ggplot(dane, aes(x=factor(mylevels), y=myvalues)) + geom_line(group = 1) + 
  geom_point(size=3)

# 시계열 ----
data(economics)
data(presidential)
str(economics)
str(presidential)

ggplot(economics, aes(date, unemploy)) + geom_line()

# 실업자수가 집권당에 따라서 어떻게 변해가는가 ----
presidential = subset(presidential, start > economics$date[1])
ggplot(economics) + geom_rect(aes(xmin = start,xmax = end, fill = party), # rect 사각형
  ymin = -Inf, ymax = Inf, data = presidential) + # color = 'black'
  geom_line(aes(date, unemploy), data = economics)


ggplot(economics) + geom_rect(aes(xmin = start,xmax = end, fill = party), # rect 사각형
  ymin = -Inf, ymax = Inf, data = presidential, color = 'black') + # color = 'black'
  geom_line(aes(date, unemploy), data = economics)



# 오존데이터----
if(!require(datasets)){install.packages("datasets"); library(datasets)}
data(airquality)
plot(airquality$Ozone, type = 'l')

aq_trim <- airquality[which(airquality$Month == 7 |
                              airquality$Month == 8 |
                              airquality$Month == 9), ]
aq_trim$Month <- factor(aq_trim$Month,labels = c("July", "August", "September"))

ggplot(aq_trim, aes(x = Day, y = Ozone, size = Wind, fill = Temp)) + # aes를 통해 설정해준다.
  geom_point(shape = 21) +   ggtitle("Air Quality in New York by Day") +
  labs(x = "Day of the month", y = "Ozone (ppb)") +
  scale_x_continuous(breaks = seq(1, 31, 5)) # x축의 이름을 어떻게 쓸거냐


# festival.data <- read.table(file = 'DownloadFestival.dat', sep = '\t', header = T) ----
festival.data <- read.table(file = 'C:/workspace/code_JJJ/data/DownloadFestival.dat', 
                            sep = '\t', header = T)
head(festival.data)

festival.data.stack <- melt(festival.data, id = c('ticknumb', 'gender'))
colnames(festival.data.stack)[3:4] <- c('day', 'score')

head(festival.data.stack)

# histogram -----
Day1Histogram <- ggplot(data = festival.data, aes( x= day1))
Day1Histogram + geom_histogram()

Day1Histogram + geom_histogram(color = 'royalblue1', fill= 'royalblue2')
Day1Histogram + geom_histogram(color = 'royalblue1', fill = 'royalblue2', binwidth  = 0.1)


Day1Histogram + geom_histogram(binwidth = 0.2, aes( y = ..density..), 
                               color= 'royalblue3', fill = 'yellow', bins = 35) 

Day1Histogram +geom_histogram(binwidth = 0.1, aes(y=..density..), 
                              color="black", fill="lightblue") + 
               geom_density(alpha=.2, fill="#FF6666") 

Histogram.3day2 <- ggplot( data = festival.data.stack, aes(x = score)) + 
  geom_histogram(binwidth = 0.4, color= 'black', fill = 'yellow') + 
  labs( x = 'Score', y = 'Counts')
Histogram.3day2

Histogram.3day2 + facet_grid(~gender)
Histogram.3day2 + facet_grid(gender~day)

Histogram.3day2 <- ggplot( data = festival.data.stack, aes(x = score,y = ..density..)) + # 빈도 변경
  geom_histogram(binwidth = 0.4, color= 'black', fill = 'yellow') + 
  labs( x = 'Score', y = 'Counts')
Histogram.3day2     

Histogram.3day2 + facet_grid(~gender)
Histogram.3day2 + facet_grid(day~gender)

Scatterplot <- ggplot(data = festival.data.stack, aes(x = gender, y = score, color = gender)) + 
  geom_point(position = 'jitter') + facet_grid(~day)    # jitter을 알아서 그려준다.
Scatterplot
# 히스토그램은 너무 많은 정보를 지니고 있다.평균과 분산만 보고 싶을 땐 boxplot을 이용하자
Scatterplot + geom_boxplot(alpha = 0.1, color= 'black', fill = 'orange')   # boxplot그리기


Scatterplot + scale_color_manual(values = c('darkorange', 'darkorchid4'))
# 왜도가 달라진다는 얘기를 하고 싶다면 히스토그램을 이용해라. skueness?


# exercise ----
rm(list = ls()); gc(reset = T)

# -------------------------------------
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
if(!require(reshape2)){install.packages("reshape2"); library(reshape2)}
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}

# -------------------------------------
if(!require(maps)){install.packages("maps"); library(maps)}
load(file="C:/workspace/code_JJJ/data/storms.RData")
wm = map_data("world")

# -------------------------------------
str(wm)

# -------------------------------------
substorms = storms %>% filter(Season %in% 1999:2010) %>%
  filter(!is.na(Season)) %>%
  filter(Name!="NOT NAMED")
substorms$ID = as.factor(paste(substorms$Name, 
                               substorms$Season, sep = "."))
substorms$Name = as.factor(substorms$Name)

# -------------------------------------
map1 = ggplot(substorms, 
              aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = wm, 
               aes(x = long, y = lat, group = group), 
               fill = "gray25", colour = "gray10", size = 0.2) + 
  geom_path(data = substorms, 
            aes(group = ID, colour = Wind.WMO.),
            alpha = 0.5, size = 0.8) +
  xlim(-138, -20) + ylim(3, 55) + 
  labs(x = "", y = "", colour = "Wind \n(knots)")

# -------------------------------------
map1

# -------------------------------------
map2 = ggplot(substorms, 
              aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = wm, 
               aes(x = long, y = lat, group = group), 
               fill = "gray25", colour = "gray10", size = 0.2) + 
  geom_path(data = substorms, 
            aes(group = ID, colour = Wind.WMO.), size = 0.5) + 
  xlim(-138, -20) + ylim(3, 55) + 
  labs(x = "", y = "", colour = "Wind \n(knots)") + 
  facet_wrap(~Month) 

# -------------------------------------
map2

# -------------------------------------
par(bg="white")
set.seed(1)
a=seq(1:100) + 0.1*seq(1:100)*sample(c(1:10) , 100 , replace=T)
b=seq(1:100) + 0.2*seq(1:100)*sample(c(1:10) , 100 , replace=T)
size = 3 +(a/30) + rnorm(length(a))
d = (b/300) + rnorm(length(a),0, 0.1)
d[d<0] = 0
rdata<- data.frame(x = a, y = b, size = size, temp = d)
myplot <- ggplot(data = rdata, aes ( x = x, y = y)) + 
  geom_point(aes(x,y, colour = temp), size = size) + 
  scale_color_gradient2(midpoint = 0.5, low="#EF5500", 
                        mid="#FFFF77", high="blue")

# -------------------------------------
par(bg="white")
set.seed(1)
a=seq(1:100) + 0.1*seq(1:100)*sample(c(1:10) , 100 , replace=T)
b=seq(1:100) + 0.2*seq(1:100)*sample(c(1:10) , 100 , replace=T)
size = 3 +(a/30) + rnorm(length(a))
d = (b/300) + rnorm(length(a),0, 0.1)
d[d<0] = 0
rdata<- data.frame(x = a, y = b, size = size, temp = d)
myplot <- ggplot(data = rdata, aes ( x = x, y = y)) + 
  geom_point(aes(x,y, colour = temp), size = size) + 
  scale_color_gradient2(midpoint = 0.5, low="#EF5500", mid="#FFFF77", high="blue")
myplot

















# drawing map ----
# 어려운 이유는 구면좌표계를 유지하면서 평면으로 옮기려고 하기 때문에 어렵다.
rm(list = ls()); gc(reset = T)

# -----------------------------
if(!require(maps)){install.packages("maps") ;library(maps)}
if(!require(mapdata)){install.packages("mapdata") ;library(mapdata)}

# -----------------------------
par(mfrow = c(1,2))
map(database = "usa")
map(database = "county") ## county map을 이용, 자세한 USA map을 그릴 수 있음

# -----------------------------
map(database = 'world')
map(database = 'world', region = 'South Korea')
# 몇개의 다각형으로 이루어져있다.
# world2Hires에서 보다 높은 자세한 map을 그릴 수 있음
map('world2Hires', 'South Korea') 
# 포인트와 포인트를 잇는 정보들이 있을거임 데이터가..기본은 점이다.
?text
map.cities("USA","Texas")


# -----------------------------
data(us.cities)
head(us.cities)

# -----------------------------
map('world', fill = TRUE, col = rainbow(30))

# -----------------------------
map('world', fill = TRUE, col = rainbow(30))

# -----------------------------
data(unemp) # unemployed rate data
data(county.fips) # county fips data
head(unemp,3)
head(county.fips,3)
































