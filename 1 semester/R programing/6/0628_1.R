##################################### File #####################################

View(CO2) # 뷰
str(CO2)                          
list.files()
getwd()
a = list.files()
a[1]      # 저장결과를 character로 받아올 수 있다.
b = list.dirs(recursive = F)
          # 우리가 현재 접근가능한 directory만 출력한다.
b[1]      # 마찬가지로 첫번째를 character로 받아올 수 있다.

write.csv(CO2, "C:/workspace/R/6/28/CO2.csv", row.names = F) 
write.table(CO2, "C:/workspace/R/6/28/CO2_2.csv", row.names = F, sep = ',')
write.table(CO2, "C:/workspace/R/6/28/CO2_3.csv", row.names = F, sep = ';')
          # write는 덮어쓰기 때문에 주석처리 해놓는것이 덜 위험하다.

read.csv("C:/workspace/R/6/28/CO2.csv")
read.table("C:/workspace/R/6/28/CO2.csv", sep = ',')
read.table("C:/workspace/R/6/28/CO2_2.csv", sep = ',')
read.table("C:/workspace/R/6/28/CO2_3.csv", sep = ';')
          # quote '\n' 이런애들은 제외하고 읽는다.
          # colClasses는 숫자는 더블형, 문자열은 factor로 읽는다.
          # colClasses는numeric, character, factor, integer 각각의 순위
          # StringAsFactors는 숫자로 읽지 못하는 애들은 factor로 바꾸지 말아라.
          # nrow = 10 / 10개만 읽겠다.
          # skip 띄어서 읽기 skip = 5 5번째 부터 읽는다.

a <- read.table("C:/workspace/R/6/28/CO2.csv", sep = ',') 
b <- read.table("C:/workspace/R/6/28/CO2.csv", sep = ',', stringsAsFactors = F) 
str(a)
str(b)
          # STringsAsFactors = F 는 factor로 읽지 말아라. 라는 함수

a <- read.table("C:/workspace/R/6/28/CO2.csv", sep = ',', header = T,
                stringsAsFactors = F, 
                colClasses = c('character', 'factor', 'factor', 'integer', 'numeric'))
          # 각각의 컬럼에 class를 설정해 준다.
          # cloClasses의 경우 header를 탄다. 설정을 True로 해야한다. 
          # header의 defalut = F 이다.
str(a)

?read.table
?list.files


install.packages("xlsx")
library(xlsx)
write.xlsx(CO2, "C:/workspace/R/6/28/CO2.xlsx")
a <- read.xlsx("C:/workspace/R/6/28/CO2.xlsx", header = T, sheetIndex = 1,
               StringAsFactors = F)
          # 엑셀을 읽는경우 시트번호를 설정할 수 있다.
          # 이거하려면 rjava 설치 하고 환경 변수 설정도 해야된다.



################################### R-Graph ####################################

View(mtcars)
mtcars
?mtcars
str(mtcars)       # 첫번재 체인 mpg 두번째 체인 cyl 세번째 체인 disp...

mtcars$cyl <- factor(mtcars$cyl)
str(mtcars)

mpg               # 안불러진다.
names(mtcars)
attach(mtcars)    # mtcars의 컬럼명들을 attach 글로벌네임즈로 등록한다고 한다.
mpg               # 불러진다.

head(mtcars)      # default 6line (data, line수)




##################################### Plot #####################################

a = 'mpg ~disp'
a
plot(a, data = mtcars)
plot(mpg ~ disp, data = mtcars)
          # plot 안에 들어가는 형식은 formula이다.

a_f <- as.formula(a)
class(a_f)
a_f
plot(a_f, data = mtcars)
          # 작동한다. formula라는 형식이 plot에 들어간다는 것을 알 수 있다.
?plot

b = 'hp ~ disp'
b_f = as.formula(b)
plot(b_f, mtcars)

x = rnorm(100)
y = 2 + 2 * x + rnorm(100)
plot(x, y, main = 'plot(x-y)')
          # title는 main으로 표현 가능

x = seq(-2, 2, length = 10)
y = x^2
plot(x, y, type = 'n')
plot(x, y, type = 'l')

plot(x, y, type = 'b')
plot(x, y, type = 's')
          # 점, 선, 점 + 선, 꺾은선


plot(x, y, type = 'b', lty = 4)      
          # lty는 라인타입을 의미
plot(x, y, type = 'b', lty = 4, pch = 19)     
          # pch는 점 모양을 의미
plot(1:25, rep(0, 25), pch = 1:25)
          # x는 1~25, y는 모두 0 점모양은 1번부터 25번 모양까지 각각 다르게 적용
plot(x, y, type = 'b', lty = 4, pch = 19, col = 'blue')
          # col은 컬러 설정, 이름을 가진 컬러와 이름을 갖지 않은 컬러가 있다.
colors()
          # 이름을 가진 컬러를 보는법
plot(x, y, type = 'b', lty = 4, pch = 19, col = 'blue',
     xlab = 'xx', ylab = 'yy', main = 'y = x^2')
          # xlab, ylab // x와 y의 라벨(레이블)을 조정할 수 있다.
plot(x, y, type = 'b', lty = 4, pch = 19, col = 'blue',
     xlab = 'xx', ylab = 'yy', main = 'y = x^2', 
     xlim = c(-1.5, 1.5), ylim = c(0, 4))
          # x축과 y축의 끝을 제한할 수 있다. limit 조정
          # limit 조정은 2개의 그래프를 비교할 때 좋다.
          # R이 자동으로 축을 설정해서 공평한 비교가 되지 않는다.
          # 예를들면 y의 최대가 10, 100000 인경우 그래프모양은 같을 수 있다.
          # 이런것들을 방지하기 위해 limit 조정을 한다.

