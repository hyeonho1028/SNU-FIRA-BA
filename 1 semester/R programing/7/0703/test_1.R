##### 7월 3일 #####
##### ...L 1) 리뷰 #####

set.seed(1)
x <- sort(rnorm(100))
y <- 3 + x^2 + rnorm(100)

library(FNN)
knnx.index(x, 0, k = 0)

eval.n = 100
eval.point = seq(-3,3, length= eval.n)
plot(x, y, pch = 20)
idx.mat<- knnx.index(x, eval.point , k = 10)
yhat = rep(0,eval.n)
for (i in 1:eval.n)   yhat[i]<-mean(y[idx.mat[i,]])
lines(eval.point , yhat, type= 'l', lty = 2, col = 'red')

# ... R graphics tool 봐라
# y햇 값을 10개로 보고잇는데 이걸 한개로 바꾸려면

plot(x, y, pch = 20)
idx.mat<- knnx.index(x, eval.point , k = 1)
yhat = rep(0,eval.n)
for (i in 1:eval.n)   yhat[i]<-mean(y[idx.mat[i,]])
lines(eval.point , yhat, type= 'l', lty = 2, col = 'red')

plot(x, y, pch = 20)
idx.mat<- knnx.index(x, eval.point , k = 100)
yhat = rep(0,eval.n)
for (i in 1:eval.n)   yhat[i]<-mean(y[idx.mat[i,]])
lines(eval.point , yhat, type= 'l', lty = 2, col = 'red')
# 100개 일때 어떤 점에서도 neighborhood 가 같고 yhat도 같다.

##### ...L 2) 3D plotting #####
install.packages('plotly')
library(plotly)
?plotly

a = matrix(1:25, 5, 5)
image(a)
a


x = c(0.1, 0.5, 0.7, 0.8, 0.85)
y = c(2.1, 2.3, 2.7)


# 행이 x좌표계, 열이 y좌표계를 의미
volcano
dim(volcano)
image(volcano)
z <- 2 * volcano
x <- 10 * (1:nrow(z))
y <- 10 * (1:ncol(z))   # 10 meter spacing (E to W)
## Don't draw the grid lines :  border = NA

z[30, 4]
x[3]
y[4]

par(bg = "slategray")
persp(x, y, z, theta = 135, phi = 30, col = "green3", scale = FALSE,
      ltheta = -120, shade = 0.75, border = NA, box = FALSE)
library(rgl)
persp3d(x, y, z, col = "green3")

##### ...L 3) EDA(Explanatory data analysis) #####
##### ......L (1) 범주형변수 #####
##### .........L a) 일변량 #####
state.region
counts = table(state.region)
counts
barplot(counts, main = 'simple bar chart', xlab = 'region', ylab = 'freq')
# 이건 그냥 빈도에 대한 막대그래프

counts = table(state.region)
barplot(counts/sum(counts), main = 'simple bar chart', xlab = 'region', ylab = 'freq')
# 이건 상대빈도

counts = table(mtcars$cyl)
barplot(counts, main = "simple bar chart", col = 'orange')
# 빈도

barplot(counts/sum(counts), main = "simple bar chart", col = 'orange')
# 상대빈도

cyl.name = c('4 cyl', '6 cyl', '8 cyl')
barplot(counts, main = "simple bar chart", col = 'orange', names.arg = cyl.name)


freq.cyl = table(mtcars$cyl)
rel.cyl = freq.cyl/sum(freq.cyl)
rel.cyl
rel.cyl <- round(rel.cyl, 3)
sum(rel.cyl)
# 1이 안되네 1을 맞추자. 차이를 값이 가장 큰 항목에 반영!
if ((sum(rel.cyl) - 1) != 0)
{
  d = sum(rel.cyl) - 1
  rel.cyl[which.max(rel.cyl)] = rel.cyl[which.max(rel.cyl)] - d
}
# 반올림했을 때, 상대빈도의 합이 1이 되지 않을 때 가장큰 값에 영향을 주어
# 1로 맞추는 조건문.

?pie
cyl.name2 = paste0(cyl.name, "(", freq.cyl, "%)")
pie(rel.cyl, labels = cyl.name2, main = 'pie chart', col = rainbow(3))
pie(rel.cyl, labels = cyl.name2, main = 'pie chart', col = rainbow(length(freq.cyl)))
names(freq.cyl)

##### .........L b) 다변량 #####

if(!require(vcd)){install.packages("vcd"); library(vcd)}
head(Arthritis, n = 3)
my.table <- xtabs( ~ Treatment + Improved, data = Arthritis)
my.table

barplot(my.table, xlab = "Improved", ylab = "frequency", legend.text = TRUE,
        col = c("green", "red"))

my.table
t(my.table) # 행과 열을 바꾸는 함수
barplot(t(my.table), xlab = "Improved", ylab = "frequency", legend.text = TRUE,
        col = c("green", "red", "orange"))

my.table <- t(my.table)
a = colSums(my.table)
for (i in 1:length(a))
{
  my.table[,i] = my.table[,i]/a[i]
}
my.table
a

