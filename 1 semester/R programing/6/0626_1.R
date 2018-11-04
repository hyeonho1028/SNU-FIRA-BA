# 전시간 리뷰

rep(1:3, 1:3)

x=3:6
length(x)

1:length(x)

# x.length()를 length(x)로

1:10-1           # 콜론이 먼저 적용된다.

# NA와의 연산은 NA를 반환한다.
# []의 연산도 마찬가지이다.
# which는 true 위치 반환
# %in% A %inT B A안에 B가 있는지 판단 true false로 판단
# match 어디에 있는지 알려준다. 없으면 NA가 return
# matrix는 만들기는 쉽다. 
y = matrix(c(1,3,4,5,1,3,4,1),4,2)
length(y) # 메트릭스의 length는 원소의 개수이다.

# 특별한 메트릭스 = square matrix(정방행렬) \ 에 있는거 대각행렬 대각원소
# 대각원소가 1이고 대각원소가 아닌 원소가 0이면 대각행렬
# 많이 쓰여서 함수로 만들어놨다. diag()

diag(rep(1,5))
diag(5)
#       [,1] [,2] [,3] [,4] [,5]
# [1,]    1    0    0    0    0
# [2,]    0    1    0    0    0
# [3,]    0    0    1    0    0
# [4,]    0    0    0    1    0
# [5,]    0    0    0    0    1

a = matrix(1:10, 5, 2)
ncol(a)
b = a[,-1]
ncol(b)
class(b)
# class가 matrix가 아닌 integer로 되있다.
b = a[,-1, drop=FALSE] # 막는방법

# matrix는 한가지의 data_type밖에 못다룬다. why? 속도의 향상을 위해서
# 그래서 data.frame를 통해 여러개의 data type을 다루게 할 수 있다.
# $와 [[]]를 통해 사용할 수 있다.

# cbind와 rbind 이름을 찾아서 붙인다.(가장큰 특징)

# list도 마찬가지로 여러개의 data type을 다룰 수 있다.
# 이름도 넣을수 있고, 안 넣을 수도 있고 list를 이해하기 위해서는 chain구조라는
# 것을 알아야한다. 

jn <- list('joe', 55000, TRUE)
# jini <- vector(1,2,3) ??
# []을 쓰면 chain a[2:3] 이름을 참조해서 가져오는 새로운 리스트를 생성. 여러개 가능
jn[1:3]<-1:3
jn

# Factor의 값은 숫자이다.
# 쓰는 이유는 table에서 levels에 대해서 또는 index에 대해서

# 이런 객체들을 언제 써야하는가.


############################# 오브젝트 타입의 변환 #############################

a = matrix(1:10, 5, 2)
a[c(1,3,5),]
a[c(T,F,T,F,T),]

# matrix에서 vector로 변환
b <- c(a)                 # vector안에 넣기
b
drop(a[-1, drop=FALSE])   # 관습적으로 drop쓴다. 
str(b)

# vector에서 factor로 변환
a = c('tommy', 'jimmy', 'jane')
b = as.factor(a)
b

# factor에서 integer로 변환
c(b)
str(c(b))


# matrix로의 변환
a = data.frame(1,2)
b <- as.matrix(a)
class(a)
class(b)

a = data.frame(V1=1,V2='a')
b <- as.matrix(a)
class(a)
class(b)
a
b
class(b[1,1])
# matrix로 바꾸면 강제로 1이 character로 바뀐다.

# 컬럼/로우 이름 바꾸기
a = matrix(1:10, 5, 2)
colnames(a) = c('x1','x2')
rownames(a) = c('r1', 'r2', 'r3', 'r4', 'r5')
a

# 붙이는 함수
paste0('r', 1)
paste0('r', 1:5)
rownames(a) = paste0('r', 1:5) # 동일하다
rownames(a)
colnames(a)

paste('r', 1:5, sep = "+")
paste('r', 1:5, "+")

# data.frame에서의 colname확인하기.
b <- data.frame(a)
names(a)
names(b)
names(b) <- c('v1', 'v2')
rownames(b)

# data.frame에서 list로 변환 unclass()
a<-data.frame(a)
class(a)
b <- unclass(a)
class(b)
b