plot( ~ mpg + disp + drat, mtcars, main = 'Simple Scatterplot Matrix')
          # 산점도는 2개간의 관계밖에 보여 줄수 없다.
          # 더 많은 관계들을 보고 싶다면 2개간의 관계를 많이 보여주는 수 밖에 없다.
          # 그 방법이다.

x = rnorm(100)
y = 2 + 2 * x + rnorm(100)
plot(x, y, main = 'scatter plot')
abline(a = 1, b = 2, col = 'red')
          # 만들어진 plot위에 작업
abline(v = 1, col = 'blue')
          # 수직선
abline(h = 1, col = 'green')
          # 수평선

plot(x = 1, y = 1, type = 'n', xlim = c(0, 10), ylim = c(0, 5),
     xlab = 'time', ylab = '# of visiting')
          # 빈 도화지생성
x = 0:10
x = 10:0  # second
set.seed(1)
y = rpois(length(x), lambda = 1)
          # rpois 포아송 분포 생성
x
y
points(x, y, pch = 1:11)
          # 점이 찍히는 순서는 벡터의 순서대로이다. 작은 순서가 아니라!!
points(x, y, col = 'blue', type = 's')
points(x, y, col = 'red', type = 'l', lty = 3)


x = 0:10
set.seed(1)
y = rpois(length(x), lambda = 1)
          # rpois 포아송 분포 생성
plot(x, y, type = 'b', xlim = c(-1, 1), ylim = c(-1, 1))


plot(0, 0, type = 'n', xlim = c(-2, 2), ylim = c(-2, 2))
x = c(-2, 1, NA, 1, 0)
y = c(0, -1, NA, -2, 1)
lines(x, y, lty = 2)

plot(0, 0, type = 'n', xlim = c(1, 5), ylim = c(0, 2))
x = seq(1, 5, by = 1)
abline(v = x, lty = 1:length(x))

z = sort(rnorm(100))
y1 = 2 + x + rnorm(100)
plot(z, y1, col = 'blue', pch = 3)
points(z, y1/2, col = 'red', pch = 19)
legend('topright', c('십자가', '동그라미'), col = c('blue', 'red'), pch = c(3, 19))
legend('topleft', c('pch_3', 'pch_19'), col = c('blue', 'red'), pch = c(3, 19))
          # 범례설정은 lengend로 하며 파라미터 순서들을 맞춰서 하면 된다.

?legend

par (mfrow = c(2,2), bg = 'gray50', col = 'white',
     col.main = 'lightblue', col.axis = 'yellow', 
     col.lab = 'lightgreen')
x = rnorm(100)
y = 2+2*x + rnorm(100)
plot(x,y, main = "plot (x-y)-1", pch = 20)
y = 2+x + rnorm(100)
plot(x,y/2, main = "plot (x-y)-2")
y = 2+x + rnorm(100)
plot(x,y/3, main = "plot (x-y)-3", col.main = 'black')
y = 2+x + rnorm(100)
plot(x,y/4, main = "plot (x-y)-4", col.axis = 'white')
          # par 이용 잘하면 예뻐진다.
dev.off()
          # mfrow = c(2, 2) 설정 초기화

set.seed(1)
x <- sort(rnorm(100))
y <- 3 + x^2 + rnorm(100)
plot(x, y, pch = 20)
fit = lm(y ~ x)
str(fit)
coef = fit$coefficients
coef[1]
coef[2]
abline(coef[1], coef[2], col = 'blue')
          # 회귀선
yTrueMean = 3 + x^2
lines(x, yTrueMean, lty = 2, col = 'red')
          # 원래의 y에 대한 line
          # 왜 blue line과 red line에 대한 차이가 큰지에 대해서..




############################### KNN Visualizaion ###############################
install.packages("FNN")
library(FNN)

set.seed(1)
x <- sort(rnorm(100))
y <- 3 + x^2 + rnorm(100)
plot(x, y, pch = 20)
a <- knnx.index(x, 0, k = 10) # x가 0에서 제일 가까운 거 10개의 인덱스 뽑기
x[47]                         # 47번째가 제일 가까운 놈 // x[47]의 y값
x[46]                         # 47번째가 두번째로 가까운 놈 // x[46]의 y값

idx = a[1,]
points(x[idx], y[idx], pch = 19, col = 'red')
                              # 0주변의 10개의 점 red point으로 변경
abline(v = 0, lty = 3)        # line type = 3인 y = 0 line 긋기
abline(h = mean(y[idx]))      # 0주변의 10개의 점의 y평균값에 line긋기



set.seed(1)
x <- sort(rnorm(100))
y <- 3 + x^2 + rnorm(100)
plot(x, y, pch = 20)
a <- knnx.index(x, -1, k = 10) # x가 -1에서 제일 가까운 거 10개의 인덱스 뽑기
x[47]                          # 47번째가 제일 가까운 놈 // x[47]의 y값
x[46]                          # 47번째가 두번째로 가까운 놈 // x[46]의 y값

idx = a[1,]
points(x[idx], y[idx], pch = 19, col = 'red')
# 0주변의 10개의 점 red point으로 변경
abline(v = -1, lty = 3)        # line type = 3인 y = 0 line 긋기
abline(h = mean(y[idx]))       # 0주변의 10개의 점의 y평균값에 line긋기



####################################### 29일 조교 ##############################

my_csum <- function(x) {
  n <- length()
  xcsum <- vector("numeric", n)
  xcsum[1] <- x[1]
  for(i in 2:n) {
    xcsum[i] <- xcsum[i-1] + x[i]
  }
  return(xcsum)
}


# cumsum 함수가 있는듯







