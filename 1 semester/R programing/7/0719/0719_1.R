# 7월 19일 ----
# 1. 확률분포의 표현 ----
rnorm()
rgamma()
rbeta()
rpois()

# ...L 자료의 생성과 성질 ----
x = rnorm(200)
summary(x)
sd(x)
boxplot(x)
abline(h = 0, col = 'red')
hist(x, xlim = c(-3, 3))

sum(0<x & x<1) / 200
sum(1<x & x<3) / 200
# 비슷한 패턴을 가지는 데이터다.(분포가 같다, 상대빈도가 동일하다)

x = rgamma(200, 2, 8)
summary(x)
sd(x)
boxplot(x)
abline(h = 2, col = 'red')
hist(x, xlim = c(0, 10))

sum(1<x & x<3) / 200
# 임의의 구간에서 상대빈도가 다르다

n = 100
x = rgamma(n, 2, 1)
hist(x, nclass = sqrt(n), col = 'darkblue', probability = TRUE, 
     xlim = c(0, 10), ylim = c(0, 0.4))
# 임의의 구간에서 상대빈도가 다르다

n = 1000000
x = rgamma(n, 2, 1)
hist(x, nclass = sqrt(n), col = 'darkblue', probability = TRUE, 
     xlim = c(0, 20), ylim = c(0, 0.4))
# 거의 똑같다.
# 히스토그램의 껍데기가 pdf 확률밀도함수이다!!
mean(3<x & x<=5)
mean(1<x & x<=2)
# n이 증가했더니 데이터의 패턴이 점점 같아진다
# pdf : 히스토그램의 극한이다
# pdf를 적분한다는 의미는 히스토그램에서 막대기를 다 더한다는 뜻이다

n = 200
x = rgamma(n, 2, 1)
mean(-Inf<x & x<=2)
mean(-Inf<x & x<=3)
# 누적분포함수도 같은 의미 / 패턴이 같다
# 임의의 x에 대해서 대응시키는 상대빈도값은 f(x)라고 할 수 있다
# 패턴이 같다는 것은 누적분포함수가 같은가 다른가로 이야기 할 수 있다
n = 200
x = rgamma(n, 2, 1)
z = seq(0, 10, length = 1000)
y = c()
for (i in 1:length(z))
{
  y[i] = mean(-Inf<x & x<=z[i])
}
plot(z, y, type = 'l', lwd = 2)
# 이 plot이 데이터의 패턴이다

x = rgamma(n, 2, 8)
z = seq(0, 10, length = 1000)
y = c()
for (i in 1:length(z))
{
  y[i] = mean(-Inf<x & x<=z[i])
}
lines(z, y, col = 'blue', lwd = 2)
# 누적분포함수를 데이터로부터 표현
# 데이터의 패턴이 다르다
# 두개의 분포가 다름을 알 수 있다

# ...L 확률분포의 계산 ----
pnorm(2, mean = 0, sd = 2)
# -Inf부터 2까지 있는 것
pnorm(2, mean = 0, sd = 2) - pnorm(1, mean = 0, sd = 2)
# 데이터가 2와 1사이에서 관찰될 확률
1 - pnorm(2, mean = 0, sd = 2)
# 데이터가 2보다 크게 관찰될 확률

# ...L 분포의 연산 ----
x = rnorm(200)
y = rnorm(200)
# mean = 0, sd = 1인 정규분포 2개를 만듬
xy = x * y
hist(xy)
xx = x^2
hist(xx)
xy = x / y
hist(xy)
hist(xy, nclass = sqrt(n), probability = TRUE, xlim = c(-300, 300))
# 각각의 패턴을 알 고 있다고 하더라도 임의의 식으로 변환을 할시
# 그 변환되 데이터의 패턴을 다시 알아야한다
# 변화하기 때문이다(변수 변환을 통한 변수의 계산)


# ...L 회귀분석 ----
x = rgamma(200, 2, 1)
ep = rnorm(200)
y = 1 + x + ep
# ep는 입실롬 ep는 y를 예측하기 위한 도구
plot(x, y)

x1 = rgamma(200, 2, 1)
x2 = rgamma(200, 2, 1)
ep = rnorm(200)
y = 1 + x2 + ep
plot(x, y)


# ......L n = 200 ----
n = 200
p = 10
x = matrix(rgamma(n*p, 1, 2), n, p)
b = rep(0, p)
b[3:4] = c(1.5, -1)
head(x)
x %*% b

