# 3장 기술통계 실습이다. 기술하고 싶은 거.

##### 이산형 #####
#막대그래프
?VADeaths

barplot(VADeaths, beside = TRUE, col = c("lightblue", "mistyrose", "lightcyan","lavender", "cornsilk"),
        legend = rownames(VADeaths), ylim = c(0, 100))
title(main = "Death Rates in Virginia", font.main = 4)

#원그래프
pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)
names(pie.sales) <- c("Blueberry", "Cherry","Apple", "Boston Cream", "Other", "Vanilla Cream")

#기본
pie.sales
pie(pie.sales)
title(main = "Sales", font.main = 4)

#원그래프 크기, 방향
pie(pie.sales, radius=1, clockwise=T)
# radius 크기이다. default = 0.8
# clockwise 방향이라고한다.
title(main = "Sales", font.main = 4)

#원그래프에 숫자 표시
piepercent<- round(100*pie.sales/sum(pie.sales), 1)
pie(x=pie.sales, labels=piepercent,col=rainbow(length(pie.sales)))
title(main = "Sales", font.main = 4)
legend('topright', names(pie.sales), cex = 0.7, fill=rainbow(length(pie.sales)))
# plot은 col이지만 legend는 fill이다.




##### 연속형#####
#히스토그램
data("faithful")
x<-faithful$eruptions
hist(x)

hist(x, breaks=20)
hist(x, breaks=20, freq=FALSE)
# freq보다 density로 나타내는것이 좋다.



#계급구간 길이의 중요
par(mfrow=c(1,2))

edge1<-seq(from=1,to=6,by=0.4)
edge2<-seq(from=1,to=6,by=1)

hist(x,breaks=edge1,freq=F,xlim=c(0,6),ylim=c(0,0.6),main="h=0.4")
hist(x,breaks=edge2,freq=F,xlim=c(0,6),ylim=c(0,0.6),main="h=1")
# 중간중간 빈칸이 없도록 === 조절하는거 잘하면 된다.

#줄기-잎 그림
stem(faithful$eruptions)


#산점도
plot(iris$Petal.Length,iris$Petal.Width,xlab='Sepal.Length',
     ylab='Sepal.Width',cex.lab=1,cex.axis=1,type='n',cex=2)
# type = 'n' 그래프는 그리지마. 하얀 그래프 도면만들깅
# cex : 점크기

points(iris$Petal.Length[iris$Species=='setosa'],
       iris$Petal.Width[iris$Species=='setosa'],col='red',lwd=2)

points(iris$Petal.Length[iris$Species=='versicolor'],
       iris$Petal.Width[iris$Species=='versicolor'],col='blue',lwd=2)

points(iris$Petal.Length[iris$Species=='virginica'],
       iris$Petal.Width[iris$Species=='virginica'],col='green',lwd=2)

##### 기술통계 #####

#평균 분산
n=length(faithful$eruptions)
sum((faithful$eruptions-mean(faithful$eruptions))^{2})/(n-1)
var(faithful$eruptions)

sqrt(var(faithful$eruptions))
sd(faithful$eruptions)
# 같네


#분위수
pquant=quantile(faithful$eruptions,probs=c(0.25,0.5,0.75))
pquant
pquant[3]-pquant[1]
IQR(faithful$eruptions)

max(faithful$eruptions)-min(faithful$eruptions)
rfaithful=range(faithful$eruptions)
rfaithful[2]-rfaithful[1]

##### outlier detection #####
iqr.val=IQR(faithful$eruptions)
c(pquant[1]-1.5*iqr.val, pquant[3] +1.5*iqr.val)

faithful$eruptions[faithful$eruptions > pquant[3] +1.5*iqr.val]
faithful$eruptions[faithful$eruptions < pquant[1] -1.5*iqr.val]

summary(faithful$eruptions)




#Boxplot
par(mfrow=c(1,2))
boxplot(faithful$eruptions,main='Eruptions')
boxplot(faithful$waiting,main='Waiting')

##### summary 를 시각화한게 box-plot라고 할 수도 있다. #####


?dbeta
# dbeta(xvec, shape1 = 2, shape2 = 5) 
# 왼쪽이 크면 오른쪽으로 기울고 오른쪽이 크면 왼쪽으로 기운다.
# shape1, shape2	non-negative parameters of the Beta distribution


##### 왜도, 첨도 #####
xvec=seq(0.01,0.99,0.01)

par(mfrow=c(1,2))
plot(xvec,dbeta(xvec,2,5),type='l',lwd=2,xlab='',ylab='')
plot(xvec,dbeta(xvec,7,2),type='l',lwd=2,xlab='',ylab='')
# 왼쪽으로 쏠려있는지 오른쪽으로 쏠려있는지 알 수 있다.
# beta분포가 어떻게 생겼는지 예시를 들면서 보는거....


x1= rbeta(1000, 2, 5)
x2= rbeta(1000, 7, 2)
# beta분포에서 1000개를 뽑았다.

(sum((x1-mean(x1))^3)/length(x1))/(var(x1))^{3/2}
(sum((x2-mean(x2))^3)/length(x2))/(var(x2))^{3/2}
# 세제곱하면 테일이 긴게 확 커지게 된다... 양수가 확 커지고, 음수가 확커지고.


par(mfrow=c(1,1))
xvec=seq(-4,4,0.01)
plot(xvec,dnorm(xvec,0,1),type='l',lwd=2,xlab='',ylab='', 
     main="Normal and t-distribution")
# 정규분포
lines(xvec,dt(xvec,2),type='l',lwd=2,lty=2, col='red')
# t분포///꼬리가 더 두껍다.

x1= rt(1000, 2)
(sum((x1-mean(x1))^4)/length(x1))/(var(x1))^{2} -3
# 표준정규분포는 3이라는데? 그래서 3빼주는데
# 두껍고 얇고 판단하는듯

##### 왜도와 첨도와 데이터의 의미 #####
# 왜도는 이상값에 대한 부분을 자세히 볼 수 있다.
# 첨도는 평균자체의 의미가 없을 수도 있다. 테일부분이 두꺼우면.
# 분위수를 써야하는 경우가 있다.

##### 이변량 #####
x= faithful$eruptions; y= faithful$waiting
cov(x,y)/(sd(x)*sd(y))
cor(x,y)
plot(x,y,xlab='',ylab='')

# summary 에 skewness와 kurtosis를 추가로 나오게 해보시오