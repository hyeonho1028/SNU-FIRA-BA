#plot

?iris

data(iris)
str(iris)
summary(iris)


?plot

plot(iris$Sepal.Length)
plot(iris$Petal.Length)
#아무것도 안 넣었을 때는 x축이 인데스 y축이 Sepal.length가 들어간다.

plot(x = iris$Sepal.Length, y = iris$Petal.Length)
plot(x = iris$Sepal.Length, y = iris$Petal.Length, xlim = c(2, 10), ylim = c(0, 8))
plot(x = iris$Sepal.Length, y = iris$Petal.Length, xlim = c(2, 10), ylim = c(0, 8),
     xlab = 'Sepal_Length', ylab = 'Petal_Length', main = 'iris Sepal-petal plot')

#그래프 점 크기(default = 1)
plot(iris$Sepal.Length, cex = 0.5)
plot(iris$Sepal.Length, cex = 2)

#점종류(default = 1)
plot(iris$Sepal.Length, cex = 0.5, pch = 16)
plot(iris$Sepal.Length, cex = 1, pch = 18)

#점색(default = 1)
plot(iris$Sepal.Length, cex = 1, pch = 18, col = 2)

#그래프 type
plot(iris$Sepal.Length, cex = 1, pch = 18, col = 2, type = 'l')


#그래프 설정
oldpar = par()
par(mfrow = c(2,2))
plot(iris$Petal.Length, ylab = '', main = 'Petal length')
plot(iris$Petal.Length, ylab = '', main = 'Petal length')
plot(iris$Petal.Length, ylab = '', main = 'Petal length')
plot(iris$Petal.Length, ylab = '', main = 'Petal length')
#다르게 설정해서 그릴 수 있다.

#같이 그리기
par(mfrow=c(1,1)) #원래대로
plot(x=iris$Sepal.Length, y=iris$Sepal.Width)
points(iris$Petal.Length, iris$Petal.Width, col = 2, pch = c(16, 1))
lines(iris$Petal.Length, iris$Petal.Width, col = 3)
#지저분한게 그려지는데 이건 오름차순이 필요하다. 사전작업이 필요

#범례 표시하기
legend('bottomright', legend = c('Sepal', 'Petal'), pch = c(16, 1), col = 1:2)


#히스토그램
hist(iris$Sepal.Length)
hist(iris$Sepal.Length, breaks = 20)
hist(iris$Sepal.Length, breaks = 20, freq = FALSE) #y축이 dencity로 바뀜


iris.mean = tapply(iris$Sepal.Length, iris$Species, mean)
barplot(iris.mean)