y = 1 + x %*% b + rnorm(n)
par(mfrow = c(5, 2))
plot(x[,1], y)
plot(x[,2], y)
plot(x[,3], y)
plot(x[,4], y)
plot(x[,5], y)
plot(x[,6], y)
plot(x[,7], y)
plot(x[,8], y)
plot(x[,9], y)
plot(x[,10], y)
# 어떤 변수가 y에 영향을 주는가

rdata = data.frame(y <- y, x <- x)
names(rdata)

lm(y ~ 1, data = rdata)
# 상수를 의미한다. 즉 베타제로를 의미

lm(y ~ 1 + X1, data = rdata)
lm(y ~ 1 + X2, data = rdata)
lm(y ~ 1 + X3, data = rdata)
lm(y ~ 1 + X4, data = rdata)
lm(y ~ 1 + X5, data = rdata)
lm(y ~ 1 + X6, data = rdata)
lm(y ~ 1 + X7, data = rdata)
lm(y ~ 1 + X8, data = rdata)
lm(y ~ 1 + X9, data = rdata)
lm(y ~ 1 + X10, data = rdata)

lm(y ~ 1 + X1 + X2, data = rdata)
lm(y ~ 1 + X1 + X2 + X3, data = rdata)


fit = lm(y~1, data = rdata)
str(fit)
names(fit)
# fit은 리스트임
# 중요한건 residuals가 중요(데이터와 예측한 거의 차이)
sum(fit$residuals^2)
# 이게 그러면 최소제곱합이네 데이터와 적합한 예측한 값을 차이의 제곱을 합

fit = lm(y~1+X1, data = rdata)
sum(fit$residuals^2)

fit = lm(y~1+X1+X2+X3+X4+X5, data = rdata)
sum(fit$residuals^2)

fit = lm(y~1+X1+X2+X3+X4+X5+X6+X7+X8+X9+X10, data = rdata)
sum(fit$residuals^2)
# 계속 줄어들긴 할거임 차원이 증가하기 때문에

