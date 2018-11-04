##### 7월 12일 JJJ #####

n = 1000
(1+1/n)^n
exp(1)
x = 1:n
y = (1+1/x)^x
plot(x, y, type = 'l', ylim = c(2.6, 2.8))
abline(h = exp(1), col = 'red')

exp(exp(1))
exp(sqrt(2))

exp(0.1*2-1)

x = seq(-1, 1, length = 100)
beta0 = -1
beta1 = 1
y = exp(beta0+beta1*x)
plot(x, y, type = 'l')
abline(h= 0 , lwd =2)
abline(v= 0 , lwd =2)

x = seq(-1, 1, length = 100)
beta0 = 1
beta1 = 2
y = exp(beta0+beta1*x)
plot(x, y, type = 'l', ylim = c(0,5))
abline(h= 0 , lwd =2)
abline(v= 0 , lwd =2)

x = seq(-1, 1, length = 100)
beta0 = -1
beta1 = -2
y = exp(beta0+beta1*x)
plot(x, y, type = 'l', ylim = c(0,5))
abline(h= 0 , lwd =2)
abline(v= 0 , lwd =2)
# exp == e^() 를 정의하고 그래프를 그려봄


matrix(1:15, 5, 3)
set.seed(1)
X = matrix(runif(15), 5, 3)
X[3,2]
X[1,]
X[4, , drop = F]
Xt = t(X)
Xt %*% X
A = Xt %*% X
B = solve(A)
round(A %*% B, 0)
round(B %*% A, 0)

a = matrix(1:3, 3, 1)
t(a) %*% a
t(X) %*% X
solve(t(X) %*% X)
t(a) %*% (solve(t(X) %*% X)) %*% a

u = matrix(c(0, 1, -1), 3, 1)
x = matrix(c(1, 0, 1/2), 3, 1)
sigma = matrix(c(1, 0.5, 0, 0.5, 1, 0.3, 0, 0.3, 1), 3, 3)
exp(-1/2 * t(x-u) %*% solve(t(sigma)) %*% (x-u))

# 형렬과 전치행렬 그리고 역행렬 & 행렬식...

x = seq(0, 10, length = 1000)
y = ppois(x, lambda = 1)
plot(x, y, type = 's')
abline(h = 1, col = 'red', lty = 2)

x = seq(0, 10, length = 1000)
y = ppois(x, lambda = 3)
plot(x, y, type = 's')
abline(h = 1, col = 'red', lty = 2)
lines(x, y, type = 's', col = 'green')

n = 1e+4
z = rexp(n)
x = c()
for (i in 1:n)
{
  idx = sample(1:n, 25)
  x[i] = mean(z[idx])
}
hist(x)

n = 1e+4
z = runif(n)
x = c()
for (i in 1:n)
{
  idx = sample(1:n, 25)
  x[i] = mean(z[idx])
}
hist(x)

gamma(4)

par(mfrow=c(1,2))
x = seq(0, 10, length = 10000)
plot(x, dgamma(x, shape =2, scale =0.5), xlim = c(0, 10), ylim = c(0, .8))
plot(x, dgamma(x, shape =8, scale =0.5), xlim = c(0, 10), ylim = c(0, .8))


if(!require(mvtnorm)){install.packages("mvtnorm")}
n = 50
mu.vec = c(1,1/2)
Sigma.mat = matrix( c(1,0.5,0.5,2),2,2)
x1 = x2 = seq(-3,3, length = n)
z <- matrix(0,n,n)
for (i in 1:n)
  for (j in 1:n)
    z[i,j] <- dmvnorm(c(x1[i],x2[j]), mu.vec, Sigma.mat)
contour(x1,x2,z)
if(!require(rgl)){install.packages("rgl")}
persp3d(x1,x2,z, col = 'green')

if(!require(mvtnorm)){install.packages("mvtnorm")}
n = 50
mu.vec = c(-1,1/2)
Sigma.mat = matrix( c(1,0.5,0.5,2),2,2)
x1 = x2 = seq(-3,3, length = n)
z <- matrix(0,n,n)
for (i in 1:n)
  for (j in 1:n)
    z[i,j] <- dmvnorm(c(x1[i],x2[j]), mu.vec, Sigma.mat)
contour(x1,x2,z)
if(!require(rgl)){install.packages("rgl")}
persp3d(x1,x2,z, col = 'green')

if(!require(mvtnorm)){install.packages("mvtnorm")}
n = 50
mu.vec = c(-1,1/2)
Sigma.mat = matrix( c(1,1.41,1.41,2),2,2)
x1 = x2 = seq(-3,3, length = n)
z <- matrix(0,n,n)
for (i in 1:n)
  for (j in 1:n)
    z[i,j] <- dmvnorm(c(x1[i],x2[j]), mu.vec, Sigma.mat)
contour(x1,x2,z)
if(!require(rgl)){install.packages("rgl")}
persp3d(x1,x2,z, col = 'green')
# 1.5는 안된다. 그 이유는 2x2행렬인데 coveriane matrix가 아니다.... 행렬식이 몰러...
















