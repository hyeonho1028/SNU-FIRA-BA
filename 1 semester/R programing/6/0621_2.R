y[c(-2, -3)]
y[-c(2, 3)] #동일


x1 <- c(5,0,-4,2)
x2<-c(2,1, 1)
x1/x2


x <- 1:10
y <- 1:5
x <- 11
x %/% y
x %% y

x^y


x %% c(2,1,2,2,3)

6<=7
6!=7
6==7

1:10 <= rep(5,10)

1:10 <= 5

set.seed(1)
n=10000000
x <- runif(n)
length(x[x>0.5])/n

x <- c(3, 1, 4, 1)
y <- x[x>5]
print(y)

x <- c('a', 'b')
y <- x[x=='c']
print(y)
length(y) # NA값이 섞여 있으면 계산이 안되는데 이럴때 길이를 보고 그 다음을 계산.

# which 함수
x <- c(1:4, NA, 5:8)
x
x<=4
which(x<=4)
x[which(x<=4)]
x[x<=4]


# %in% 이건 진짜 좋다. 내가 쓰던거고 배울때도 강조한다.
c(1, 5, 3) %in% c(3, 2, 1)
x <- c(3, 1, 4, 1)
x[x %in% c(2, 1, 4)]

# match 이건 어디에 들어있느냐가 궁금할때 쓴다.
match(1, c(2, 1, 4))
match(c(1,4), c(2, 1, 4))
x <- c(3, 1, 4, 1)
match(x, c(2, 1, 4))


# match에 match(x, y)를 보면 y는 유니크해야된다. 왜나하면 키같은 역할을 해야되기
# 때문이다. 그러면 유니크한지는 어떻게 확인하냐 그건 unique함수를 사용하면 좋다.
x<-rep(c('a','b'), 4)
unique(x)
length(x) == length(unique(x)) # 유니크하지 않다는 점을 알 수 있다. but
                               # 더 좋은게 있을 수  있으니 알아보자.


is.na(NA)  # NA특징 : NA가 모든 섞인(속한) 연산은 모두 NA가 된다. 
           # NA찾는방법
           # 결과 TRUE
           # NA제외후 연산 na.rm = T

Inf > 10   # 기본적으로 Inf는 true 반환
Inf > Inf  # 기본적으로 Inf끼리는 false 반환
Inf == Inf # True
Inf + Inf  # Inf
Inf - Inf  # NaN 정의가 되지 않는다.
0 / 0      # NaN 정의가 되지 않는다.
1 / 0      # Inf



#################################### matrix ####################################

# matrix(기본적으로 열을 먼저 채운다.)
y <- matrix(1:4, nrow=2)
y <- matrix(c(1, 2, 3, 4), nrow=2)

# 행을 먼저 채우는 방법은 byrow=T를 하면 된다.
y <- matrix(c(1, 2, 3, 4), nrow=2, byrow = T)

matrix(1:4, 2, 2)[3]
matrix(1:4, 2, 2, byrow = T)[3]


# matrix의 특징
y <- matrix(c(1,3,4,5,1,3,4,1), 4, 2)
y[1,1]
y[,1]
y[-2,]
y[1:2,]


class(y)                    # class를 이용한 matrix확인하기
class(y) == 'matrix'
class(y[,1])                # numeric 결과가 나오는데 이는 R에서의 자동변환이다.
class(y[,1])                # numeric 결과를 똑같이 유지하고 싶을때는
y[,1]                       # numeric으로 바뀌는 것이 내가 원하는 바가 아니다.
y[,1, drop = FALSE]   
class(y[,1, drop = FALSE])  # numeric가 아닌 matrix로 유지된다.
                            # R은 기본적으로 열벡터이다. 누워있지 않은 벡터이다.




dim(y)                      # dim 을 활용한 행*열 알기. 4행 2열
ncol(y)                     # 컬럼의 개수를 반환
nrow(y)                     # 로우의 개수를 반환