my.table/rep(a, each = 3)
sweep(my.table, 2, a, FUN = "/")

barplot(my.table/rep(a, each = 3), xlab = "Improved", ylab = "frequency",
        legend.text = TRUE, col = c("green", "red", "orange"))



tmp = c("buckled", "unbuckled")
belt <- matrix( c(58, 2, 8, 16), ncol = 2, 
                dimnames = list(parent = tmp, child = tmp))
belt

spine(belt, main="spine plot for child seat-belt usage",
      gp = gpar(fill = c("green", "red")))


##### ......L (2) 연속형변수 #####
##### .........L a) 일변량 #####
x = rnorm(100)
boxplot(x, main = "boxplot", col ='lightblue')

x = faithful$waiting
boxplot(x)
# 봉우리가 2개인걸 알아내지를 못함.

hist(faithful$waiting, nclass = 8)
# 히스토그램은 파악할 수 있음. 더 많은 정보를 가지고 있다.
# 단 해석하기는 boxplot보다 더 어렵다.

hist(faithful$waiting, nclass = 8, probability = TRUE)
# dencity 즉 높이를 확률로 표시하기 위한 probability
# 정확한 계급 구간은 break 옵션을 통해서 할수 있음.

lines(density(x), col = "red", lwd = 2)
# 실제로 이렇게 하면 안된다.

fit = density(x)
lines(x = fit$x, y = fit$y, col = "red", lwd = 2)
# 이렇게 하는게 정답이다. x축 좌표와 y축 좌표를 순서대로 넣어주어야 한다.
# 위의 경우는 실제로는 lines.density라는 함수가 실행되는 것이다.

if(!require(vioplot)){install.packages("vioplot"); library(vioplot)}
x = rpois(1000, lambda = 3)
vioplot(x, col = "lightblue",  names = "variable")
?vioplot
# boxplot와 histogram의 장점을 결합하자.

##### .........L b) 다변량 #####

attach(mtcars)
boxplot(mpg~cyl, data = mtcars, names = c('4 cyl','6 cyl', '8 cyl'),
        main = "MPG dist by cylinder")

hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))), add= TRUE)
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))), add= TRUE)

# 히스토그램 겹쳐그리는 방법, 안좋은 방법이다.



par(mfrow = c(3,1))
hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     ylim = c(0,10), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     ylim = c(0,10), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))))
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     ylim = c(0,10), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))))
# 이렇게 하면 해석이 안되

par(mfrow = c(3,1))
hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))))
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))))
# xlim을 맞춰줘야한다.


plot(density(mpg[cyl==4]), xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40), ylim = c(0.,0.26))
lines(density(mpg[cyl==6]), col = "red", lty = 2)
lines(density(mpg[cyl==8]), col = "blue", lty = 3)      
legend("topright", paste(c(4,6,8), "Cylinder"),
       col = c("black","red", "blue"),
       lty = c(1,2,3), lwd = 3, bty ="n")



##### ...L 4) color #####
##### ......L (1) Palette #####

plot(1:20, y = rep(0, 20), col = 1:20, cex = 2, pch = 20)
# cex : 사이즈 pch : 점의 모양


mycol = colors()
plot(1:80, y=rep(1,80), col = mycol[1:80], cex = 2, pch = 20, 
     ylim = c(0,1) )
points(1:80, y=rep(0.5,80), col = mycol[81:160], cex = 2, pch = 20 )
points(1:80, y=rep(0,80), col = mycol[161:240], cex = 2, pch = 20 )

image(matrix(1:25^2,25,25), col = mycol)

# 파레트 다른사람들이 잘 만들어 놓은거 사용하자.
# 미적감각이 난 없다......

heat.colors(4, alpha = 1)
# 4개의 파레트 rgb 정보를 출력

rev(heat.colors(4, alpha = 1))
# 순서 뒤집기

heat.colors(10, alpha = 1)
# 10개의 파레트 만들기

# 파레트를 어떻게 적용할거냐!! 이게 중요하다.

x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = rev(heat.colors(20, alpha = 1)), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = 'white')
# 3번째가 heat.colors 4번째가 등고선

image(x, y, volcano, col = topo.colors(20, alpha = 1), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = 'white')

rainbow(5, s = 0.4, v = 0.3, start = 0, end = 0.05, alpha = 1)



if(!require(RColorBrewer)){install.packages("RColorBrewer"); library(RColorBrewer)}
brewer.pal(9, 'Blues')

x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = brewer.pal(9, 'Blues'), axes = FALSE)

brewer.pal(4, 'BrBG')


display.brewer.all()
# 이걸로 마음에 드는거 찾으면 되는듯.
display.brewer.all_m(cex = 0.5)



if(!require(colorspace)){install.packages("colorspace"); library(colorspace)}
diverge_hcl(7, h = c(246, 40), c = 96, l = c(65, 90))

pal = choose_palette()
pal
a = pal(40)
# pal에 40등분
image(x, y, volcano, col = rev(a), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = 'white')
