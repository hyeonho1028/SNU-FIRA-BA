# 홀수 찾기
oddcount <- function(x) {
  k <- 0  # assign 0 to k
  for (n in x) {
    if (n %% 2 == 1) k <- k + 1 # %% is the modulo operator
  }
  return(k)
}

oddcount(c(1:4, 5, 7))


#7의 배수 찾기
set.seed(2)
x <- matrix(sample(1:100, 20), nr = 5)
seven <- function(x) {
  k <- 0
  l <- nrow(x)
  m <- ncol(x)
  
  for (l in 1:l) {
    for (m in 1:m) {
      if(x[l,m] %% 7 == 0) k <- k + 1
    }
    
  }
  return(k)
}
seven(x)


#7의 배수 찾기
set.seed(2)
x <- matrix(sample(1:100, 20), nr = 5)
seven = function(y) {
  q = y%%7
  return(sum(q==0))
}
seven(x)



# 그냥 ifelse 문 변환
x <- c('F', 'M', 'I', 'F', 'M', 'I')
norman <- function(x) {
  
  x <- ifelse(x == 'F', 1, ifelse(x == 'M', 2, 3))
  return(x)
}
norman(x)

x <- ifelse(x == 'M', 'F', ifelse(x == 'F', 'M', x))
x


# 벡터 인덱싱
f.index = (x=='F')
m.index = (x=='M')
x[f.index]='M'
x[m.index]='F'
x