ncol(y[1,])                 # 행렬이 아니기 때문에 ncol이 안먹힘. NULL반환
ncol(y[1, , drop = FALSE])  # 행렬을 유지하기 때문에 ncol이 먹힘. 2 반환 



one = rep(1, 4) 
z <- matrix(c(5:8, rep(-1, 4), rep(0, 4)), 4, 3)
cbind(one, z)               # 컬럼으로 합치기

one <- c(1, 2)
cbind(one, z)               # 짧을때 one이 2번 반복

one <- c(1, 2, 3)
cbind(one, z)               # 오류 발생하는데 이게 의도인지, 실수인지 파악해야됨.

z = rbind(2, z)
z                           # 행합치기


a = c()
a = c(a, 'init')
a                           # a에 재 할당

rm(list = 'a')
a = c(a, 'init')            # error 발생, a가 존재하지 않기 때문이다.
a = NULL                    # a를 미리 선언하면 가능하다.
a = c(a, 'init')
a                           # 가능하다.


a=0                         # a는 벡터 a[1]만 할당해준다.
a[10] <- 22                 # a[10]에 값을 할당하는 것이 가능하다.
a                           # 그러나 2~9의 값은 NA값이 된다.

a= NULL                     # 미리 초기값이 선언 되어야 한다.
a <- rbind(a, 1:3)          
a                           # 이런식으로 밑으로 계속 결과를 쌓아나갈 수 있다.






################################# 데이터프레임 #################################

# matrix는 벡터이다. 모든 원소의 type은 동일해야 한다는 제약조건이 있다.

x <- 1:10      
typeof(x[1])     # type은 integer이다.
x[1] = 'a'       # charater로 변경한다.
typeof(x[2])     # x[2]도 charater로 변경되었다.
typeof(x)        # 벡터는 한가지의 type 만 가질 수 있다.
                 # 한가지의 type만 가지는 것은 빠른속도의 비결임.
                 # 똑같은 크기를 가지고 있어야지, 빠르게 주소(인덱스)를 찾을 수 있다.
                 # 한가지 변경했을 때 모두 바꿔주는걸 auto캐스팅 이라고 한다.

x <- matrix(1:4, 2, 2)
print(x)         # 마찬가지로 integer형이다.
x[2,2]<-'b'      # charater로 변경했다.
print(x)         # matrix가 charater형으로 변경되었다.



kids = c('Jack', 'Jill')
ages = c(12, 10)
d = data.frame(kids, ages, stringsAsFactors = F)
d = data.frame(x1=kids, x2=ages, stringsAsFactors = F)
                # 컬럼명 변경가능하다. x1과 x2로
d

str(d)          # d의 structure를 보는 함수( chr, num으로 다른것을 알 수 있다.)
                # 2 obs. of 2 variables도 알 수 있다. 2행 2열이라는 점을 알려준다.

d[1,1]          # 1행 1열 볼 수 있다.
d[2,2]          # 2행 2열 볼 수 있다.
class(d[,1])    # character
class(d[,2])    # numeric    data.frame은 다른 class를 가지고 있다.

class(d[1,])    # data.frame이라는 class를 가지고 있다.
typeof(d[1,])   # list라는 class를 가지고 있다.


d$ages          # $라는 기호의 사용 ~ 가독성이 좋다.
names(d)        # 컬럼명을 확인한다.
d[1,]           # data.frame의 class가 그대로 유지된다.

A = data.frame(x1 = rep(0,10), x2 = rep(1, 10))
B = data.frame(x2 = rep(0,10), x1 = rep(1, 10))

AB<-cbind(A,B)  # cbind는 그냥 붙인다. 
AB

AB<-rbind(A,B)  # rbind는 variable name을 참조해서 rbind를 한다.
AB

A = data.frame(x1 = rep(0,10), x2 = rep(1, 10))
B = data.frame(x2 = rep(0,10), x3 = rep(1, 10))

AB<-rbind(A,B)  # x3를 참조할 수 없기 때문에 rbind할 수 없다.(공통된 변수가 필요)
AB