fit = lm(y~1, data = rdata)
ba = sum(fit$residuals^2)
fit = lm(y~1+X1+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X2+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X3, data = rdata)
ba - sum(fit$residuals^2)
# X3일 때 102가 감소하므로 X3는 다 포함한다
fit = lm(y~1+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
# X3와 X4일 때, 153이 감소하므로 2번 째 결정
fit = lm(y~1+X3+X4+X5, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X3+X4+X6, data = rdata)
ba - sum(fit$residuals^2)
# ... 등등 이걸 다 찰때까지 반복한다면, 총 11개의 모델이 나오게 된다
fit = lm(y~1+X3+X7, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X8, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X9, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X10, data = rdata)
ba - sum(fit$residuals^2)
# 그렇게 얻어진 11개의 모델은 부모형 sub models라고 한다

# y = 1.213 + ep / ep는 입실론
# y = 0.9202 + 1.6399X3 - 0.9688X4 + ep

# 교차분석 등등등 으로 11개 중에서 골라낸다


# ......L n = 200000 ----
n = 200000
p = 10
x = matrix(rgamma(n*p, 1, 2), n, p)
b = rep(0, p)
b[3:4] = c(1.5, -1)
head(x)
x %*% b

y = 1 + x %*% b + rnorm(n)
plot(x[,1], y)
plot(x[,2], y)
plot(x[,3], y)
plot(x[,4], y)
plot(x[,5], y)
plot(x[,6], y)
plot(x[,7], y)
plot(x[,8], y)
plot(x[,9], y)
plot(x[,10], y)
# 어떤 변수가 y에 영향을 주는가

rdata = data.frame(y <-  y, x <- x)
names(rdata)

lm(y ~ 1, data = rdata)
# 상수를 의미한다. 즉 베타제로를 의미

lm(y ~ 1 + X1, data = rdata)
lm(y ~ 1 + X2, data = rdata)
lm(y ~ 1 + X3, data = rdata)
lm(y ~ 1 + X4, data = rdata)
lm(y ~ 1 + X5, data = rdata)
lm(y ~ 1 + X6, data = rdata)
lm(y ~ 1 + X7, data = rdata)
lm(y ~ 1 + X8, data = rdata)
lm(y ~ 1 + X9, data = rdata)
lm(y ~ 1 + X10, data = rdata)

lm(y ~ 1 + X1 + X2, data = rdata)
lm(y ~ 1 + X1 + X2 + X3, data = rdata)


fit = lm(y~1, data = rdata)
str(fit)
names(fit)
# fit은 리스트임
# 중요한건 residuals가 중요(데이터와 예측한 거의 차이)
sum(fit$residuals^2)
# 이게 그러면 최소제곱합이네 데이터와 적합한 예측한 값을 차이의 제곱을 합

fit = lm(y~1+X1, data = rdata)
sum(fit$residuals^2)

fit = lm(y~1+X1+X2+X3+X4+X5, data = rdata)
sum(fit$residuals^2)

fit = lm(y~1+X1+X2+X3+X4+X5+X6+X7+X8+X9+X10, data = rdata)
sum(fit$residuals^2)
# 계속 줄어들긴 할거임 차원이 증가하기 때문에

fit = lm(y~1, data = rdata)
ba = sum(fit$residuals^2)
fit = lm(y~1+X1+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X2+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X3, data = rdata)
ba - sum(fit$residuals^2)
# X3일 때 102가 감소하므로 X3는 다 포함한다
fit = lm(y~1+X3+X4, data = rdata)
ba - sum(fit$residuals^2)
# X3와 X4일 때, 153이 감소하므로 2번 째 결정
fit = lm(y~1+X3+X4+X5, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X3+X4+X6, data = rdata)
ba - sum(fit$residuals^2)
# ... 등등 이걸 다 찰때까지 반복한다면, 총 11개의 모델이 나오게 된다
fit = lm(y~1+X3+X7, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X8, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X9, data = rdata)
ba - sum(fit$residuals^2)
fit = lm(y~1+X10, data = rdata)
ba - sum(fit$residuals^2)
# 그렇게 얻어진 11개의 모델은 부모형 sub models라고 한다

# y = 1.213 + ep / ep는 입실론
# y = 0.9202 + 1.6399X3 - 0.9688X4 + ep

# 교차분석 등등등 으로 11개 중에서 골라낸다


# ,,,L 훈련데이터와 예측데이터(평가데이터) ----
n = 200
p = 10
x = matrix(rgamma(n*p, 1, 2), n, p)
b = rep(0, p)
b[3:4] = c(1.5, -1)
head(x)
x %*% b

y = 1 + x %*% b + rnorm(n)
rdata = data.frame(y <- y, x <- x)
fit0 = lm(y~1, data = rdata)
fit1 = lm(y~1+X4, data = rdata)
fit2 = lm(y~1+X4+X3, data = rdata)
fit3 = lm(y~1+X4+X3+X5, data = rdata)


n = 100
p = 10
x = matrix(rgamma(n*p, 1, 2), n, p)
b = rep(0, p)
b[3:4] = c(1.5, -1)
y = 1 + x %*% b + rnorm(n)

vdata = data.frame(y <- y, x <- x)

yhat = predict(fit0, newdata = vdata)
sum((vdata$y - yhat)^2)

yhat = predict(fit1, newdata = vdata)
sum((vdata$y - yhat)^2)

yhat = predict(fit2, newdata = vdata)
sum((vdata$y - yhat)^2)

yhat = predict(fit3, newdata = vdata)
sum((vdata$y - yhat)^2)

# ...L AIC 구하기 ----
# AIC(아카이케 정보 기준, Akaike Information Criterion)
# BIC



# 2. Unemployment rate map ----
if(!require(maps)){install.packages("maps") ;library(maps)}
if(!require(mapdata)){install.packages("mapdata") ;library(mapdata)}

map('world', fill = TRUE, col = rainbow(30))
data(unemp)
data(county.fips)
head(unemp,3)
head(county.fips,3)

unemp$colorBuckets <- as.numeric(cut(unemp$unemp, 
                                     c(0, 2, 4, 6, 8, 10, 100)))
cut(unemp$unemp, c(0, 2, 4, 6, 8, 10, 100)) # 이건 내가 궁금해서 ㅋ
# cut함수는 levels를 쉽게 생성할수있다(c()는 cutpoint라는 짜르는 지점을
# 정해준다.)

colorsmatched <- unemp$colorBuckets[match(county.fips$fips, unemp$fips)]
# match함수가 어디에 있는지 알려준다

colors = c("#F1EEF6","#D4B9DA","#C994C7","#DF65B0","#DD1C77","#980043")
# 파레트만듬(0~2, 2~4, 4~6, 6~8, 8~10, 10~100)

if(!require(mapproj)){install.packages("mapproj") ;library(mapproj)}

map("county", col = colors[colorsmatched], fill = TRUE,
    resolution = 0, lty = 0, projection = "polyconic")
# 구면좌표계를 좀더 잘 그리기 위해 projection설정함 ployconic
# 미국이 살짝 기울여짐


# mapDB어떻게 그려지는가 
map("county", col = colors[colorsmatched], fill = TRUE,
    resolution = 0, lty = 0, projection = "polyconic")
# 아메리카 그렸고,
map("state", col = "white", fill = FALSE, add = TRUE, lty = 1,
    lwd = 0.2,projection = "polyconic")
# 주 별로 선그엇고 add TRUE를 통해 덮어씌우는 기능
title("unemployment by county, 2009")
# 타이틀 넣었어



if(!require(dplyr)){install.packages("dplyr") ;library(dplyr)}
if(!require(ggplot2)){install.packages("ggplot2") ;library(ggplot2)}

wm <- ggplot2::map_data('world')
str(wm)
# group가 그려진 순서이다. 
# 지도가 어떻게 그려지는지 생각해보면 기본이 라인이다.
# 라인이 점을 잇는다. 
# order가 점을 잇는순서
head(wm, 30)
wm %>% dplyr::select(region) %>% unique() %>% head()
# 나라마다 색이 달라야 하므로 나라의 개수만큼의 파레트를 만들면 될듯


ur <- wm %>% dplyr::select(region)%>%unique()
nrow(ur)
# 252개국
grep( "Korea", ur$region )
# 한국은 125번째와 185번째의 row에 있다
ur$region[c(125,185)]
# 어떤 korea인지 볼라고

map("world", ur$region[c(125,185)],fill = T, col = "blue")
# 코리아 2개 블루색칠하기

map("world", ur$region[c(42, 116, 125,185)],fill = T, col = "blue")
# 중국 한국 일본 퍼런색 실하기

map("world", ur$region[c(42, 116, 125,185)],fill = T, col = rainbow(4))
# 제대로 칠해지지 않는다.

map("world", ur$region[c(125,185)],fill = T, col = rainbow(4))
# 이것도 마찬가지로 잘 안칠해진다.



# ...L 올바르게 칠하려면??? ----
if(!require(mapplots)){install.packages("mapplots") ;library(mapplots)}
if(!require(ggmap)){install.packages("ggmap") ;library(ggmap)}
if(!require(mapdata)){install.packages("mapdata") ;library(mapdata)}

map('worldHires', 'South Korea')
seoul_loc = geocode('seoul')
busan_loc = geocode('Busan')
add.pie(z=1:2,labels = c('a','b'), 
        x = seoul_loc$lon, y = seoul_loc$lat, radius = 0.5)
add.pie(z=4:3,labels = c('a','b'),
        x = busan_loc$lon, y = busan_loc$lat, radius = 0.5)

wmr <- wm %>% filter(wm$region == "South Korea" | wm$region == "North Korea")
head(wmr)

wmn <- wm %>% filter(wm$region == "North Korea")
wms <- wm %>% filter(wm$region == "South Korea")

wmn$group %>% unique()
wms$group %>% unique()

map("world", ur$region[c(125, 185)], fill = T, 
    col = c(rep("darkblue",11), rep("pink",2)))
# 이렇게 하면 색이 잘 칠해진다
# map이 사용하기 좀 불편한데 이걸 map함수를 잘 짜서 색을 칠하도록 하자


map('worldHires', 'South Korea')
# line으로 그리는 지도라는걸 기억하자...
seoul_loc = geocode('seoul')
busan_loc = geocode('Busan')
cheonan_loc = geocode('cheonan')

# 좌표계를 받아오는 함수
add.pie(z=1:2,labels = c('a','b'), 
        x = seoul_loc$lon, y = seoul_loc$lat, radius = 0.5)
add.pie(z=4:3,labels = c('a','b'),
        x = busan_loc$lon, y = busan_loc$lat, radius = 0.5)
add.pie(z=1:3,labels = c('a','b'),
        x = cheonan_loc$lon, y = cheonan_loc$lat, radius = 0.5)








