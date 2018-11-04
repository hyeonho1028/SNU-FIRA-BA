# 논리/플로우 차트 에 관하여 배운다.

TRUE & FALSE
TRUE | FALSE
!TRUE
# 논리식의 이해

a = 1
b = 0
if (a < 2)
{
  b = b +1
}

a = 0
x = runif(1)
if (x > 0.5)
{
  a = 1
}
a


a = 3
b = 0
if (a < 2)
{
  b = b + 1
} else 
{
  b = b - 1
}
b

# interpreter 언어의 특징 1 + 3 \n *4는 실행이 안됨.
1 + 3 *
  4


# Loop
a = 1
for (i in 2:4)
{
  a = a + 1  
}
# 위의 경우 i는 2부터 시작하며, 2, 3, 4 즉 3회 반복한다

a = 0
for (i in 1:3)
{
  a = a + i
}
a

# Loop2
x = 0
v = c(2,4,6,8)
for (i in v)
{
  x = x + i
  print(x)
}

# Loop3
x = 0
for (i in 1:3)
{
  for (j in 1:2)
  {
    x = x + i + j
  }
}

# Loop4(break 와 stop의 차이)
x = 0
for (i in 1:3)
{
  for(j in 1:4)
    if (x > 15) stop()
    x = x + i + j
}
x

x = 0
for (i in 1:3)
{
  for(j in 1:4)
    if (x > 15) break
    x = x + i + j
}
x

# Loop5 while문
conv = TRUE
while(conv)
{
  i = i + 1
  if (i >= 1000) conv = FALSE
}


# Loop6
while(TRUE)
{
  i = i + 1
  if (i >= 1000) break
}



################################### Function ###################################
# Function1
testFunction = function(x1,x2)
{
  v = x1^2 + x2
  return(v)
}
testFunction(x1=1,x2=2) # Function1 execute

# Function2
testFunction = function(x1,x2)
{
  v1 = x1^2 + x2
  v2 = x1^2 - x2
  return( c(v1,v2) )
}
testFunction(x1=1,x2=2) # Function2 execute


# 전역변수와 지역변수에 대한 이해가 필요하다
testFunction = function(x1,x2)
{
  v1 = x1^2 + x2
  v2 = x1^2 - x2 + x
  return( c(v1,v2) )
}
x=0
testFunction(x1=1,x2=2) # Function2 execute
x=1
testFunction(x1=1,x2=2) # Function2 execute
# 전역변수 x가 testFunction의 값을 다르게 만든다. 의도적일수도, 비의도적일수도 있다.
# function에서의 선언된 변수만 쓰는 것을 추천한다.

# Function3 execute
s_colMean = function(x)
{
  if ( class(x) != "matrix") 
    stop('x is not matrix')
  v = rep(0, ncol(x))
  
  for ( i in 1:ncol(x))
  {
    v[i] = mean( x[,i] )
  }
  return(v)  
}
x = matrix(1:10, 5, 2)
s_colMean(x) # Function3 execute


################################## read.table ##################################
View(CO2)
getwd()
write.csv(CO2, file = 'CO2.csv', row.names = FALSE)
head(CO2)
str(CO2)

a = read.csv('CO2.csv', header = TRUE)