##################################### List #####################################

j <- list(names = 'Joe', salary = 55000, union = T)
                # list라는 함수를 사용해야한다.
j               # list는 체인형식으로 데이터를 관리한다.

j <- list(names = 'Joe', salary = c(55000,1), union = T)
j               # salary가 2개도 된다.

jn <- list('Joe', c(55000,1), T)
jn              # 이름 대신 숫자로 바뀐다.

jnn <- list()   # 빈 list가 생긴다.
jnn <- vector(mode = 'list', length = 10)
                # 10개의 리스트를 만들 수 있다. 
                # 만드는 건 쉽지만 슬라이싱, 인덱싱이 어려운 리스트

j$salary        # data.frame 같이 컬럼명으로 찾는다.
j[['salary']]   # $와 동일하다.
j[[2]]          # $와 [[컬럼명]]과 동일하다.
                # [[]] 브라켓2개를 쓰는 경우는 오브젝트에 참조한다는 내용

j['salary']     # 1개의 []만 쓰는 경우 list가 된다. 1개만 쓰면 체인을 다 참조
j[2]            # 위와 동일


j[c('salary', 'union')]
j[2:3]          # 위의 2개의 체인을 보는 내용과 동일하다.
j[[2:3]]        # 기본적으로 [[]]는 오브젝트 한개를 본다는 내용인데 2개는 불가능


j <- list(names = c('Joe', 'nick'), salary = matrix(1:4,2,2), union = T)
j[[1]]          # Joe와 nick
j[[1]][1]       # Joe
j[[1]][2]       # nick

j[['salary']][,2, drop =F]
j[['salary']][3]   # 위와 동일한 경우. 벡터이기 때문에 벡터특성을 적용가능함


j$history <- 1:10  # list의 경우 체인을 추가하고, 제거하는 edit 밖에 없다.
                   # 순서는 차례대로 적용된다. 즉 4번으로 추가된다.

j[[1]] <- 'Yoon'   # 1번체인의 오브젝트가 'Yoon'으로 변경된다.

j$salary <- NULL   # NULL을 넣을경우 제거 된다.

j                  # $salary가 제거 되었으므로, union이 2번 history가 3번이 된다.





##################### 데이터프레임은 리스트라고 할 수 있다. #####################

d = data.frame(kids, ages, stringsAsFactors = F)
class(d[[1]])          # charater이 나온다.
d$ages <- c('a', 'b')  # 변경된다.
d

d$kids <- NULL         # kids컬럼이 사라진다.
d
d[2]
d[1,1]                 # data.frame가 느린이유는 list의 특성이기 때문이다.





a <- c('Jack', 'Jill', 'nick', 'lichard')
a[c(2,1,4,3)]    # 참조한 순서대로
a[c(2,1,1,3)]    # 유니크할 필요없다.



#################################### Factor ####################################

a <- c('Jack', 'Jill', 'nick', 'richard')
af <- factor(a)
str(a)          # chr 형이다.
af
levels(af)      # factor은 level을 가지고 있다. level이 레퍼런스가 된다.
                # 레벨은 순서대로

a <- c('Jack', 'lichard', 'Jill', 'nick', 'richard')
af <- factor(a)
levels(af)      # factor은 level을 가지고 있다. level이 레퍼런스가 된다.

as.numeric(af)  # factor에 대한 이해하기
                # 중요한건 펙터를 이용해서 slicing를 할 수 있다.

cand = c('Jack', 'Jill', 'nick', 'richard')
              
a = c('Jack', 'nick', 'richard', 'Jack', 'richard')
table(a)        # 빈도 체크 하는 함수

af = factor(a, levels = cand)
table(af)       # 0에 대한 level을 체크할 수 있다. 0 counting 가능!


################################################################################

head(iris)
x<-c(T, F, T, F, F)
head(iris[x])
x<-c(1, 4)
head(iris[x])

rm(list=ls())
memory.limit()
gc()
